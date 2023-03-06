.jscode = function(idTable) {
      data = paste("{ row: rowInfo.index + 1, col: colInfo.index + 1, colName: colInfo.id")
      data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
      evt = paste0("Shiny.setInputValue('", idTable, "',", data, ",{ priority: 'event' });")

      js_code = "function(rowInfo, colInfo) {"
      js_code = paste(js_code, evt, sep="\n")
      js_code = paste(js_code, "}", sep="\n")
      htmlwidgets::JS(js_code)
}
.getColName = function (colName) {
   colNum = suppressWarnings(as.integer(colName))
   if (!is.na(colNum)) return (month_short(colNum))
   if (colName == "Group")    return ("Grupo")
   if (colName == "Category") return ("Categoria")
}
.makeColDef = function (colname) {
   if (startsWith(colname, "id")) return (reactable::colDef(show = FALSE))
   coldef = reactable::colDef(name = .getColName(colname))
   if (!is.na(suppressWarnings(as.integer(colname)))) coldef$aggregate="sum"
   coldef
}
makeTableBudget = function (data, id) {
   cols = lapply(colnames(data), function(x) .makeColDef(x))
   names(cols) = colnames(data)
   mtheme = reactable::reactableTheme(cellPadding = "0px 0px")

   reactable::reactable( data, width="100%", pagination = FALSE, onClick=.jscode(id)
                        ,columns = cols
                        ,groupBy = c("Group")
                        ,theme   = mtheme
                       )
}
