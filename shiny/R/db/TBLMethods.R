TBLMethods   = R6::R6Class("TBL.METHODS"
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
           tblName = "METHODS"
          ,key = c("id")
          ,fields = list(
               id      = "ID"       
              ,account = "IDACCOUNT"             
              ,name    = "NAME"     
              ,expense = "EXPENSE"
              ,income  = "INCOME"
              ,descr   = "DESCR"    
              ,close   = "CLOSE"    
              ,charge  = "CHARGE"  
              ,active  = "ACTIVE"   
              ,sync    = "SYNC"
         )
     )
)

