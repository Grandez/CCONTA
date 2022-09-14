TBLExpenses   = R6::R6Class("CONTA.TBL.EXPENSES"
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
           tblName = "EXPENSES"
          ,key = c("id")
          ,fields = list(
              id       = "ID"
             ,date     = "CDATE"
             ,method   = "IDMETHOD"
             ,group    = "IDGROUP"
             ,category = "IDCATEGORY"
             ,amount   = "AMOUNT"
             ,note     = "NOTE"
             ,type     = "TYPE"
             ,active   = "ACTIVE"
             ,sync     = "SYNC"
             ,year     = "DATEY"
             ,month    = "DATEM"
             ,day      = "DATED"
            )
     )
)
