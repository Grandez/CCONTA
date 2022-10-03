# Genera el marco general para gastos/presupuestos/etc
# Es decir, grupos/categorias/meses
# Se usa para ingresos/gastos/para cualquier cosa
OBJFrameIncomes = R6::R6Class("CONTA.OBJ.FRAME.INCOMES"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJFrame
   ,public = list(
      initialize = function(factory) {
         super$initialize(factory, TRUE)
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         mountFrame(expense = FALSE)
      }
      ,reload = function() {
         mountFrame(expense = FALSE)
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

