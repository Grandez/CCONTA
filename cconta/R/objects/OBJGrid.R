# Genera el marco general para gastos/presupuestos/etc
# Es decir, grupos/categorias/meses/total
# Se usa para ingresos/gastos/para cualquier cosa
OBJGrid = R6::R6Class("CONTA.OBJ.GRID"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       initialize = function(factory, ...) {
         super$initialize(factory, TRUE)
         private$objGroups     = factory$getObject("Groups")
         args = JGGTools::args2list(...)
         if (!is.null(args$all)) private$all = args$all
         setArrayCategories()         
         refresh()
       }
      ,setType = function (type) { 
         private$type = type
         invisible(self)
      }
      ,setPeriod = function (period) { 
         private$period = period
         invisible(self)
      }
      ,setCategories = function (categories) {
         # la lista de categorias de movimientos, asi que la resetea
         private$categories   = array(rep(FALSE, CTES$MAX_CATEGORIES))
         lapply(as.integer(categories), function (idx) private$categories[idx] = TRUE)
       }
      ,getType   = function () { private$type   }
      ,getPeriod = function () { private$period }
      
      ,showAll = function (all) {
         private$all = all
      }
      ,refresh = function () {
         loadBase()
         invisible(self)
      }
      ,getDataBase = function() {
         # Datos de pivote
         private$dfBase
      }
      ,setData = function (data) {
         #espera grupo, categoria, mes, activo (esto por los movimientos)
         private$dfData = data
         invisible(self)
      }
      ,getGroups = function () { dfBaseAll }
      ,getGrid = function (data, expenses = TRUE) {
         if (missing(data)) data = dfData
         
         # if (nrow(data) == 0) {
         #    tmp = data.frame(active=integer(0))
         #    data = cbind(data,tmp)
         # }

         df = rbind(mountGrid(expenses), data)
         
         df = df %>% dplyr::group_by(idGroup, idCategory, period) %>% 
                     dplyr::summarise(amount = sum(amount), .groups="keep")
         
         # Ahora le hacemos spread y calculamos total
         df = tidyr::spread(df, period, amount, fill=0)

         dfb = getGroupsAndCategories(expenses)

         res = dplyr::left_join(dfb, df,by=c("idGroup", "idCategory"))

         res
      }
   )
   ,private = list(
       dfBaseAll     = NULL
      ,dfBaseIncome  = NULL
      ,dfBaseExpense = NULL
      ,dfData        = NULL
      ,objGroups     = NULL
      ,dfZeroes      = NULL
      ,all           = FALSE     # Mostrar inactivos?
      ,type          = 0         # Tipo de datos (gastos, ingresos, etc.)
      ,period        = 0         # Period 0 = Agno y columnas en meses, si no mes y dias
      ,categories = array(rep(FALSE, CTES$MAX_CATEGORIES))
      ,setArrayCategories = function() {
         private$categories[CTES$CAT_FIXED] = TRUE
         private$categories[CTES$CAT_VARIABLE] = TRUE
         private$categories[CTES$CAT_APERIODIC] = TRUE
       }
      ,loadBase      = function () {
         dfg = objGroups$getGroups()
         dfc = objGroups$getCategories()
         
         private$dfBaseAll     = makeDFBase(dfg,dfc)
         private$dfBaseIncome  = makeDFBase(dfg[dfg$income  != 0, ],dfc[dfc$income  != 0,])
         private$dfBaseExpense = makeDFBase(dfg[dfg$expense != 0, ],dfc[dfc$expense != 0,])
      }
      ,makeDFBase = function (dfg, dfc) {
         dfg = dfg[,c("id", "name")]
         colnames(dfg) = c("idGroup", "group")
         
         dfc = dfc[,c("idGroup", "id", "name", "category")]
         colnames(dfc) = c("idGroup", "idCategory", "category", "class")

         inner_join(dfc, dfg)
      }
      ,getDFBase = function (expenses) {
         if (expenses) return (dfBaseExpense)
         dfBaseIncome
      }
      ,mountGrid = function (expenses) {
         dfb = getDFBase(expenses)

         # Creamos un df clave/mes o dia/0 (donde clave va de 1 a 12)
         if (period == 0) {
             dft = data.frame(period=seq(1,12), amount=0)   
         } else {
            dft = data.frame(period=seq(1,31), amount=0)  
         }

         # Ahora hacemos un full join por amount (que es la clave)
         # Y tenemos group/category/mes/0
         dfKeys = dfb[,c("idGroup", "idCategory")]
        
         if (nrow(dfKeys) == 0) {
             private$dfZeroes = cbind(dfb, data.frame(amount=numeric(), period=integer()))
         } else {
             dfKeys$amount = 0
             private$dfZeroes = full_join(dfKeys,dft, by="amount", relationship="many-to-many")
         }
         dfZeroes  
      }
     ,getGroupsAndCategories = function (expenses) {
         dfb = getDFBase(expenses) 
         dfb = dfb[,c("idGroup", "idCategory", "group", "category", "class")]

         # Ahora se filtra por las categorias fijo/variable/aperiodico
         dfc = NULL
         for (cat in which(categories)) {
              dfTmp = dfb %>% filter(class == cat)
              if (is.null(dfc)) {
                  dfc = dfTmp
              } else {
                  dfc = rbind(dfc, dfTmp)
              }
         }
         dfc$class = NULL # Quitar la columna
         dfc
     }   
      
   )
)
