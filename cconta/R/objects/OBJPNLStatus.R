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
PNLStatus     = R6::R6Class("CONTA.PNL.STATUS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase 
  ,public = list(
      initialize  = function (id, session, child) {
         super$initialize(id, session, child)
         private$objPage      = factory$getObject("PageTables")
         self$data$period = 0 # Muestra meses o mes
         # Los tipos son numeros secuenciales (1,2,3)
         self$vars$types = rep(TRUE, max(unlist(CTES$MOVTYPE)))
         self$data$variable = 3 # 1 - fijo, 2 - variable, 3 - todos
      }
     ,setCategories = function(categories) {
        # la lista de categorias de movimientos, asi que la resetea
        objPage$setCategories(categories)
        invisible(self)
     }
     ,refreshData = function () {
        browser()
        data = objMovements$getMovements()
        data = data[data$type %in% which(self$vars$types == TRUE),]
        data$month = lubridate::month(data$dateVal)
        df = data[,c("idGroup", "idCategory", "month", "expense", "amount")]
        objPage$setData(df)
     }
     ,getExpenses      = function (target) { objPage$getExpenses(target) }
     ,getIncomes       = function (target) { objPage$getIncomes (target) }     
     ,getSummary       = function (target) { objPage$getSummary (target) } # Estaba a NULL 
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
