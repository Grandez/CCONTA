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
          private$objGroups  = factory$getObject("Groups")
          private$objMethods = factory$getObject("Methods")

         if (!is.null(args$grouping)) self$grouping = args$grouping
      }
      ,getTable = function (data, id = NULL, grouped=TRUE) {
         dfData = prepareData(data)
        
          # agno = ifelse (ncol(dfData) > 30, FALSE, TRUE)
          # mgroup = self$grouping
          # if (!grouped) mgroup = NULL
          cols = lapply(colnames(dfData), function(x) makeColDef(x))

          # #La ultima columna se suma si hay agrupacion
          # if (!is.null(mgroup)) {
          #    cols[[length(cols)]]$aggregate = "sum"
          #    cols[[length(cols)]]$format = colFormat(digits = 2)
          # }
          # 
          names(cols) = colnames(dfData)

          mtheme = reactable::reactableTheme(cellPadding = "0px 0px")

          reactable::reactable( dfData, width="100%", pagination = FALSE, onClick=jscode(id)
                               ,columns = cols
#                               ,groupBy = mgroup
                               ,theme   = mtheme
                              )
#         dfData
      }
   )
   ,private = list(
        dfData        = NULL
       ,objGroups  = NULL
       ,objMethods = NULL
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
      ,makeColDef = function (colname) {
          if (startsWith(colname, "id"))  return (reactable::colDef(show = FALSE))
          if (colname %in% c("dateOper", "parent", "expense")) return (reactable::colDef(show = FALSE))
          coldef = reactable::colDef(name = getColName(colname, agno))
          coldef$sortable = TRUE
          # if (!is.na(suppressWarnings(as.integer(colname)))) {
          #    if (!is.null(grouping)) coldef$aggregate="sum"
          #    coldef$format = colFormat(digits=2)
          # }
          coldef
       }
      ,getColName = function (colName, agno) {
         # colNum = suppressWarnings(as.integer(colName))
         # if (!is.na(colNum) && agno) return (month_short(colNum))
         if (colName == "group")    return ("Grupo")
         if (colName == "cat")      return ("Categoria")
         if (colName == "method")   return ("Metodo")
         if (colName == "dateVal")  return ("Fecha")         
         colName
      }
      ,prepareData = function (df) {
         dfr = objGroups$getAllGroups()
         dfr = dfr[,c("id", "name")]
         colnames(dfr) = c("idGroup", "group")
         df = left_join(df,dfr)

         dfr = objGroups$getCategories()
         dfr = dfr[,c("id", "name")]
         colnames(dfr) = c("idCategory", "cat")
         df = left_join(df,dfr,by="idCategory")
         
         dfr = objMethods$getMethods(all=TRUE)
         dfr = dfr[,c("id", "name")]
         colnames(dfr) = c("idMethod", "method")
         df = left_join(df,dfr, by="idMethod")
         df %>% dplyr::relocate(dateVal,  .after=id) %>%
                dplyr::relocate(group,    .after=dateVal) %>%            
                dplyr::relocate(cat,      .after=group) %>%
                dplyr::relocate(method,   .after=cat)
         
      }
   )
)


