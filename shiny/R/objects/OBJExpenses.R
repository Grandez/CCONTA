OBJExpenses = R6::R6Class("CONTA.OBJ.EXPENSES"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJMovements
   ,public = list(
      initialize = function(factory) {
         super$initialize(factory, 2, TRUE) # 2 = Gastos
         private$tblMethods    = factory$getTable("Methods")
      }
      ,get = function(mask = 0, all = FALSE) {
         df = tblExpenses$table()
         if (!all) df = df[df$active == 1,]
         if (mask > 0) df = df %>% filter(bitwAnd(type, mask) > 0)
         df
      }
   )
   ,private = list(
       tblMethods    = NULL
      ,tblGroups     = NULL
      ,tblCategories = NULL
      ,tblExpenses   = NULL
      ,expense = list(
          id = 0
         ,date = NULL
         ,method = 0
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

