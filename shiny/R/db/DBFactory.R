BBDDFactory <- R6::R6Class("CCONTA.BBDD.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       dict       = DBDict
      ,print      = function()     { message("Databases Factory") }
      ,initialize = function(source="prod") {
         private$DB = connect(source)
         private$objects = HashMap$new()
          # data = "base"
          # if (!missing(base)) data = base
          # private$lstdb$dbBase  = connectFromList(data)
          # private$lstdb$dbData  = connectFromTable(10, 101)
          # private$lstdb$dbUser  = connectFromTable(10, 102)
       }
      ,finalize   = function()     {
         message("DBFactory finalize")
         DB$finalize()
      }
      ,getDBBase  = function()     { lstdb$dbBase }
      ,getDBData  = function()     { lstdb$dbData }
      ,getDBUser  = function()     { lstdb$dbUser }
      ,getDB      = function()     { lstdb$dbAct  }
      ,setDB      = function(info) {
          if (missing(info)) stop("Se ha llamado a setDB sin datos")
          if (!is.null(lstdb$dbAct)) lstdb$dbAct$disconnect()
          private$lstdb$dbAct = connect(info)
          private$objects     = YATABase::map()
          private$dbID        = info$id
          invisible(self)
      }
      ,getID      = function()     { private$dbID   }
      ,getTable   = function(name, force = FALSE) {get(name, force) }
      ,get        = function(name, force = FALSE) {
         if (is.null(tables[name])) stop(paste("Tabla", name, "no definida"))
         if (force) return (createObject(name))

         if (is.null(private$objects$get(name))) {
            obj = createObject(name)
            private$objects$put(name, obj)
         }
         private$objects$get(name)
      }
   )
   ,private = list(
       lstdb   = list()
      ,DB      = NULL
      ,dbID    = NULL
      ,objects = NULL
      ,connect          = function(source) {
         dbname = ifelse(source == "test", "CCONTA_TEST", "CCONTA")
         info = list( username = "CCONTA",    password = "cconta"
                                 ,host     = "127.0.0.1", port     =  3306
                                 ,dbname   = dbname)
        MARIADB$new(info)
      }
      ,createObject     = function(name) {
          eval(parse(text=paste0("TBL", name, "$new(name, DB)")))
      }
      ,connectFromList  = function(base) {
          if (!is.list(base)) {
               sf   = system.file("extdata", "yatadb.ini", package=packageName())
               cfg  = YATABase::ini(sf)
               base = cfg$getSection("base")
          }
          connect(base)
      }
      ,connectFromTable = function(group,subgroup) {
          tbl = getTable("Parameters")
          df = tbl$table(group = group, subgroup = subgroup)
          data = tidyr::spread(df[,c("name", "value")], name, value)
          connect(as.list(data))
      }
      ,tables = list(
          Expenses   = "EXPENSES"
         ,Methods    = "METHODS"
         ,Groups     = "GROUPS"
         ,Categories = "CATEGORIES"
         
      )
   )
)

