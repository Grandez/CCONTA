WEBROOT = R6::R6Class("JGG.INFO.APP"
  ,portable   = TRUE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = JGGWEB
  ,public = list(
      print      = function() { message("WEB Singleton") }     
     ,factory    = NULL
     ,tools      = NULL
     ,year       = lubridate::year(Sys.Date())
     ,initialize = function(mode="prod") {
         super$initialize()
         # reg.finalizer(self,
         #          function(e) message("WEBROOT Finalizer has been called!"),
         #          onexit = TRUE)
         self$factory = OBJFactory$new(mode)
         self$tools   = OBJTools$new()
     }
     ,finalize   = function() {
        # message("WEBROOT finalize - Destruyendo objeto")
        self$factory$finalize()
        self$factory = NULL
     }
     ,getPanel   = function (id, object = NULL, parent=NULL, session=getDefaultReactiveDomain(), ...) {
        private$args = list(...)
        super$getPanel(id,object,parent,session)
     }
     ,makeCombo = function(df, sorted=TRUE, id="id", name="name") {
         data = as.list(df[,id])
         names(data) = df[,name]
        if (sorted) data = data[order(names(data))]
        data
    }
     
  )
 ,private = list(
    args = NULL
 )   
)
