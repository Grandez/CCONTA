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
      ,getCategories = function (group = 0) { 
         if (group == 0) tblCategories$table(active = 1) 
         else            tblCategories$table(idGroup = group, active = 1) 
       }
      ,getMethods    = function ()          { tblMethods$table(active = 1) }
      ,getExpenses   = function ()          { getMovements (type =  1) }
      ,getIncomes    = function ()          { getMovements (type = -1) }
      ,getMovements  = function (...)  {
         args = unlist(list(...))
         args = args[args != 0]
         filter = list(active=1)
         if (length(args) > 0) filter = jgg_list_merge(filter, as.list(args))
         private$dfMov = tblMovements$table(filter)
         dfMov
      }
      ,getMovementsFull  = function (...)  {
         df = getMovements(...)
         if (nrow(df) == 0) return (df)
         df$tags = NA
         df$group    = as.character(df$idGroup)
         df$category = as.character(df$idCategory)
         df$method   = as.character(df$idMethod)
         for (idx in 1:nrow(df)) {
            df[idx, "method"] = getMethodName(df[idx,]) 
            dfTags = tblTags$table(id = df[idx, "id"])
            vTags  = as.vector(dfTags[,"tag"])
            idx = 0
            tags = c()
            while (idx < length(vTags)) {
               if (idx == 0) df[idx, "group"]    = vTags[1]
               if (idx == 1) df[idx, "category"] = vTags[2]
               if (idx >  1) tags = c(tags, vTags[idx + 1])
               idx = idx + 1
            }
            if (length(tags)) df[idx, "tags"] = paste(vTags, collapse=",")
         }
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
      ,dfMethods     = NULL
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
            tblTags$add(list(id = mov$id, seq = idx, tag = tags[idx]))
         }
      }
      ,getMethodName = function (record) {
         if (is.null(dfMethods)) private$dfMethods = tblMethods$table()
         method = dfMethods[dfMethods$id == record[1,"idMethod"]]
         if (nrow(method) == 0) return (as.character(record[1,"idMethod"]))
         as.character(method[1,"name"])
      }
   )
)

