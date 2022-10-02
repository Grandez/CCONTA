OBJTransfers   = R6::R6Class("CONTA.OBJ.TRANSFER"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       initialize    = function(factory, type = 0, child = FALSE) {
         super$initialize(factory, TRUE)
         private$tblAccounts  = factory$getTable("Accounts")
         private$tblTransfers = factory$getTable("Transfers")
         private$dfAccounts   = tblAccounts$table()
      }
      ,getAccounts     = function (all = FALSE) {
          if (all) return (dfAccounts)
          dfAccounts[dfAccounts$active == 1,]
      }
      ,add = function(...) {
         data = list(...)
         self$exception = NULL
         data$id = factory$tools$getID()
         if (!is.null(data$note)) {
            data$note = trimws(data$note)
            if (nchar(data$note) == 0) data$note = NULL
         }
         tryCatch({
            tblTransfers$add(data, isolated = TRUE)
            data$id
         }, error = function (cond) {
            self$exception = cond
            browser()
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
      #  dfGroups      = NULL
      # ,dfMov         = NULL
      # ,dfMethods     = NULL
      # ,tblMethods    = NULL
      # ,tblGroups     = NULL
      # ,tblCategories = NULL
      # ,tblMovements  = NULL
       tblAccounts   = NULL
      ,tblTransfers  = NULL
      ,dfAccounts    = NULL
      # ,mov           = list(type = 1, mode = 1)
      # ,addTags = function() {
      #    tags = strsplit(mov$tags, "[,;]")
      #    tags = tags[[1]]
      #    grp = dfGroups[dfGroups$id == mov$group, "name"]
      #    dfc = tblCategories$table(idGroup = mov$group, id = mov$category)
      #    cat = dfc[1, "name"]
      #    tags = c(grp, cat, tags)
      #    tags = unique(tags)
      #    for (idx in 1:length(tags)) {
      #       tblTags$add(list(id = mov$id, seq = idx, tag = tags[idx]))
      #    }
      # }
      # ,getMethodName = function (record) {
      #    if (is.null(dfMethods)) private$dfMethods = tblMethods$table()
      #    method = dfMethods[dfMethods$id == record[1,"idMethod"]]
      #    if (nrow(method) == 0) return (as.character(record[1,"idMethod"]))
      #    as.character(method[1,"name"])
      # }
   )
)

