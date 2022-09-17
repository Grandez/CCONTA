# Genera el marco general para gastos/presupuestos/etc
# Es decir, grupos/categorias/meses
# Se usa para ingresos/gastos/para cualquier cosa
OBJFrameExpenses = R6::R6Class("CONTA.OBJ.FRAME.EXPENSES"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJFrame
   ,public = list(
      initialize = function(factory) {
         super$initialize(factory, TRUE)
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         mountFrame()
      }
      ,reload = function() {
         mountFrame()
         invisible(self)
      }
      # ,set = function (data) {
      #    private$dfData = dfBase
      #    add(data)
      #    invisible(self)
      # }
      # ,add = function (data) {
      #    if (nrow(data) == 0) return (invisible(self))
      #    df = data %>% group_by (group, category, month) %>% summarise(amount = sum(amount))
      #    df = as.data.frame(df %>% spread(month, amount))
      #    
      #    # dfData: Meses empiezan en la columna 5 (4 + mes) - df empiezan en la columna 3
      #    for (row in 1:nrow(df)) {
      #       tgt = which(dfData[,"idGroup"] == df[row, "group"] && dfData[,"idCategory"] == df[row,"category"])
      #       meses = colnames(df)
      #       for (mes in 3:length(meses)) {
      #          private$dfData[tgt, 4 + as.integer(meses[mes])] = dfData[tgt, 4 + as.integer(meses[mes])] + df[row, mes]
      #       }
      #    }
      # }
   )
   ,private = list(
      type          = 0
     ,tblGroups     = NULL
     ,tblCategories = NULL
     ,dfBase        = NULL
     ,dfData        = NULL
     ,mountFrame = function() {
         dfg = tblGroups$table(type = 1, active = 1)
         dfg = dfg[,c("id","name")]
         colnames(dfg) = c("idGroup", "Group")
         dfg$idGroup = as.integer(dfg$idGroup)
         
         dfc = tblCategories$table()
         dfc = dfc[dfc$active == 1,]
         dfc = dfc[,c("idGroup", "id","name")]
         colnames(dfc) = c("idGroup", "idCategory", "Category")
         dfc$idGroup    = as.integer(dfc$idGroup)
         dfc$idCategory = as.integer(dfc$idCategory)
         dfc = as_tibble(dfc)
         df = dplyr::left_join(dfc, dfg, by = "idGroup")
         df[,as.character(seq(1,12))] = 0
         private$dfBase = df
         private$dfData = df
    }   
      
   )
)

