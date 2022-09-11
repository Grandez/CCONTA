OBJMethods = R6::R6Class("JGG.OBJ.METHODS"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
      initialize = function(factory) {
         private$tbl = factory$getTable("Methods")
      }
      ,getMethods = function(all=FALSE) {
         df = tbl$table()
         if (!all) df = df[df$active == 1,]
         df
      }
   )
   ,private = list(
      tbl = NULL
   )
)
