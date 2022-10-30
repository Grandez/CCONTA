BBDDFactory <- R6::R6Class("CCONTA.BBDD.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       print      = function()     { message("Databases Factory") }
      ,initialize = function(source="prod") { private$DB = connect(source) }
      ,finalize   = function()     { DB$finalize()  }
      ,getDB      = function()     { private$DB     }
      ,getDBInfo  = function()     { private$dbInfo }
      ,setDB      = function(dbname) {
          if (missing(info)) stop("Se ha llamado a setDB sin datos")
          if (!is.null(DB) && dbname != dbInfo$dbName) DB$disconnect()
          if (dbname != dbInfo$dbName) private$DB = connect(dbname)
          invisible(self)
      }
      ,getTable   = function(name, force = FALSE) {
         if (force) return (createObject(name))

         if (is.null(private$objects$get(name))) {
            obj = createObject(name)
            private$objects$put(name, obj)
         }
         private$objects$get(name)
      }
   )
   ,private = list(
       DB      = NULL
      ,objects = NULL
      ,dbInfo  = list( username = "CCONTA"
                      ,password = "cconta"
                      ,host     = "127.0.0.1"
                      ,port     =  3306
                      ,dbName   = "CCONTA") 
      ,connect          = function(source) {
         dbname = ifelse(source == "test", "CCONTA_TEST", "CCONTA")
         private$dbInfo$dbName = dbname
         private$objects = HashMap$new()
         MARIADB$new(dbInfo)
      }
      ,createObject     = function(name) {
          eval(parse(text=paste0("TBL", name, "$new(name, DB)")))
      }
   )
)

