TBLCategories   = R6::R6Class("TBL.CATEGORIES"
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
           tblName = "CATEGORIES"
          ,key = c("id")
          ,fields = list(
               id      = "ID"  
              ,idGroup = "IDGROUP"
              ,name    = "NAME"     
              ,descr   = "DESCR"   
              ,income  = "INCOME"
              ,expense = "EXPENSE"
              ,active  = "ACTIVE"   
              ,sync    = "SYNC"
         )
     )
)

