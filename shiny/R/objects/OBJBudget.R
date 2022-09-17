OBJBudget = R6::R6Class("CONTA.OBJ.BUDGET"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
      initialize = function(factory) {
         super$initialize(factory, TRUE)
         private$tblBudget     = factory$getTable("Budget")
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
      }
      ,getMethods    = function(all=FALSE)          { getTable(tblMethods, all) }
      ,getGroups     = function(all=FALSE)          { getTable(tblGroups,  all) }
      ,getCategories = function(group, all = FALSE) { getTable(tblCategories, all, idGroup=as.integer(group)) }
      ,getBudget     = function() {
         df = loadBudgetBase()
         dfb = loadBudget()
         mountBudget(df, dfb)
      }
      # ,add = function(...) {
      #    data = list(account = 0, method = 0, amount = 0, note = NULL, type = 0, active = 1, sync = 0)
      #    input = list(...)
      #    data = list.merge(data, input)
      #    data$id = makeID(0)
      #    # valida los datos
      #    # Inserta en la tabla
      #    # Procesa los tags
      #    # invalida datos de resumen
      #    
      # }
      # ,get = function(all=FALSE) {
      #    df = tbl$table()
      #    if (!all) df = df[df$active == 1,]
      #    df
      # }
   )
   ,private = list(
       tblBudget     = NULL
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
     ,loadBudgetBase = function () {
              dfg = tblGroups$table()
         dfg = dfg[dfg$active == 1,]
         dfg = dfg[,c("id","name")]
         colnames(dfg) = c("idGroup", "Group")

         #dfg = loadGroups()
         dfg$idGroup = as.integer(dfg$idGroup)
         #dfg$idCategory = as.integer(dfg$idCategory)
         dfc = loadCategories()
         #dft = dfg[,c("idGroup", "Group")]
         df = dplyr::left_join(dfc, dfg, by = "idGroup")
         #df = rbind(dfg, dfm)  
         df[,as.character(seq(1,12))] = 0
         df
     }
      ,loadGroups = function() {
         df = tblGroups$table()
         df = df[df$active == 1,]
         df = df[,c("id","name")]
         colnames(df) = c("idGroup", "Group")
         df = as_tibble(df)
         df = add_column(df, idCategory = 0,      .after = "idGroup")
         df = add_column(df, Category  = "Group", .after = "Group")
         df
      }
      ,loadCategories = function() {
         df = tblCategories$table()
         df = df[df$active == 1,]
         df = df[,c("idGroup", "id","name")]
         colnames(df) = c("idGroup", "idCategory", "Category")
         df$idGroup = as.integer(df$idGroup)
         df$idCategory = as.integer(df$idCategory)
         as_tibble(df)
      }
      ,loadBudget = function() {
         df = tblBudget$table(year = 2022)
         for (f in c("id", "group", "category", "method")) df[,f] = as.integer(df[,f])
         as_tibble(df)
      }
     ,mountBudget = function (df, dfb) {
        for (row in 1:nrow(df)) {
           if (df[row, "idCategory"] == 0) next
           data = dfb[dfb$category == df[row, "idCategory"],]
           if(nrow(data) == 0) next
           # Los meses empiezan en la columna 5
           start = data[1,"month"]
           repeat {
              df[row, start + 4] = data[1, "amount"]
              inc = ifelse (data[1, "frequency"] == 0, 12, data[1, "frequency"])
              start = start + inc
              if (start > 12) break
           }
        }
        df
     }
   )
)

