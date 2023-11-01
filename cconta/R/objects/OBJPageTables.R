# Genera la tabla de meses o dias
# Con sus filtros y sus cosas
# Es usada por el objeto de paginas PNLStatus
#
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
      ,setPeriod = function (period) {
         private$period = period
         invisible(self)
      }
      ,setCategories = function(categories) { objGrid$setCategories(categories) }
      ,setData = function (data, period) {
         private$dfIncomes  = data[data$expense == 0,]
         private$dfExpenses = data[data$expense != 0,]
         private$dfIncomes$expense  = NULL
         private$dfExpenses$expense = NULL
         if (!missing(period)) self$setPeriod(period)
         invisible(self)
      }
      ,getExpenses = function (target) { 
         objGrid$setType(CTES$TYPE$Expenses)
         objGrid$setPeriod(private$period)
         getTable(target, dfExpenses) 
       }
      ,getIncomes  = function (target) { 
         objGrid$setType(CTES$TYPE$Incomes)
         objGrid$setPeriod(private$period)
         getTable(target, dfIncomes)  
      }
      ,getSummary = function (target) {
         Ingresos = totals(objGrid$getGrid(dfIncomes,  CTES$TYPE$Incomes))
         Gastos   = totals(objGrid$getGrid(dfExpenses, CTES$TYPE$Expenses)) * -1

         df = rbind(Ingresos, Gastos)
         Balance = colSums(df)
         Acum = Balance
         for (idx in 2:length(Acum)) Acum[idx] = Acum[idx] + Acum[idx - 1]
         mat = rbind(df, Balance, Acum)
         df = as.data.frame(mat)
         df = cbind(group="Resumen", category=rownames(df), df)
         rownames(df) = NULL
         objTable$setData(df)
         objTable$getTable() #(grouped=FALSE)
      }
   )
   ,private = list(
       dfIncomes  = NULL
      ,dfExpenses = NULL
      ,objGrid    = NULL
      ,objTable   = NULL
      ,period     = 0   # El periodo es agno (meses) o mes (dias)
      ,getTable   = function (target, data) {
         df = objGrid$getGrid(data) 
         objTable$setData(df)$getTable(target)
       }
      ,totals = function (df) {
         colSums(df[,5:ncol(df)]) # Cogemos solo los valores numericos
       }

   )
)


