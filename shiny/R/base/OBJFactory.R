# Factoria para Obtener diferentes objetos
# Los dejamos en lazy para no crear referencias circulares con los

OBJFactory = R6::R6Class("JGG.CCONTA.FACTORY"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,public = list(
       codes     = NULL
      ,parms     = NULL
      ,msg       = NULL
      ,tools     = NULL
      ,print = function()     { message("Factoria de objetos YATA") }
      ,initialize = function(mode="prod") {
          private$DBFactory = BBDDFactory$new(mode)
          private$objects   = HashMap$new()
          self$tools        = OBJTools$new()
          reg.finalizer(self,
                  function(e) message("OBJFactory Finalizer has been called!"),
                  onexit = TRUE)
          
       }
      ,finalize       = function() { 
          message("OBJFactory FINALIZE Clearing factory")
          if (!is.null(DBFactory)) DBFactory$finalize()
          private$objects   = HashMap$new() # Objects to garbage collector
          gc(verbose=FALSE)
      }
      ######################################################################
      ### FACTORY GETTERS
      ######################################################################
      ,getTable    = function(name, force = FALSE) { DBFactory$getTable(name, force) }
      ,getObject   = function(name, force = FALSE, ...) {
         instance = paste0("OBJ", name, "$new(self, ...)")
         if (force) return ( eval(parse(text=instance)))
         if (is.null(objects$get(name))) private$objects$put(name, eval(parse(text=instance)))
         objects$get(name)
      }
      ######################################################################
      ### Database associated to an object
      ######################################################################

      ,getDB     = function() { DBFactory$getDB()     }
   )
   ,private = list(
       DBFactory   = NULL
      ,objects     = NULL
   )
)

