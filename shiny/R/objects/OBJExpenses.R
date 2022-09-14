OBJExpenses = R6::R6Class("CONTA.OBJ.EXPENSES"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
      initialize = function(factory) {
         super$initialize(factory)
         private$tblMethods    = factory$getTable("Methods")
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         private$tblExpenses   = factory$getTable("Expenses")
      }
      ,getMethods    = function(all=FALSE)          { getTable(tblMethods, all) }
      ,getGroups     = function(all=FALSE)          { getTable(tblGroups,  all) }
      ,getCategories = function(group, all = FALSE) { getTable(tblCategories, all, idGroup=as.integer(group)) }
      ,setGroup = function(id) { 
         private$expense$group = id
         invisible(self)
      }
      ,add = function(...) {
         private$expense = jgg_list_merge_list(private$expense, list(...))
         private$expense$id = factory$tools$getID()
         dt = private$expense$date
         private$expense$year  = lubridate::year(dt)
         private$expense$month = lubridate::month(dt)
         private$expense$day   = lubridate::day(dt)
         
         tryCatch({
            tblExpenses$db$begin()
            tblExpenses$add(private$expense)
            addTags()
            tblExpenses$db$commit()
            private$expense$id
         }, error = function (cond) {
            browser()
            tblExpenses$db$rollback()
            0
         })
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
      ,addTags = function() {
         tags = strsplit(expense$tags, "[,;]")
         tags = tags[[1]]
         # Hacerlas unicas
         if (length(tags) == 0) return()
         for (idx in 1:length(tags)) {
            tblTags$add(id = expense$id, tag = tags[idx])
         }
      }
   )
)

