# Factoria para Obtener diferentes objetos
# Los dejamos en lazy para no crear referencias circulares con los
# singletons YATABase.

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
          message("Clearing factory")
         if (!is.null(DBFactory)) DBFactory$finalize()
          gc(verbose=FALSE)

      }
      ######################################################################
      ### FACTORY GETTERS
      ######################################################################
      ,getTable    = function(name, force = FALSE) { DBFactory$get(name, force) }
      ,getObject   = function(name, force = FALSE, ...) {
         instance = paste0("OBJ", name, "$new(self, ...)")
         # Pasamos la propia factoria como referencia
         if (force) return ( eval(parse(text=instance)))
         if (is.null(objects$get(name))) private$objects$put(name, eval(parse(text=instance)))
         objects$get(name)
      }
      ,getClass   = function(name, force = FALSE) {
         # Obtiene una clase general
         if (force) return ( eval(parse(text=paste0("R6", name, "$new()"))))
         if (is.null(classes$get(name))) private$classes$put(name,
                                         eval(parse(text=paste0("R6", name, "$new()"))))
         classes$get(name)
      }
      ######################################################################
      ### Database associated to an object
      ######################################################################

      ,getDBID   = function() { DBFactory$getID()     }
      ,getDB     = function() { DBFactory$getDB()     }
      ,getDBBase = function() { DBFactory$getDBBase() }
      ,getDBName = function() {
          db = getDB()
          if (!is.null(db)) db$name
          else              NULL
      }

   )
   ,private = list(
       DBFactory   = NULL
      ,objects     = NULL
      ,classes     = NULL
      ,cfg         = NULL
      ,base        = NULL
      ,.valid      = TRUE
      ,setDB     = function(connData)            {
         connInfo = jgg_list_merge(cfg$sgdb, connData)
         DBFactory$setDB(connInfo)
         invisible(self)
       }
   )
)

