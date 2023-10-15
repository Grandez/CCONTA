OBJExcel = R6::R6Class("JGG.OBJ.EXCEL"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,active = list(
      file = function (value) {
         if (missing(value)) return (xlsFile)
         private$xlsFileName = value
      }
      ,period = function (value) {
         if (missing(value)) return (.year)
         private$.year = value
      }
      ,month = function (value) {
         if (missing(value)) return (.month)
         private$.month = value
      }
   )
   ,public = list(
      initialize = function(factory) {
         private$objGroups = factory$getObject("Groups")
         private$objMov    = factory$getObject("Movements")
         #private$tbl = factory$getTable("Methods")
      }
      ,setFile = function (value) {
         private$xlsFileName = value
         invisible(self)
      }
      ,getFile= function() {
         return (xlsFileName)
      }
      ,generate = function(year, month) {
         if (!missing(year))  private$.year  = year
         if (is.null(.year))  private$.year  = lubridate::month(Sys.Date())
         if (!missing(month)) private$.month = month
         if (is.null(.month)) private$.month = lubridate::month(Sys.Date())
            
         makeGrids()
         loadOrCreateWB()
         loadData()
         setSheets()
         saveWorkbook(wb, xlsFileName, overwrite = TRUE, returnValue = TRUE)
      }
   )
   ,private = list(
       xlsFileNamePattern  = "C:/TEMP/conta"
      ,xlsFileName = NULL
      ,.year       = NULL
      ,.month      = NULL
      ,wb          = NULL
      ,objGroups   = NULL
      ,objMov      = NULL
      ,dfExpenses  = NULL
      ,dfIncomes   = NULL
      ,dfMovExpenses  = NULL
      ,dfMovIncomes   = NULL
      
      # Posiciones relativas de los bloques en funcion de los datos y el orden
      #Las filas se obtienen en tiempo de ejecucion
      ,rowPos      = list( header   = list(order=1, offset=0, rows=0)
                          ,total    = list(order=2, offset=2, rows=0)
                          ,incomes  = list(order=3, offset=2, rows=0)
                          ,expenses = list(order=4, offset=2, rows=0)
                         )
      ,setSheets  = function () {
         setSheetGeneral()
         setSheetReal()
         setSheetPrevisto()
      }
      ,setSheetGeneral = function() {
         data = list(incomes=dfIncomes, expenses=dfExpenses)
         setSheet("General", data)
      }
      ,setSheetReal = function() {
         data = list(incomes=dfIncomes, expenses=dfExpenses)
         setSheet("Real", data)
      }
      ,setSheetPrevisto = function() {
         data = list(incomes=dfIncomes, expenses=dfExpenses)
         setSheet("Previsto", data)
      }
      
      ,setSheet = function(name, data) {
         # Tenemos el problema de las agrupaciones
         # No podemos borrar los datos
         # Si no existe la hoja la creamos y si existe la actualizamos

         if (!name %in% wb$sheet_names) createSheet(name, list(incomes=dfIncomes, expenses=dfExpenses))
         updateSheet (name, data)
         # Si existe la hoja y la region, borrar los datos
         # namedRange = paste(name,"data", sep="_")
         # 
         #    named = openxlsx::getNamedRegions(wb)
         #    pos = match(namedRange, named)
         #    if (!is.na(pos)) { # Existe el nombre
         #       rng = range2index(attr(named, "position")[pos])
         #       deleteData(wb, name, rng[2]:rng[4], rng[1]:rng[3], gridExpand = TRUE)
         #       openxlsx::deleteNamedRegion(wb, namedRange)
         #    }
         # } else {
         #    openxlsx::addWorksheet(wb, name)   
         # }
         # 
         # writeData(wb, name, data, startCol = 1, startRow = 3, colNames = TRUE, name=namedRange)
         # # Obtenemos la posicion de la fila de totales y las filas por grupo
         # blocks = data %>% group_by(idGroup) %>% summarise(items=n())
         # blocks$begin = which(data$idCategory == 0)
         # blocks$begin = blocks$begin + 3 + 1 #Se agrupa arriba

         # apply(blocks, 1, function(row) groupRows(wb, name, row[3]:(row[3]+row[2])))
         #res = groupRows(wb, name, as.integer(blocks[3,3]):as.integer(blocks[3,2] + blocks[3,3]))
         
         ## which(mydata_2$height_chad1 == 2585)
         # createNamedRegion(wb, name, cols=1:ncol(data)
         #                           , rows=3:(nrow(data) + 3)
         #                           , name = paste(name,"data", sep="_")
         #                          ,overwrite = TRUE   )
         # browser()
      }
      ,createSheet = function (name, data) {
         openxlsx::addWorksheet(wb, name)       
         writeData(wb, name, data[["expenses"]], startCol = 1, startRow = 3, colNames = TRUE)         
         # Si existe la hoja y la region, borrar los datos
         # namedRange = paste(name,"data", sep="_")
         # 
         #    named = openxlsx::getNamedRegions(wb)
         #    pos = match(namedRange, named)
         #    if (!is.na(pos)) { # Existe el nombre
         #       rng = range2index(attr(named, "position")[pos])
         #       deleteData(wb, name, rng[2]:rng[4], rng[1]:rng[3], gridExpand = TRUE)
         #       openxlsx::deleteNamedRegion(wb, namedRange)
         #    }
         # } else {
         #    openxlsx::addWorksheet(wb, name)   
         # }
         # 
         # writeData(wb, name, data, startCol = 1, startRow = 3, colNames = TRUE, name=namedRange)
         # # Obtenemos la posicion de la fila de totales y las filas por grupo
         # blocks = data %>% group_by(idGroup) %>% summarise(items=n())
         # blocks$begin = which(data$idCategory == 0)
         # blocks$begin = blocks$begin + 3 + 1 #Se agrupa arriba
         
      }      
      ,updateSheet = function (name, data) {
         xls = read.xlsx(wb, name)
         browser()
      }
      ,makeGrids = function () {
         # Creamos el marco de grupos/categorias/meses vacio
         dfg = objGroups$getGroupsByPeriod(.year, .month)
         dfc = objGroups$getCategoriesByPeriod(.year, .month)
         
         private$dfExpenses = mountGrid(month, dfg[dfg$expense == 1,], dfc[dfc$expense == 1,])
         private$dfIncomes  = mountGrid(month, dfg[dfg$income  == 1,], dfc[dfc$income  == 1,])
         
      }
      ,mountGrid = function (month, dfg, dfc) {
         # Genera el grid/dataframe vacio con cuentas y meses
         cols = c("idGroup", "idCategory", "type", "Group", "Category")
         df1 = dfg[, c("id", "name")]
         colnames(df1) = c("idGroup", "Group")
         df2 = dfc[, c("idGroup", "id", "category", "name")]
         colnames(df2) = c("idGroup", "idCategory", "type", "Category")
         df = merge(df1, df2, by="idGroup")
         df = df[,cols]
         
         dft = makeTotalRows (df1)
         df = rbind(df, dft)
         
         if (month == 0) {
             periods = 1:12
         } else {
            periods = 1:31
         }
         for (m in periods) df [,m+5] = 0
         df$Total = 0

         if (month == 0) {
             colnames(df) = c(cols, months_short(), "Total")   
         } else {
            colnames(df) = c(cols, periods, "Total")   
         }
         dplyr::arrange(df, idGroup, idCategory)
      }
      ,loadOrCreateWB = function () {
         fileName = paste0(xlsFileNamePattern, "_2023")
         if (.month == 0) fileName = paste0(fileName, "00.xlsx")
         if (.month >  0) fileName = paste0(fileName, sprintf("%02d", .month), ".xlsx")
         if (file.exists(fileName)) {
            private$wb = openxlsx::loadWorkbook(fileName)
         } else {
            private$wb = openxlsx::createWorkbook(title="Contabilidad")
         }
         private$xlsFileName = fileName 
      }
      ,loadData = function () {
         browser()
         dfMovExpenses = objMov$getExpenses()
         dfMovIncomes  = objMov$getIncomes()
         private$dfMovExpenses = dfMovExpenses %>% dplyr::filter(lubridate::year(dateVal) == .year)
         if (.month > 0) {
            private$dfMovExpenses = dfMovExpenses %>% dplyr::filter(lubridate::month(dateVal) == .month)
         }
         private$dfMovIncomes = dfMovIncomes %>% dplyr::filter(lubridate::year(dateVal) == .year)
         if (.month > 0) {
            private$dfMovIncomes = dfMovIncomes %>% dplyr::filter(lubridate::month(dateVal) == .month)
         }
      }
      ,makeTotalRows = function (data) {
         df = data
         df$idCategory = 0
         df = df[,c("idGroup", "idCategory", "Group")]
         df$type = 0
         df$Category = "Total"
         df
      }
      ,range2index = function (range) {
         input = strsplit(range,":")[[1]]
         if (length(input) == 1) input[2] = input[1]
         cols = convertFromExcelRef(input)
         rows = gsub("[a-z]+", "", input, ignore.case = TRUE)
         c(rows[1], cols[1], rows[2], cols[2])
      }
      
#   openxlsx::addWorksheet(wb, name         
#   sheetName,
#   gridLines = openxlsx_getOp("gridLines", TRUE),
#   tabColour = NULL,
#   zoom = 100,
#   header = openxlsx_getOp("header"),
#   footer = openxlsx_getOp("footer"),
#   evenHeader = openxlsx_getOp("evenHeader"),
#   evenFooter = openxlsx_getOp("evenFooter"),
#   firstHeader = openxlsx_getOp("firstHeader"),
#   firstFooter = openxlsx_getOp("firstFooter"),
#   visible = TRUE,
#   paperSize = openxlsx_getOp("paperSize", 9),
#   orientation = openxlsx_getOp("orientation", "portrait"),
#   vdpi = openxlsx_getOp("vdpi", 300),
#   hdpi = openxlsx_getOp("hdpi", 300)
# )
                  
      
   )
)
