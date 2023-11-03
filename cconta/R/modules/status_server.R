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
   )
  ,private = list(
      objMovements = NULL
     ,objBudget    = NULL 
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

   makePlot = function() {
      df = pnl$getDataSummary()
      df = df[df$idGroup > 0,]
      df = df[,-c(1,2)]
      dfi =  gather(df[df$Concepto == "Ingresos",], "Mes", "Concepto")
      dfg =  gather(df[df$Concepto == "Gastos",],   "Mes", "Concepto")
      colnames(dfi) = c("Mes", "Ingresos")
      colnames(dfg) = c("Mes", "Gastos")
      df2 = full_join(dfi, dfg, by="Mes")
      
      df2$Mes = as.integer(df2$Mes)
      fig = plot_ly(df2, x=~Mes, y=~Gastos, type="bar")
      #fig %>% add_trace(x=~Mes, y=~Ingresos, type="bar")
      fig      
   }
   refresh = function (reload = TRUE) {
      pnl$refreshData(reload)
      output$tblExpenses = updTable({ pnl$getExpensesTable(ns("tblExpenses")) })
      output$tblIncomes  = updTable({ pnl$getIncomesTable(ns("tblIncomes")) })
      output$tblSummary  = updTable({ pnl$getSummaryTable() })
#      output$plot        = renderPlotly   ({ makePlot()  })
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

   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   
})
}
