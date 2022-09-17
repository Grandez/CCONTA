PNLBase = R6::R6Class("CONTA.PNL.BASE"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,active = list(
     loaded = function(value) {
      if (missing(value)) {
         .loaded
      }
      else {
         private$.loaded = value
         invisible(self)
      }
     }
   )  
  ,public = list(
      id = NULL
     ,factory = NULL
     ,session = NULL
     ,initialize     = function(id, factory, session, child = FALSE) {
         if (!child) stop("Class PNLBase is abstract!!!")
         self$id      = id
         self$factory = factory
         self$session = session
      }
     ,loadBudget = function () { obj$getBudget() }
   )
  ,private = list(
     .loaded = FALSE
   )
)
