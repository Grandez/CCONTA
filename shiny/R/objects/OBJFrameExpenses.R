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
   )
   ,private = list(
      type          = 0
     ,tblGroups     = NULL
     ,tblCategories = NULL
     ,dfBase        = NULL
     ,dfData        = NULL
      
   )
)

