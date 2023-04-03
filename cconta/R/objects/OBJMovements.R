# Un movimiento puede ser:
# 1 - Real, es decir, gasto inmediato
# 2 - Amortizacion: Es decir, un gasto amortizable, ha ocurrido y se va descontando
# 3 - Provision: Un gato ficticio que se va acumulando
# Un pago con tarjeta se ejecuta en la fecha de operacion y es real
# La fecha de valor es cuando se aplica, la fecha de pago de la tarjeta
# Con las tarjetas revolving habria que pasarlo como a deuda
# Ejemplo:
# Tengo un gasto de 2000 y lo aplazo en 10 meses
#    Marcamos el gasto como "aplazado/adeudado"
#    Lo pasamos a deudas
# La provision de fondos se tiene que anular con un gasto real, y no tiene una fecha de cargo
# Necesitamos el mes al que aplicar
OBJMovements   = R6::R6Class("CONTA.OBJ.MOVEMENTS"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       initialize    = function(factory, ...) {
         super$initialize(factory, TRUE)
         args = JGGTools::args2list(...)
         if (!is.null(args$year)) private$year = args$year

         private$tblMethods    = factory$getTable("Methods")
         # private$tblGroups     = factory$getTable("Groups")
         # private$tblCategories = factory$getTable("Categories")
         private$tblMovements  = factory$getTable("Movements")
         private$tblParents    = factory$getTable("Itemizeds")
         private$tblTags       = factory$getTable("Tags")
#         private$dfGroups      = tblGroups$table(active = 1)
         loadMovements()
       }
      ,loadMovements = function () {
         # Carga todos los movimientos del agno para evitar accesos a BBDD
         df = tblMovements$recordset(
                 dateVal = list(func="YEAR", value = year)
                ,active = list(value = 1)
         )
         private$dfMov = df[,!(names(df) %in% c("active", "sync"))]
      }
      ,getMovements = function () {
         private$dfMov
      }
      # ,getGroups     = function (type = c("all", "expenses", "incomes")) { 
      #     mtype = "all"
      #     if (!missing(type)) mtype = match.arg(type)
      #     df = dfGroups
      #     if (mtype == "expenses") df = df[df$expense == 1,]
      #     if (mtype == "income")   df = df[df$income  == 1,]
      #     df
      # }
      # ,getCategories = function (expense = TRUE, group = 0) { 
      #    active  = list(name = "active",  value = 1)
      #    idGroup = list(name = "idGroup", value = group) 
      #    if (group == 0) idGroup = NULL
      #    field = list(name = "income", value = 1)
      #    if (expense) field$name = "expense"
      #    tblCategories$recordset(field, active, idGroup) 
      #  }
      ,getMethods    = function (expenses = TRUE)          { 
         if ( expenses) df = tblMethods$table(expense = 1, active = 1) 
         if (!expenses) df = tblMethods$table(income  = 1, active = 1)
         df
        }
      ,getExpenses   = function ()          { getMovements (expense = 1) }
      ,getIncomes    = function ()          { getMovements (expense = 0) }
#       ,getMovements  = function (expense)  {
#          browser()
#          df = tblMovements$recordset(
#                  dateVal = list(func="YEAR", value = year)
#                 ,active = list(value = 1)
#                 ,expense = list(value = expense))
# #               (expense=expense, active = 1)
#          private$dfMov = df %>% filter(lubridate::year(dateVal) == year)
#          dfMov
#       }
      ,getMovementsFull  = function (...)  {
         df = getMovements(...)
         if (nrow(df) == 0) return (df)
         df$tags = NA
         df$group    = as.character(df$idGroup)
         df$category = as.character(df$idCategory)
         df$method   = as.character(df$idMethod)
         for (idx in 1:nrow(df)) {
            df[idx, "method"] = getMethodName(df[idx,]) 
            dfTags = tblTags$table(id = df[idx, "id"])
            vTags  = as.vector(dfTags[,"tag"])
            idx = 0
            tags = c()
            while (idx < length(vTags)) {
               if (idx == 0) df[idx, "group"]    = vTags[1]
               if (idx == 1) df[idx, "category"] = vTags[2]
               if (idx >  1) tags = c(tags, vTags[idx + 1])
               idx = idx + 1
            }
            if (length(tags)) df[idx, "tags"] = paste(vTags, collapse=",")
         }
         df
      }
      ,getPrevision  = function (year)  {
         if (missing(year)) year = self$year
         tblMovements$recordset( 
             dateVal = list(name="dateVal", func = "YEAR", op="eq", value=year)
            ,type    = list(value = MOV_TYPE$Expected)
         )
      }
      
      ,set = function (...) {
          private$mov = jgg_list_merge(mov, list(...))
          invisible(self)
      }
      ,add = function(...) {
         args = list(...)
         if (is.list(args[[1]])) {
            private$mov = args[[1]]
         } else {
            private$mov = jgg_list_merge(private$mov, args)
         }
         private$mov$id = factory$tools$getID()

         tryCatch({
            tblMovements$db$begin()
            tblMovements$add(private$mov)
            addTags(mov, mov$tags)
            tblMovements$db$commit()
            private$mov$id
         }, error = function (cond) {
            tblMovements$db$rollback()
            0
         })
      }
      ,itemize = function (base, items) {
          idx = 1
          if (length(items) == 0) return (add(base)) 
         
          tryCatch({
            tblMovements$db$begin()
            base$id = factory$tools$getID()
            tblParents$add(base)

            while (idx <= length(items)) {
               item = items[[idx]] 
               rec = list( id = factory$tools$getID()
                          ,parent     = base$id
                          ,dateOper   = base$dateOper
                          ,dateVal    = base$dateVal
                          ,idMethod   = base$idMethod
                          ,idGroup    = item$idGroup
                          ,idCategory = item$idCategory
                          ,amount     = item$amount
                          ,note       = item$note)
               tblMovements$add(rec)
               addTags(rec, item$tags)
               idx = idx + 1
            }
            tblMovements$db$commit()
            base$id
        }, error = function (cond) {
           tblMovements$db$rollback()     
           0
        })
         
      }
   )
   ,private = list(
       dfGroups      = NULL
      ,dfMov         = NULL
      ,dfMethods     = NULL
      ,tblMethods    = NULL
      # ,tblGroups     = NULL
      # ,tblCategories = NULL
      ,tblMovements  = NULL
      ,tblParents    = NULL      
      ,tblTags       = NULL
      ,year          = lubridate::year(Sys.Date())
      ,mov           = list(type = 1)
      ,addTags = function(mov, mtags) {
         tags = strsplit(mtags, "[,;]")
         tags = tags[[1]]
         # grp = dfGroups[dfGroups$id == mov$idGroup, "name"]
         # dfc = tblCategories$table(idGroup = mov$idGroup, id = mov$idCategory)
         # cat = dfc[1, "name"]
         # tags = c(grp, cat, tags)
         tags = unique(tags)
         if (length(tags) > 0) {
             for (idx in 1:length(tags)) {
                  tblTags$add(list(id = mov$id, seq = idx, tag = tags[idx]))
             }
         }
      }
      ,getMethodName = function (record) {
         if (is.null(dfMethods)) private$dfMethods = tblMethods$table()
         method = dfMethods[dfMethods$id == record[1,"idMethod"]]
         if (nrow(method) == 0) return (as.character(record[1,"idMethod"]))
         as.character(method[1,"name"])
      }
     ,loadBudget = function () {
        # Creamos un df clave/mes/0 (donde clave va de 1 a 12)
        dft = data.frame(month=seq(1,12), amount=0)

        # Ahora hacemos un full join por amount (que es la clave)
        #Y tenemos group/category/mes/0
        df2 = dfBase[,c("idGroup", "idCategory")]
        df2$amount = 0
        dfZeroes = full_join(df2,dft, by="amount", multiple="all")

        #Cogemos el presupuesto en funcion del agno
        dfb = tblBudget$table(year = self$year, active = 1)
        dfb = dfb[,c("idGroup", "idCategory", "month", "amount")]
        
        # los juntamos y los sumamos. 
        # Ahora tenemos por cada grupo/categoria 12 registros
        
        df = rbind(dfZeroes, dfb)
        df = df %>% dplyr::group_by(idGroup, idCategory, month) %>% 
                    dplyr::summarise(amount = sum(amount), .groups="keep")
        
        #Ahora le hacemos spread
        df = tidyr::spread(df, month, amount)
        private$dfBudget = dplyr::inner_join(dfBase, df,by=c("idGroup", "idCategory"))
     }
      
   )
)

