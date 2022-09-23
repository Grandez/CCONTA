# Genera el marco general para gastos/presupuestos/etc
# Es decir, grupos/categorias/meses
# Se usa para ingresos/gastos/para cualquier cosa
OBJFrame = R6::R6Class("CONTA.OBJ.FRAME"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
      initialize = function(factory, child=FALSE) {
         if (!child) stop("OBJFrame is an abstract class")
         super$initialize(factory, TRUE)
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
      }
      ,reload = function() {
         mountFrame()
         invisible(self)
      }
      ,set = function (data) {
         private$dfData = dfBase
         add(data)
         invisible(self)
      }
      ,add = function (data) {
         if (nrow(data) == 0) return (invisible(self))
         df = data %>% group_by (group, category, month) %>% summarise(amount = sum(amount))
         df = as.data.frame(df %>% tidyr::spread(month, amount, fill=0))
         
         # dfData: Meses empiezan en la columna 5 (4 + mes) - df empiezan en la columna 3
         for (row in 1:nrow(df)) {
            tgt = which(dfData[,"idGroup"] == df[row, "group"] && dfData[,"idCategory"] == df[row,"category"])
            meses = colnames(df)
            for (mes in 3:length(meses)) {
               private$dfData[tgt, 4 + as.integer(meses[mes])] = dfData[tgt, 4 + as.integer(meses[mes])] + df[row, mes]
            }
         }
      }
      ,getTotal     = function () { colSums(dfData[,5:16], na.rm = TRUE) }
      ,getReactable = function (idTable) {
          cols = lapply(1:12, function(x) colDef(aggregate = "sum"))
          names(cols) = as.character(seq(1,12))
          cols[["idGroup"]]    = colDef(show = FALSE)
          cols[["idCategory"]] = colDef(show = FALSE)
          # cols[["Group"]]      = colDef(sticky  = "left")
          # cols[["Category"]]   = colDef(sticky  = "left")
          reactable(private$dfData, groupBy = "Group", columns = cols) # , onClick = jscode(idTable) )
      }
   )
   ,private = list(
      dfBase        = NULL
     ,dfData        = NULL
     ,tblGroups     = NULL
     ,tblCategories = NULL
      
    ,jscode = function(idTable) {
       data = paste("{ row: rowInfo.index + 1, colName: colInfo.id")
       data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
       evt = paste0("Shiny.setInputValue('", idTable, "',", data, ",{ priority: 'event' });")

         if (is.null(self$id)) return (NULL)
         js_code = "function(rowInfo, colInfo) {"
         # Exclude columns
#         js_code = paste(js_code, " if (colInfo.id !== 'details') { return;  }", sep="\n")
#         js_code = paste(js_code, "window.alert('Details for row ' + rowInfo.index + ':\\n' + JSON.stringify(rowInfo.row, null, 2));", sep="\n")
         js_code = paste(js_code, evt, sep="\n")
         js_code = paste(js_code, "}", sep="\n")
         JS(js_code)
    }
      
   )
)

