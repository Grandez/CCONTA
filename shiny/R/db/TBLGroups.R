TBLGroups   = R6::R6Class("CONTA.TBL.GROUPS"
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
           tblName = "GROUPS"
          ,key = c("id")
          ,fields = list(
               id     = "ID"       
              ,name   = "NAME"     
              ,descr  = "DESCR"    
              ,active = "ACTIVE"   
              ,sync   = "SYNC"
         )
     )
)

