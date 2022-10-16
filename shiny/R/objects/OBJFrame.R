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
      ,set = function (data, dateValue = TRUE) {
         private$dfData = dfBase
         add(data, dateValue)
         invisible(self)
      }
      ,add = function (data, dateValue = TRUE) {
         if (nrow(data) == 0) return (invisible(self))
         data$month = lubridate::month(data$dateVal)
         if (!dateValue) data$month = lubridate::month(data$dateOper)
         df = data %>% group_by (idGroup, idCategory, month) %>% summarise(amount = sum(amount), .groups = "keep")
         df = as.data.frame(df %>% tidyr::spread(month, amount, fill=0))
         
         # dfData: Meses empiezan en la columna 5 (4 + mes) - df empiezan en la columna 3
         for (row in 1:nrow(df)) {
#            dfRow = dfData %>% filter(idGroup == df[row, "idGroup"] & idCategory == df[row,"idCategory"])
            dfRow = dfData[dfData$idGroup == df[row, "idGroup"],]
            dfRow = dfRow[dfRow$idCategory == df[row, "idCategory"],]
            tgt = nrow(dfRow)
            if (tgt != 1) stop("Datos erroneos en dfBase para agrupar datos")
            tgt = as.integer(dfRow[1,"row"])
            meses = colnames(df)
            for (mes in 3:length(meses)) {
               col = 4 + as.integer(meses[mes])
               private$dfData[tgt, col] = dfData[tgt, col] + df[row, mes]
            }
         }
      }
      ,getTotal     = function () { colSums(dfData[,5:16], na.rm = TRUE) }
      ,getReactable = function (idTable) {
          cols = lapply(1:12, function(x) colDef(name=monthLong[x], aggregate = "sum"))
          names(cols) = as.character(seq(1,12))
          cols[["idGroup"]]    = colDef(show = FALSE)
          cols[["idCategory"]] = colDef(show = FALSE)
          cols[["Group"]]      = colDef(name = "Grupo",     width = 150)
          cols[["Category"]]   = colDef(name = "Categoria", width = 200)
          if ("row" %in% colnames(dfData)) cols[["row"]] = colDef(show = FALSE)
         
          reactable(private$dfData, groupBy = "Group", columns = cols) # , onClick = jscode(idTable) )
      }
   )
   ,private = list(
      dfBase        = NULL
     ,dfData        = NULL
     ,tblGroups     = NULL
     ,tblCategories = NULL
     ,monthLong  = c( "Enero", "Febrero", "Marzo",      "Abril",   "Mayo",      "Junio"
                   ,"Julio", "Agosto",  "Septiembre", "Octubre", "Noviembre", "Diciembre")   
     ,monthShort = c( "Ene.", "Feb.", "Mar.",      "Abr.",   "May.",      "Jun."
                   ,"Jul.", "Ago.",  "Sep.", "Oct.", "Nov.", "Dic.")   
     ,mountFrame = function(expense = TRUE) {
        expenses = list(expense = 1)
        incomes  = list(income = 1)
        
        if (expense) filter = expenses
        else         filter = incomes
        filter$active = 1     
        
        dfg = tblGroups$table(filter)   
        dfc = tblCategories$table(filter)

        dfg = dfg[,c("id","name")]
        colnames(dfg) = c("idGroup", "Group")


        dfc = dfc[,c("idGroup", "id","name")]
        colnames(dfc) = c("idGroup", "idCategory", "Category")
        
        dfc = as_tibble(dfc)
        df = dplyr::left_join(dfc, dfg, by = "idGroup")
        df[,as.character(seq(1,12))] = 0
        df = df %>% mutate(row = row_number())
        private$dfBase = df
        private$dfData = df
    }   
      
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

