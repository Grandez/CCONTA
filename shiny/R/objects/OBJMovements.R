OBJMovements   = R6::R6Class("CONTA.OBJ.MOVEMENTS"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       initialize    = function(factory, type = 0, child = FALSE) {
         super$initialize(factory, TRUE)
         private$tblMethods    = factory$getTable("Methods")
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         private$tblMovements  = factory$getTable("Movements")
         private$tblTags       = factory$getTable("Tags")
         if (type == 0) private$dfGroups = tblGroups$table()
         if (type >  1) private$dfGroups = tblGroups$table(type = type)
      }
      ,getGroups     = function (type = 0) {
          df = dfGroups[dfGroups$active == 1,]
          if (type != 0) df = df[df$type == type,]
          df
      }
      ,getCategories = function (group = 0) { tblCategories$table(idGroup = group, active = 1) }
      ,getMethods    = function ()          { tblMethods$table(active = 1) }
      ,getExpenses   = function ()          { getMovements ( 1) }
      ,getIncomes    = function ()          { getMovements (-1) }
      ,getMovements  = function (type = 0)  {
         if (is.null(dfMov)) private$dfMov = tblMovements$table(active = 1)
         if (type > 0) df = dfMov[dfMov$type > 0,]
         if (type < 0) df = dfMov[dfMov$type < 0,]
         df
      }
      ,set = function (...) {
          private$mov = jgg_list_merge(mov, list(...))
          invisible(self)
      }
      ,add = function(...) {
         private$mov     = jgg_list_merge_list(private$mov, list(...))
         private$mov$id = factory$tools$getID()
         
         dt = private$mov$date
         private$mov$year  = lubridate::year(dt)
         private$mov$month = lubridate::month(dt)
         private$mov$day   = lubridate::day(dt)
         
         tryCatch({
            tblMovements$db$begin()
            tblMovements$add(private$mov)
            addTags()
            tblMovements$db$commit()
            private$mov$id
         }, error = function (cond) {
            browser()
            tblMovements$db$rollback()
            0
         })
      }
      # ,get = function(mask = 0, all = FALSE) {
      #    # df = tblExpenses$table()
      #    # if (!all) df = df[df$active == 1,]
      #    # if (mask > 0) df = df %>% filter(bitwAnd(type, mask) > 0)
      #    # df
      # }
   )
   ,private = list(
       dfGroups      = NULL
      ,dfMov         = NULL
      ,tblMethods    = NULL
      ,tblGroups     = NULL
      ,tblCategories = NULL
      ,tblMovements  = NULL
      ,tblTags       = NULL
      ,mov           = list(type = 1, mode = 1)
      ,addTags = function() {
         tags = strsplit(mov$tags, "[,;]")
         tags = tags[[1]]
         grp = dfGroups[dfGroups$id == mov$group, "name"]
         dfc = tblCategories$table(idGroup = mov$group, id = mov$category)
         cat = dfc[1, "name"]
         tags = c(grp, cat, tags)
         tags = unique(tags)
         for (idx in 1:length(tags)) {
            tblTags$add(list(id = mov$id, tag = tags[idx]))
         }
      }
   )
)

