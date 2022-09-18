MARIADB = R6::R6Class("YATA.DB.MYSQL"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       name = "CCONTA"
      ,initialize = function(data) {
           private$map      = HashMap$new()
           private$dbInfo   = data
           private$connRead = connect()
       }
      ,finalize   = function() {
          if (!is.null(connTran)) commit()
          disconnect(connTran)
          disconnect(connRead)
       }
      ,print      = function() {
          db = ifelse(is.null(connRead), "No Connection", paste0(dbInfo$name, " (", dbInfo$dbname, ")"))
          message(db, ": MariaDB Database")
      }
      ,isValid    = function(conn) {
          if (missing(conn)) conn = connRead
          RMariaDB::dbIsValid(conn)
      }
      ,getName    = function ()     { dbInfo$dbname }
      ,connect    = function ()     {
          tryCatch({RMariaDB::dbConnect( drv = RMariaDB::MariaDB()
                                        ,username = dbInfo$user
                                        ,password = dbInfo$password
                                        ,host     = dbInfo$host
                                        ,port     = dbInfo$port
                                        ,dbname   = dbInfo$dbname
                    )
          },error = function(cond) {
              browser()
              SQLError( "DB Connection error", origin=cond$message
                             ,action="connect", rc = getSQLCode(cond)
                             ,sql="connect")
          })
      }
      ,disconnect = function(conn) {
          if (missing(conn)) conn = private$connRead
          if (!is.null(conn) && isValid(conn))  {
              tryCatch({ RMariaDB::dbDisconnect(conn)
          },error = function(cond) {
              SQLError( "DB Disconnect", origin=cond$message
                             ,action="disconnect", rc = getSQLCode(cond)
                             ,sql = "disconnect")
          })
          }
          NULL
      }
      ,begin      = function() {
          if (!is.null(connTran)) {
              SQLError( "Transacciones activas", origin=NULL
                             ,action="begin", rc = getSQLCode(cond)
                             ,sql="begin")
          }
          private$connTran = connect()
          RMariaDB::dbBegin(connTran)
          invisible(self)
      }
      ,commit     = function() {
          if (is.null(private$connTran)) {
              warning("Commit sin transaccion")
              return (invisible(self))
          }
          RMariaDB::dbCommit(connTran)
          private$connTran = disconnect(connTran)
          invisible(self)
      }
      ,rollback   = function() {
          if (is.null(private$connTran)) {
              warning("Rollback sin transaccion")
              return (invisible(self))
          }
          RMariaDB::dbRollback   (connTran)
          private$connTran = disconnect(connTran)
          invisible(self)
      }
      ,query      = function(qry, params=NULL) {
          if (!is.null(params)) names(params) = NULL
          tryCatch({ RMariaDB::dbGetQuery(getConn(), qry, params=params)
              }, error = function (cond) {
                 browser()
                SQLError( "QUERY Error",  origin=cond$message
                               ,action="query", rc = getSQLCode(cond)
                               ,sql=qry)
          })
      }
      ,execute    = function(qry, params=NULL, isolated=FALSE) {
          # isolated crea una transaccion para esa query
          # Si son varias acciones se activa con begin - commit

          if (!is.null(params)) names(params) = NULL
          tryCatch({
              conn = getConn(isolated)
              res = RMariaDB::dbExecute(conn, qry, params=params)
              if (isolated) commit()
          },warning = function(cond) {
               if (isolated) rollback()
               SQLError("EXECUTE", origin=cond$message, sql=qry, action="execute")
          },error = function (cond) {
             browser()
               sqlcode = getSQLCode(cond)
               if (sqlcode == SQL_LOCK) isolated = TRUE
               if (isolated) rollback()
               SQLError( "SQL EXECUTE ERROR",origin=cond$message,sql=qry
                              ,action="execute", rc = getSQLCode(cond))
          })
      }
      ,write      = function(table, data, append=TRUE, isolated=FALSE) {
         over = ifelse(append, FALSE, TRUE)
         tryCatch({
             conn = getConn(isolated)
             res = RMariaDB::dbWriteTable(conn, table, data, append=append, overwrite=over)
             if (isolated) commit()
         }, warning = function(cond) {
#                       yataWarning("Warning SQL", cond, "SQL", "WriteTable", cause=tab#le)
                     stop(paste("Aviso en DB Write: ", cond$message))
         }, error   = function(cond) {
            if (isolated) rollback()
            SQLError( "SQL WRITE TABLE ERROR", origin = cond$message, sql = table
                           ,action = "WriteTable", rc = getSQLCode(cond)
                           ,sql="writeTable")
             })
      }
      ,add        = function(table, values, isolated=FALSE) {
         # inserta en un registro en la tabla
         # values: lista de valores con nombres
         # Los datos a NULL se ignoran
         data = jgg_list_clean(values)
         cols  = paste(names(data), collapse = ",")
         marks = paste(rep("?", length(data)), collapse=",")
         sql = paste("INSERT INTO ", table, "(", cols, ") VALUES (", marks, ")")
         execute(sql, data, isolated)
      }
      ,count      = function(table, filter) {
           sql = paste("SELECT COUNT(*) FROM ", table)
           if (!missing(filter) && !(is.null(filter))) {
               clause = paste(names(filter), "= ? AND", collapse=" " )
               sql = paste(sql, sub("AND$", "", clause))
           }
           df = query(sql)
           as.integer(df[1,1])
        }
    )
   ,private = list(
       dbInfo    = NULL
      ,connRead  = NULL   # Conexion para leer datos
      ,connTran  = NULL   # Conexion para actualizar datos
      ,map       = NULL
      ,base      = NULL
      ,SQL_LOCK  = 1205
      ,getConn   = function(isolated=FALSE) {
         conn = private$connRead
         if (isolated) {
             begin()
             conn = private$connTran
         }
         conn
      }
      ,getSQLCode = function (cond) {
          # Los codigos van al final del mensaje [nnnnn]
          # https://mariadb.com/kb/en/mariadb-error-codes/
          rc = 99999 # Not found
          res = regexpr("\\[[0-9]+\\]", cond$message)
          if (length(res) > 0 && res > 0) {
              end = attr(res,"match.length")[1]
              rc = substr(cond$message,res + 1, res + end - 2)
          }
          rc
      }

   )
)
