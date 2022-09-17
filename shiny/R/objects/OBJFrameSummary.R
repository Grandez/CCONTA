# Genera el marco general para gastos/presupuestos/etc
# Es decir, grupos/categorias/meses
# Se usa para ingresos/gastos/para cualquier cosa
OBJFrameSummary = R6::R6Class("CONTA.OBJ.FRAME.SUMMARY"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJFrame
   ,public = list(
      initialize = function(factory) {
         super$initialize(factory, TRUE)
         mountFrame()
      }
      ,setIncomes = function (data) {
         invisible(self)
      }
      ,setExpenses = function (data) {
         invisible(self)
      }
      ,getReactable = function (idTable) {
          reactable(private$dfData) # , onClick = jscode(idTable) )
      }
   )
   ,private = list(
      mountFrame = function() {
         private$dfBase = data.frame(idGroup=c(1,2,0), idCategory=c(1,2,0),Concepto=c("Ingresos", "Gastos","Saldo"))
         for (col in 1:12) private$dfBase[,as.character(col)] = 0
         private$dfData = dfBase
    }   
      
   )
)

