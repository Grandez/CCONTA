TBLTags   = R6::R6Class("CONTA.TBL.TAGS"
    ,inherit    = TBLBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name, db=NULL) {
             super$initialize(name, private$tblName, fields=private$fields, key=private$key, db=db)
          }
     )
     ,private = list (
           tblName = "TAGS"
          ,key = c("id", "tag")
          ,fields = list(
              id       = "ID"
             ,seq      = "SEQ"
             ,tag      = "TAG"
            )
     )
)
