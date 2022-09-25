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
             ,date       = "CDATE"
             ,idMethod   = "IDMETHOD"
             ,idGroup    = "IDGROUP"
             ,idCategory = "IDCATEGORY"
             ,amount     = "AMOUNT"
             ,note       = "NOTE"
             ,type       = "TYPE"
             ,mode       = "MODE"
             ,active     = "ACTIVE"
             ,sync       = "SYNC"
             ,year       = "DATEY"
             ,month      = "DATEM"
             ,day        = "DATED"
            )
     )
)
