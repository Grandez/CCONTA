TBLItemizeds    = R6::R6Class("CONTA.TBL.MOVEMENTS"
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
           tblName = "ITEMIZEDS"
          ,key = c("id")
          ,fields = list(
              id         = "ID"
             ,dateOper   = "DATEOPER"
             ,dateVal    = "DATEVAL"
             ,idMethod   = "IDMETHOD"
             ,idGroup    = "IDGROUP"
             ,idCategory = "IDCATEGORY"
             ,amount     = "AMOUNT"
             ,note       = "NOTE"
             ,expense    = "EXPENSE"
             ,type       = "TYPE"
             ,parent     = "PARENT"
             ,active     = "ACTIVE"
             ,sync       = "SYNC"
            )
     )
)
