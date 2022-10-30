TBLBudget   = R6::R6Class("CONTA.TBL.BUDGET"
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
           tblName = "BUDGET"
          ,key = c("id")
          ,fields = list(
              id        = "ID"
             ,group     = "IDGROUP"
             ,category  = "IDCATEGORY"
             ,method    = "IDMETHOD"             
             ,dateOper  = "DATEOPE"
             ,dateVal   = "DATEVAL"
             ,amount    = "AMOUNT"
             ,frecuency = "FRECUENCY"             
             ,descr     = "DESCR"
             ,active    = "ACTIVE"             
             ,sync      = "SYNC"
            )
     )
)
