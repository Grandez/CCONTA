PNLBase = R6::R6Class("CONTA.PNL.BASE"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
      id        = NULL
     ,factory   = NULL
     ,session   = NULL
     ,loaded    = FALSE
     ,exception = NULL
     ,initialize     = function(id, session, child = FALSE) {
         if (!child) stop("Class PNLBase is abstract!!!")
         self$id      = id
         self$session = session         
         self$factory = WEB$factory
      }
   )
)
