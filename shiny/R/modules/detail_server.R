mod_detail_server <- function(id, session) {
ns = NS(id)
PNLDetail = R6::R6Class("CONTA.PNL.DETAIL"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase 
  ,public = list(
      data = NULL
     ,initialize     = function (id, session) {
          super$initialize(id, session, TRUE)
          private$objMov = factory$getObject("Movements")
     }
     ,setFilter     = function (...)       {
        # filter1: estos campos fuerzan a relanzar la query
        # filter2: el filtro se hace sobre los datos
        mainFilter = c("type", "group", "category")
        args = list(...)
        for (name in names(args)) {
           if (name %in% mainFilter) {
              private$filter1[[name]] = args[[name]]
              private$reload = TRUE
           } else {
              private$filter2[[name]] = args[[name]]
           }
        }
        private$reload = TRUE
        invisible(self)
     }
     ,getFilter     = function (filterName) {
        if (!is.null(filter1[[filterName]])) return (filter1[[filterName]])
        if (!is.null(filter2[[filterName]])) return (filter2[[filterName]])
        NULL
     }
     ,getGroups     = function (type = 1)   { objMov$getGroups     (type)   }
     ,getCategories = function (group = 0)  { objMov$getCategories (group)  }
     ,getMethods    = function ()           { objMov$getMethods    ()       }
     ,getData       = function () {
        if (reload) reloadData()
        df = dfBase
        if (nrow(df) == 0) return (df)
        filters = names(filter2)
        idx = 0
        while (idx < length(filter2)) {
           if (filters[idx + 1] == "date") {
              df = df[df$date >= filter2[[idx + 1]][1] & df$date <= filter2[[idx + 1]][2],]
              if (nrow(df) == 0) return(df)
           }
           idx = idx + 1
        }
        self$data = df
        df
     }
     ,refreshData = function() {
#        if (reload) reloadData()
        # objMovements
        # frmExpenses$set(objMovements$getExpenses())
        # frmIncomes$set (objMovements$getIncomes ())
        # totExpenses = frmExpenses$getTotal()
        # totIncomes  = frmIncomes$getTotal()
        # frmSummary$setIncomes(totIncomes)
        # frmSummary$setExpenses(totExpenses)
     }
     # ,getSummary  = function (target) { frmSummary$getReactable (target) }
     # ,getIncomes  = function (target) { frmIncomes$getReactable (target) }
     # ,getExpenses = function (target) { frmExpenses$getReactable(target) }
   )
  ,private = list(
     #  frmSummary   = NULL
     # ,frmIncomes   = NULL
     # ,frmExpenses  = NULL
      objMov = NULL
     ,filter1 = list()
     ,filter2 = list()
     ,reload  = TRUE
     ,dfBase  = NULL
     ,reloadData = function () {
        private$dfBase = objMov$getMovementsFull(filter1)
        private$reload = FALSE
     }
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLDetail, session)
   
   flags = reactiveValues(
         refresh    = FALSE
   ) 
   
   loadGroups = function () {
      df = pnl$getGroups(pnl$getFilter("type"))
      cbo = WEB$makeCombo(df)
      updateSelectInput( session, "cboGroups"
                        ,choices = jgg_list_merge(list("Todos" = "0"), cbo)
                        ,selected = "0")
   }
   loadCategories = function () {
      df = pnl$getCategories(pnl$getFilter("group"))
      cbo = WEB$makeCombo(df)
      updateSelectInput( session, "cboCategories"
                        ,choices = jgg_list_merge(list("Todos" = "0"), cbo)
                        ,selected = "0")
   }
   prepareData = function (df) {
      colsHide = c("id")
      cols = lapply(colsHide, function(col) colDef(show = FALSE))
      names(cols) = colsHide
      #cols$tags = colDef(width="auto")
      df = df[,c("id", "date","group","category","method","amount","note","tags")]
      reactable::reactable(df, columns=cols, width="100%", pagination = FALSE, onClick = jscode(ns("tblDetail")) )
   }
    jscode = function(idTable) {
       data = paste("{ row: rowInfo.index + 1, colName: colInfo.id")
       data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
       evt = paste0("Shiny.setInputValue('", idTable, "',", data, ",{ priority: 'event' });")

         js_code = "function(rowInfo, colInfo) {"
         # Exclude columns
#         js_code = paste(js_code, " if (colInfo.id !== 'details') { return;  }", sep="\n")
#         js_code = paste(js_code, "window.alert('Details for row ' + rowInfo.index + ':\\n' + JSON.stringify(rowInfo.row, null, 2));", sep="\n")
         js_code = paste(js_code, evt, sep="\n")
         js_code = paste(js_code, "}", sep="\n")
         JS(js_code)
    }
   
   observeEvent(flags$refresh, ignoreInit = TRUE, {
      df = pnl$getData()
      output$tblDetail  = renderReactable({ prepareData(df) })
   })
   observeEvent(input$radType,   { 
      pnl$setFilter(type = as.integer(input$radType))
      loadGroups() 
   })
   observeEvent(input$cboGroups, {
      pnl$setFilter(group = as.integer(input$cboGroups))
      loadCategories() 
   })
   observeEvent(input$cboCategories, {
      pnl$setFilter(category = as.integer(input$cboCategories))
      flags$refresh  = isolate(!flags$refresh)
   })
   observeEvent(input$dtRange, {
      pnl$setFilter(date=input$dtRange)
      flags$refresh  = isolate(!flags$refresh)
   })
   observeEvent(input$tblDetail, {
      shinyjs::show("form_modal")
      output$form_modal = renderUI({movementUI(paste0(id, "_form"), insert = FALSE) })
#       showModal(modalDialog(movementUI(id, insert = FALSE),
#   title = NULL,
#   footer = modalButton("Dismiss"),
#   size = "xl",
#   easyClose = TRUE,
#   fade = TRUE
# ))
   })
   
})
}
