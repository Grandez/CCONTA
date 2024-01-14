mod_status_server = function(id, session) {
ns = NS(id)
PNLStatus = R6::R6Class("CONTA.PNL.STATUS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLStatusBase 
  ,public = list(
      initialize  = function (id, parent, session) {
         super$initialize(id, session, TRUE)
         self$data$source = 0
         private$objMovements = factory$getObject("Movements")
         private$objGroups    = factory$getObject("Groups")
         private$objPlot      = factory$getObject("Plot")
      }
     ,setSource = function (src) {
        self$data$source = as.integer(src) # Movimientos o situacion presupuestaria
     }
     ,setAccum    = function (accum) { objPage$setAccumulated(accum) }
     ,refreshData = function(reload) {
        df = getMovements(reload)
        if (self$data$source == 1) { # Contra presupuesto
            if (is.null(private$objBudget)) private$objBudget = factory$getObject("Budget")
            dfBudget = objBudget$getBudgetByPeriod(self$data$period, reload)
            df$amount = df$amount * -1
            df = rbind(dfBudget, df)
            df = df %>% group_by(idGroup, idCategory, period, expense) %>% 
                        summarise(amount=sum(amount), .groups = "drop")
        }
        objPage$setData(df, self$data$period)
     }
     ,getPlotObject = function ()     { objPlot }
     ,getGroupId    = function (name) {
        df = objGroups$getGroupByName(name) 
        df$id
      }
   )
  ,private = list(
      objMovements = NULL
     ,objGroups    = NULL
     ,objBudget    = NULL 
     ,objPlot      = NULL
     ,getMovements = function (reload) {
        df = objMovements$getMovementsByPeriod(self$data$period, reload)
        df = df[df$type %in% which(self$vars$types == TRUE),]
        if (self$data$period == 0) {
            df$period = lubridate::month(df$dateVal)   
        } else {
            df$period = lubridate::day(df$dateVal)   
        }
        # if (data$variable != 3) { # Solo fijos o variables
        #    fixed = ifelse(data$variable == 1, 0, -1)
        #    df = df[df$variable == fixed,]
        # }
        df[,c("idGroup", "idCategory", "period", "expense", "amount")]
     }
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLStatus, NULL, session)

   renderPlot = function(type, tableData) {
      plot = pnl$getPlotObject()
      if (type == 0) return (renderPlotly(plot$groupedBar(pnl$getSummaryData())))
      renderPlotly(plot$stackedBar(parseDataTable(type, tableData)))
   }
   parseDataTable = function (type, tableData) {
      data = jsonlite::fromJSON(tableData$detail)
      # Se ha pulsado en una agrupacion
      if (is.null(data$idGroup)) {
         data$idGroup    = pnl$getGroupId(data$group)
         data$idCategory = 0
         df = pnl$getGroupedData(type, data$idGroup)
      }   
      df[,3:ncol(df)]
   }
   refresh = function (reload = TRUE) {
      pnl$loaded = TRUE
      pnl$refreshData(reload)

      data = pnl$getExpensesTable(ns("tblExpenses"))
      output$tblExpenses = updTable({ pnl$getExpensesTable(ns("tblExpenses")) })
      output$tblIncomes  = updTable({ pnl$getIncomesTable(ns("tblIncomes")) })
      output$tblSummary  = updTable({ pnl$getSummaryTable() })
      output$plot = renderPlot(0, NULL)
   }
   observeEvent(input$cboPeriod, { 
      pnl$data$period = as.integer(input$cboPeriod) 
      refresh()
   }, ignoreInit = TRUE)
   observeEvent(input$chkCategories, {
      pnl$setCategories(input$chkCategories)
      refresh(FALSE)
   }, ignoreInit = TRUE)
   observeEvent(input$chkType, {
      # 1 - Real ,2 - previsto
      tmp = sum(as.integer(input$chkType))
      browser()
      # Pendiente
#      pnl$data$variable = sum(as.integer(input$chkCategory))
#      refresh()
   }, ignoreInit = TRUE)
   observeEvent(input$radBudget, {
      pnl$setSource(input$radBudget)
      refresh()
   }, ignoreInit = TRUE)
   observeEvent(input$swAccum, {
      pnl$setAccum(input$swAccum)
      refresh()
   }, ignoreInit = TRUE)

   observeEvent(input$tblSummary,  { output$plot = renderPlot(0, input$tblSummary)  })
   observeEvent(input$tblIncomes,  { output$plot = renderPlot(1, input$tblIncomes)  })
   observeEvent(input$tblExpenses, { output$plot = renderPlot(2, input$tblExpenses) })
   
   if (!pnl$loaded) refresh()

})
}
