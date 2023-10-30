TBLMovements    = R6::R6Class("CONTA.TBL.MOVEMENTS"
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
           tblName = "MOVEMENTS"
          ,key = c("id")
          ,fields = list(
              id         = "ID"
             ,idGroup    = "IDGROUP"
             ,idCategory = "IDCATEGORY"
             ,idMethod   = "IDMETHOD"             
             ,dateOper   = "DATEOPE"
             ,dateVal    = "DATEVAL"
             ,amount     = "AMOUNT"
             ,note       = "NOTE"
             ,type       = "TYPE"             
             ,category   = "CATEGORY"
             ,active     = "ACTIVE"
             ,expense    = "EXPENSE"
             ,parent     = "PARENT"
             ,sync       = "SYNC"
            )
     )
)
