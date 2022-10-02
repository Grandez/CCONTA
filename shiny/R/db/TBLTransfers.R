TBLTransfers    = R6::R6Class("CONTA.TBL.TRANSFERS"
    ,inherit    = TBLBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name, db=NULL) {
             super$initialize(name, private$tblName, fields=private$fields,db=db)
          }
     )
     ,private = list (
           tblName = "TRANSFERS"
          ,key     = c("id")
          ,fields  = list(
              id       = "ID"
             ,dtOper   = "DATEOPER"
             ,dtVal    = "DATEVAL"
             ,origin   = "ORIGIN"
             ,target   = "TARGET"
             ,amount   = "AMOUNT"
             ,note     = "NOTE"
             ,active   = "ACTIVE"
             ,sync     = "SYNC"
            )
     )
)
