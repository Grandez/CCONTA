OBJBase = R6::R6Class("JGG.OBJ.BASE"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       factory = NULL
      ,initialize = function(factory, child=FALSE) {
         if (!child) stop("OBJBase is an abstract class")
         self$factory = factory
      }
   )
)
