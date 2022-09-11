TBLExpenses   = R6::R6Class("TBL.EXPENSES"
    ,inherit    = YATATable
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name, db=NULL) {
             super$initialize(name, private$tblName, fields=private$fields,db=db)
          }
     )
     ,private = list (
           tblName = "EXPENSES"
          ,key = c("id")
          ,fields = list(
              id       = "ID"
             ,account  = "ACCOUNT"
             ,method   = "METHOD"
             ,amount   = "AMOUNT"
             ,note     = "NOTE"
             ,type     = "TYPE"
             ,active   = "ACTIVE"
             ,sync     = "SYNC"
            )
     )
)
