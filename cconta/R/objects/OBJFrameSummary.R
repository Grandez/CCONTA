# Genera el marco general para gastos/presupuestos/etc
# Es decir, grupos/categorias/meses
# Se usa para ingresos/gastos/para cualquier cosa
OBJFrameSummary = R6::R6Class("CONTA.OBJ.FRAME.SUMMARY"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJFrame
   ,public = list(
      initialize = function(factory) {
         super$initialize(factory, TRUE)
         mountFrame()
      }
      ,setIncomes = function (data) {
         addRow(1,data)
         addRow(3,data)
         invisible(self)
      }
      ,setExpenses = function (data) {
         addRow(2,data)
         subtractRow(3,data)
         invisible(self)
      }
      ,getReactable = function (idTable) {
          cols = lapply(1:12, function(x) colDef(name=monthLong[x]))
          names(cols) = as.character(seq(1,12))

          cols[["idGroup"]]    = colDef(show  = FALSE)
          cols[["idCategory"]] = colDef(show  = FALSE)
          cols[["Concepto"]]   = colDef(width = 350)

          reactable(private$dfData, columns = cols) # , onClick = jscode(idTable) )
      }
     # ,getData = function (wide = TRUE) {
     #    if (wide) return (private$dfData)
     #    browser()
     #    dfi =  gather(df[df$Concepto == "Ingresos",], "Mes", "Concepto")
     #    dfg =  gather(df[df$Concepto == "Gastos",],   "Mes", "Concepto")
     #    colnames(dfi) = c("Mes", "Ingresos")
     #    colnames(dfg) = c("Mes", "Gastos")
     #    full_join(dfi, dfg, by="Mes")
     # }
   )
   ,private = list(
      mountFrame = function() {
         private$dfBase = data.frame(idGroup=c(1,2,0), idCategory=c(1,2,0),Concepto=c("Ingresos", "Gastos","Saldo"))
         for (col in 1:12) private$dfBase[,as.character(col)] = 0
         private$dfData = dfBase
      }   
      ,addRow = function (row, data) {
         for (i in 1:12) {
              res = private$dfData[row, i + 3]
              private$dfData[row, i + 3] = res + data[i]
         }
      }
      ,subtractRow = function (row, data) {
         for (i in 1:12) {
              res = private$dfData[row, i + 3]
              private$dfData[row, i + 3] = res - data[i]
         }
      }
      
   )
)

