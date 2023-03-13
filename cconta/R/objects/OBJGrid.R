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
      ,showAll = function (all) {
         private$all = all
      }
      ,refresh = function () {
         loadBase()
         mountGrid()
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
      ,getGrid = function (data) {
         if (missing(data)) data = dfData
         
         if (nrow(data) == 0) {
            tmp = data.frame(active=integer(0))
            data = cbind(data,tmp)
         }
         if(! "active" %in% colnames(data))  data$active = 1
         
         # los juntamos y los sumamos. 
         # Ahora tenemos por cada grupo/categoria 12 registros
        
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

         dfb = dfBase[,c("idGroup", "idCategory", "group", "category")]
         res = dplyr::inner_join(dfb, df,by=c("idGroup", "idCategory"))
         res
      }
   )
   ,private = list(
       dfBase        = NULL
      ,dfData        = NULL
      ,tblGroups     = NULL
      ,tblCategories = NULL
      ,dfZeroes      = NULL
      ,all           = FALSE     # Mostrar inactivos?
      ,loadBase      = function () {
         dfg = tblGroups$table()
         dfg = dfg[,c("id", "name", "active")]
         colnames(dfg) = c("idGroup", "group", "grpActive")

         dfc = tblCategories$table()
         dfc = dfc[,c("idGroup", "id", "name", "income", "expense", "active")]
         colnames(dfc) = c("idGroup", "idCategory", "category", "income", "expense", "catActive")

         df = inner_join(dfc, dfg)
         # Marcamos activo/inactivo (si grupo, nada esta activo, si categoria solo eso: 0-1 o 1-0)

         # No se por que falla un min
         df = df %>% mutate(active = grpActive + catActive) %>% mutate(active = if_else(active == 2,1, 0))
#         df$active = min(df$grpActive, df$catActive)
         
         df$grpActive = NULL
         df$catActive = NULL
         private$dfBase = df
      }
      ,mountGrid = function () {
        # Creamos un df clave/mes/0 (donde clave va de 1 a 12)
        dft = data.frame(month=seq(1,12), amount=0)

        # Ahora hacemos un full join por amount (que es la clave)
        #Y tenemos group/category/mes/0
        df2 = dfBase[,c("idGroup", "idCategory", "active")]
        df2$amount = 0
        private$dfZeroes = full_join(df2,dft, by="amount", multiple="all")
      }
   )
)
