# Genera la tabla web de meses
OBJPageTables = R6::R6Class("CONTA.OBJ.PAGE.TABLES"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       initialize = function(factory, ...) {
         super$initialize(factory, TRUE)
         private$objGrid  = factory$getObject("Grid")
         private$objTable = factory$getObject("GridTable", grouping="group")
      }
      ,setData = function (data) {
         private$dfIncomes  = data[data$expense == 1,]
         private$dfExpenses = data[data$expense == -1,]
         private$dfIncomes$expense  = NULL
         private$dfExpenses$expense = NULL
         invisible(self)
      }
      ,getExpenses = function (target) { 
         objGrid$setType(CTES$DATA$Expenses)
         getTable(target, dfExpenses) 
       }
      ,getIncomes  = function (target) { 
         objGrid$setType(CTES$DATA$Incomes)
         getTable(target, dfIncomes)  
      }
      ,getSummary = function (target) {
         Ingresos = totals(objGrid$getGrid(dfIncomes,CTES$DATA$Incomes))
         Gastos   = totals(objGrid$getGrid(dfExpenses, CTES$DATA$Expenses)) * -1

         df = rbind(Ingresos, Gastos)
         Balance = colSums(df)
         Acum = Balance
         for (idx in 2:length(Acum)) Acum[idx] = Acum[idx] + Acum[idx - 1]
         mat = rbind(df, Balance, Acum)

         objTable$setData(as.data.frame(mat))
         objTable$getTable(grouped=FALSE)
      }
   )
   ,private = list(
       dfIncomes  = NULL
      ,dfExpenses = NULL
      ,objGrid  = NULL
      ,objTable = NULL
      ,getTable = function (target, data) {
         df = objGrid$getGrid(data) 
         objTable$setData(df)$getTable(target)
       }
      ,totals = function (df) {
         colSums(df[,5:16]) # Cogemos solo los valores numericos
       }

   )
)


