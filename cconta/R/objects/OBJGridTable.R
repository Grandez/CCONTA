# Genera la tabla web de meses
OBJGridTable = R6::R6Class("CONTA.OBJ.GRID.TABLE"
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
         colLast = ncol(dfData)
         colFirst = colLast - 11
         private$dfData$Total = rowSums(dfData[,colFirst:colLast])
         invisible(self)
      }
      ,getTable = function (id = NULL) {
          cols = lapply(colnames(dfData), function(x) makeColDef(x))
          names(cols) = colnames(dfData)
          mtheme = reactable::reactableTheme(cellPadding = "0px 0px")

          reactable::reactable( dfData, width="100%", pagination = FALSE, onClick=jscode(id)
                               ,columns = cols
                               ,groupBy = grouping
                               ,theme   = mtheme
                              )
      }
   )
   ,private = list(
        dfData        = NULL
       ,jscode = function(idTable) {
          if (is.null(idTable)) return (NULL)
          data = paste("{ row: rowInfo.index + 1, col: colInfo.index + 1, colName: colInfo.id")
          data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
          evt = paste0("Shiny.setInputValue('", idTable, "',", data, ",{ priority: 'event' });")

          js_code = "function(rowInfo, colInfo) {"
          js_code = paste(js_code, evt, sep="\n")
          js_code = paste(js_code, "}", sep="\n")
          htmlwidgets::JS(js_code)
       }
      ,makeColDef = function (colname) {
          if (startsWith(colname, "id")) return (reactable::colDef(show = FALSE))
          coldef = reactable::colDef(name = getColName(colname))
          if (!is.na(suppressWarnings(as.integer(colname)))) {
             if (!is.null(grouping)) coldef$aggregate="sum"
          }
          coldef
       }
      ,getColName = function (colName) {
         colNum = suppressWarnings(as.integer(colName))
         if (!is.na(colNum)) return (month_short(colNum))
         if (colName == "group")    return ("Grupo")
         if (colName == "category") return ("Categoria")
       }
   )
)


