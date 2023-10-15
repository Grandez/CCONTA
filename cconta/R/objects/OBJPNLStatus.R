############################################################
# Panel Base para todas las paginas que muestran:
#  - Un grafico
#  - El resumen
#  - Ingresos
#  - Gastos
#  Los paneles hijo le dan el objeto que tiene la fuente de datos
#  Estos objetos implementaran la misma interfaz
#  Es decir, heredaran de una clase comun
#
############################################################
PNLStatusBase = R6::R6Class("CONTA.PNL.STATUS.BASE"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase 
  ,public = list(
      initialize  = function (id, session, child) {
         super$initialize(id, session, child)
         private$objPage      = factory$getObject("PageTables")
      }
     ,refreshData = function () {
        data = objMovements$getMovements()
        data = data[data$type %in% which(self$vars$types == TRUE),]
        data$month = lubridate::month(data$dateVal)
        df = data[,c("idGroup", "idCategory", "month", "expense", "amount")]
        browser()
        objPage$setData(df)
     }
     ,getExpenses      = function (target) { objPage$getExpenses(target) }
     ,getIncomes       = function (target) { objPage$getIncomes (target) }     
     ,getSummary       = function (target) { objPage$getSummary (NULL)   } 
     # ,getTableSummary  = function (target) { gridSummary$getReactable (target) }
     # ,getTableIncomes  = function (target) { gridIncomes$getReactable (target) }
     # ,getTableExpenses = function (target) { gridExpenses$getReactable(target) }
     # ,getDataSummary   = function ()       { gridSummary$getData ()            }     
   )
  ,private = list(
      gridSummary  = NULL
     ,gridIncomes  = NULL
     ,gridExpenses = NULL
     ,objMovements = NULL
     ,objPage      = NULL
     ,objSource    = NULL
   )
)
