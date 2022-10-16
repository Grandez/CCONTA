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
       initialize    = function(factory, type = 0, child = FALSE) {
         super$initialize(factory, TRUE)
         private$tblMethods    = factory$getTable("Methods")
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         private$tblMovements  = factory$getTable("Movements")
         private$tblParents    = factory$getTable("Itemizeds")
         private$tblTags       = factory$getTable("Tags")
         private$dfGroups      = tblGroups$table(active = 1)
      }
      ,getGroups     = function (type = c("all", "expenses", "incomes")) { 
          mtype = "all"
          if (!missing(type)) mtype = match.arg(type)
          df = dfGroups
          if (mtype == "expenses") df = df[df$expense == 1,]
          if (mtype == "income")   df = df[df$income  == 1,]
          df
      }
      ,getCategories = function (expense = TRUE, group = 0) { 
         active  = list(name = "active",  value = 1)
         idGroup = list(name = "idGroup", value = group) 
         if (group == 0) idGroup = NULL
         field = list(name = "income", value = 1)
         if (expense) field$name = "expense"
         tblCategories$recordset(field, active, idGroup) 
       }
      ,getMethods    = function (expenses = TRUE)          { 
         if ( expenses) df = tblMethods$table(expense = 1, active = 1) 
         if (!expenses) df = tblMethods$table(income  = 1, active = 1)
         df
        }
      ,getExpenses   = function ()          { getMovements (expense = 1) }
      ,getIncomes    = function ()          { getMovements (expense = 0) }
      ,getMovements  = function (expense)  {
         private$dfMov = tblMovements$table(expense=expense, active = 1)
         dfMov
      }
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
      ,set = function (...) {
         browser()
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
         browser()
         tryCatch({
            tblMovements$db$begin()
            tblMovements$add(private$mov)
            addTags(mov, mov$tags)
            tblMovements$db$commit()
            private$mov$id
         }, error = function (cond) {
            browser()
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
      ,tblGroups     = NULL
      ,tblCategories = NULL
      ,tblMovements  = NULL
      ,tblParents    = NULL      
      ,tblTags       = NULL
      ,mov           = list(type = 1)
      ,addTags = function(mov, mtags) {
         tags = strsplit(mtags, "[,;]")
         tags = tags[[1]]
         grp = dfGroups[dfGroups$id == mov$idGroup, "name"]
         dfc = tblCategories$table(idGroup = mov$idGroup, id = mov$idCategory)
         cat = dfc[1, "name"]
         tags = c(grp, cat, tags)
         tags = unique(tags)
         for (idx in 1:length(tags)) {
            tblTags$add(list(id = mov$id, seq = idx, tag = tags[idx]))
         }
      }
      ,getMethodName = function (record) {
         if (is.null(dfMethods)) private$dfMethods = tblMethods$table()
         method = dfMethods[dfMethods$id == record[1,"idMethod"]]
         if (nrow(method) == 0) return (as.character(record[1,"idMethod"]))
         as.character(method[1,"name"])
      }
   )
)

