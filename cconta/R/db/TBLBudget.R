TBLBudget   = R6::R6Class("CONTA.TBL.BUDGET"
    ,inherit    = TBLBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
          initialize = function(name, db=NULL) {
             super$initialize(name, private$tblName, fields=private$fields,key=private$key, db=db)
          }
     )
     ,private = list (
           tblName = "BUDGET"
          ,key = c("group", "category", "year", "month")
          ,fields = list(
              idGroup     = "IDGROUP"
             ,idCategory  = "IDCATEGORY"
             ,year      = "NYEAR"
             ,month     = "NMONTH"             
             ,amount    = "AMOUNT"
             ,expense   = "EXPENSE"
             ,descr     = "DESCR"
             ,active    = "ACTIVE"             
             ,sync      = "SYNC"
            )
     )
)
