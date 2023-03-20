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
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         args = JGGTools::args2list(...)
         if (!is.null(args$all)) private$all = args$all
         
         refresh()
       }
      ,setType = function (type) { 
         private$type = type
         invisible(self)
      }
      ,getType = function (type) { 
         private$type
      }
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
      ,getGrid = function (data, type = NULL) {
         oldType = NULL
         if (!is.null(type)) {
            oldType = getType()
            setType(type)
         }
         if (missing(data)) data = dfData
         
         if (nrow(data) == 0) {
            tmp = data.frame(active=integer(0))
            data = cbind(data,tmp)
         }
         if(! "active" %in% colnames(data))  data$active = 1
         
         # los juntamos y los sumamos. 
         # Ahora tenemos por cada grupo/categoria 12 registros
         dfZeroes = mountGrid()
         df1 = dfZeroes
         df2 = data
         if (!all) {
             df1 = df1[df1$active == 1,]
             df2 = df2[df2$active == 1,]
         }
         df = rbind(df1, df2)
         df = df %>% dplyr::group_by(idGroup, idCategory, month) %>% 
                     dplyr::summarise(amount = sum(amount), .groups="keep")
        
         # Ahora le hacemos spread y calculamos total
         df = tidyr::spread(df, month, amount)

         dfb = getDFBase() 
         dfb = dfb[,c("idGroup", "idCategory", "group", "category")]
         res = dplyr::inner_join(dfb, df,by=c("idGroup", "idCategory"))
         if (!is.null(oldType)) setType(oldType)
         res
      }
   )
   ,private = list(
       dfBaseAll     = NULL
      ,dfBaseIncome  = NULL
      ,dfBaseExpense = NULL
      ,dfData        = NULL
      ,tblGroups     = NULL
      ,tblCategories = NULL
      ,dfZeroes      = NULL
      ,all           = FALSE     # Mostrar inactivos?
      ,type          = 0         # Tipo de datos (gastos, ingresos, etc.)
      ,loadBase      = function () {
         dfg = tblGroups$table()
         dfc = tblCategories$table()
         
         private$dfBaseAll     = makeDFBase(dfg,dfc)
         private$dfBaseIncome  = makeDFBase(dfg[dfg$income  == 1, ],dfc[dfc$income  == 1,])
         private$dfBaseExpense = makeDFBase(dfg[dfg$expense == 1, ],dfc[dfc$expense == 1,])
      }
      ,makeDFBase = function (dfg, dfc) {
         dfg = dfg[,c("id", "name", "active")]
         colnames(dfg) = c("idGroup", "group", "grpActive")
         
         dfc = dfc[,c("idGroup", "id", "name", "active")]
         colnames(dfc) = c("idGroup", "idCategory", "category", "catActive")

         df = inner_join(dfc, dfg)
         # Marcamos activo/inactivo (si grupo, nada esta activo, si categoria solo eso: 0-1 o 1-0)

         # No se por que falla un min
         df = df %>% mutate(active = grpActive + catActive) %>% mutate(active = if_else(active == 2,1, 0))
#         df$active = min(df$grpActive, df$catActive)
         
         df$grpActive = NULL
         df$catActive = NULL
         df
      }
      ,getDFBase = function () {
         if (type == CTES$DATA$Expenses) return (dfBaseExpense)
         if (type == CTES$DATA$Incomes)  return (dfBaseIncome)
         dfBseAll
      }
      ,mountGrid = function () {
        dfb = getDFBase()

        # Creamos un df clave/mes/0 (donde clave va de 1 a 12)
        dft = data.frame(month=seq(1,12), amount=0)

        # Ahora hacemos un full join por amount (que es la clave)
        #Y tenemos group/category/mes/0
        dfKeys = dfb[,c("idGroup", "idCategory", "active")]
        
        if (nrow(dfKeys) == 0) {
           private$dfZeroes = cbind(dfb, data.frame(amount=numeric(), month=integer()))
        } else {
           dfKeys$amount = 0
           private$dfZeroes = full_join(dfKeys,dft, by="amount", multiple="all")
        }
      }
   )
)
