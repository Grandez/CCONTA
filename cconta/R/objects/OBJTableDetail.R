# Genera la tabla web de meses
OBJTableDetail = R6::R6Class("CONTA.OBJ.TABLE.DETAIL"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       grouping = NULL
      ,initialize = function(factory, ...) {
         super$initialize(factory, TRUE)
         args = JGGTools::args2list(...)
         if (!is.null(args$grouping)) self$grouping = args$grouping
      }
      ,setData = function (data) {
         private$dfData = data
         # Insertar la columna de totales en funcion de dias o meses
         colLast = ncol(dfData)
         colFirst = ifelse (colLast > 30, 30, 11)
         colFirst = colLast - colFirst
         private$dfData$Total = rowSums(dfData[,colFirst:colLast])
         invisible(self)
      }
      ,getTable = function (id = NULL, grouped=TRUE) {
          agno = ifelse (ncol(dfData) > 30, FALSE, TRUE)
          mgroup = self$grouping
          if (!grouped) mgroup = NULL
          cols = lapply(colnames(dfData), function(x) makeColDef(x, agno))
          
          #La ultima columna se suma si hay agrupacion
          if (!is.null(mgroup)) {
             cols[[length(cols)]]$aggregate = "sum"
             cols[[length(cols)]]$format = colFormat(digits = 2)
          }
          
          names(cols) = colnames(dfData)
          
          mtheme = reactable::reactableTheme(cellPadding = "0px 0px")

          reactable::reactable( dfData, width="100%", pagination = FALSE, onClick=jscode(id)
                               ,columns = cols
                               ,groupBy = mgroup
                               ,theme   = mtheme
                              )
      }
   )
   ,private = list(
        dfData        = NULL
       ,jscode = function(idTable) {
          if (is.null(idTable)) return (NULL)
          data = paste("{ rowIndex: rowInfo.index, rowId: rowInfo.id, colId: colInfo.id, colName: colInfo.name")
          data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
          evt = paste0("Shiny.setInputValue('", idTable, "',", data, ",{ priority: 'event' });")

          js_code = "function(rowInfo, colInfo) {"
          js_code = paste(js_code, evt, sep="\n")
          js_code = paste(js_code, "}", sep="\n")
          htmlwidgets::JS(js_code)
       }
      ,makeColDef = function (colname, agno) {
          if (startsWith(colname, "id")) return (reactable::colDef(show = FALSE))
          coldef = reactable::colDef(name = getColName(colname, agno))
          if (!is.na(suppressWarnings(as.integer(colname)))) {
             if (!is.null(grouping)) coldef$aggregate="sum"
             coldef$format = colFormat(digits=2)
          }
          coldef
       }
      ,getColName = function (colName, agno) {
         colNum = suppressWarnings(as.integer(colName))
         if (!is.na(colNum) && agno) return (month_short(colNum))
         if (colName == "group")     return ("Grupo")
         if (colName == "category")  return ("Categoria")
         colName
       }
   )
)


