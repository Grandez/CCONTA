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
          ,key = c("year", "month", "group", "category")
          ,fields = list(
              year        = "BYEAR"
             ,month       = "BMONTH"             
             ,idGroup     = "IDGROUP"
             ,idCategory  = "IDCATEGORY"
             ,expense     = "EXPENSE"
             ,'00'        = "B00"
             ,'01'        = "B01"             
             ,'02'        = "B02"
             ,'03'        = "B03"             
             ,'04'        = "B04"
             ,'05'        = "B05"             
             ,'06'        = "B06"
             ,'07'        = "B07"             
             ,'08'        = "B08"
             ,'09'        = "B09"             
             ,'10'        = "B10"
             ,'11'        = "B11"             
             ,'12'        = "B12"
             ,'13'        = "B13"             
             ,'14'        = "B14"
             ,'15'        = "B15"             
             ,'16'        = "B16"
             ,'17'        = "B17"             
             ,'18'        = "B18"
             ,'19'        = "B19"             
             ,'20'        = "B20"
             ,'21'        = "B21"             
             ,'22'        = "B22"
             ,'23'        = "B23"             
             ,'24'        = "B24"
             ,'25'        = "B25"             
             ,'26'        = "B26"
             ,'27'        = "B27"             
             ,'28'        = "B28"
             ,'29'        = "B29"             
             ,'30'        = "B30"             
             ,'31'        = "B31"                          
             ,sync      = "SYNC"
            )
     )
)
