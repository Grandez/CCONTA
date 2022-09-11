OBJExpenses = R6::R6Class("JGG.OBJ.EXPENSES"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
      initialize = function(factory) {
         private$tblMethods    = factory$getTable("Methods")
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
      }
      ,getMethods    = function(all=FALSE)          { getTable(tblMethods, all) }
      ,getGroups     = function(all=FALSE)          { getTable(tblGroups,  all) }
      ,getCategories = function(group, all = FALSE) { getTable(tblCategories, all, idGroup=as.integer(group)) }
      ,setGroup = function(id) { 
         private$expense$group = id
         invisible(self)
      }
      ,add = function(...) {
         data = list(account = 0, method = 0, amount = 0, note = NULL, type = 0, active = 1, sync = 0)
         input = list(...)
         data = list.merge(data, input)
         data$id = makeID(0)
         # valida los datos
         # Inserta en la tabla
         # Procesa los tags
         # invalida datos de resumen
         
      }
      ,get = function(all=FALSE) {
         df = tbl$table()
         if (!all) df = df[df$active == 1,]
         df
      }
   )
   ,private = list(
       tblMethods    = NULL
      ,tblGroups     = NULL
      ,tblCategories = NULL
      ,expense = list(
          method = 0
         ,group = 0
         ,category = 0
         ,amount = 0
         ,type = 0
         ,active = 1
         ,sync = 0
         ,note = NULL
         ,tags = NULL
      )
      ,getTable = function(tbl, all, ...) {
         args = list(...)
         if (length(args) > 0) {
            df = tbl$table(args)
         } else {
            df = tbl$table()   
         }
         
         if (!all) df = df[df$active == 1,]
         df
      }
   )
)

