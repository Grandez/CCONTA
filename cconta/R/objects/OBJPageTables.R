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
      ,setAccumulated = function (accum) {
         private$accumulated = as.logical(accum)
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
      ,getExpensesData = function () { 
         objGrid$setPeriod(private$period)
         prepareData(dfExpenses, TRUE)
       }
      ,getIncomesData  = function () { 
         objGrid$setPeriod(private$period)
         prepareData(dfIncomes, FALSE)
       }
      ,getSummaryData  = function (target) { dfSummary[1:2,] }
      ,getGroupedData  = function (type, pgroup) {
         if (type == 1) df = getIncomesData()
         if (type == 2) df = getExpensesData()
         df %>% dplyr::filter (idGroup == pgroup)
      }
      ,getExpensesTable = function (target) { 
         df = getExpensesData()
         getTable(target, df) 
       }
      ,getIncomesTable  = function (target) { 
         df = getIncomesData()
         getTable(target, df)  
      }
      ,getSummaryTable = function (target) {
         Ingresos = totals(objGrid$getGrid(dfIncomes, FALSE))
         Gastos   = totals(objGrid$getGrid(dfExpenses, TRUE)) * -1

         df = rbind(Ingresos, Gastos)
         Balance = colSums(df)
         # Acum = Balance
         # for (idx in 2:length(Acum)) Acum[idx] = Acum[idx] + Acum[idx - 1]
         mat = rbind(df, Balance) # , Acum)
         df = as.data.frame(mat)
         df = cbind(group="Resumen", category=rownames(df), df)
         rownames(df) = NULL
         df[2,3:ncol(df)] = df[2,3:ncol(df)] * -1
         private$dfSummary = df
         objTable$setData(df)
         objTable$getTable(grouped=FALSE)
      }
   )
   ,private = list(
       dfIncomes   = NULL
      ,dfExpenses  = NULL
      ,dfSummary   = NULL
      ,objGrid     = NULL
      ,objTable    = NULL
      ,period      = 0   # El periodo es agno (meses) o mes (dias)
      ,accumulated = FALSE
      ,prepareData = function (data, expenses) {
         df = objGrid$getGrid(data, expenses) 
         if (accumulated) {
            for (col in 6:ncol(df)) df[,col] = df[,col - 1] + df[,col]
         }
         df         
      }
      ,getTable    = function (target, df) {
         objTable$setData(df)$getTable(target)
       }
      ,totals = function (df) {
         colSums(df[,5:ncol(df)]) # Cogemos solo los valores numericos
       }

   )
)


