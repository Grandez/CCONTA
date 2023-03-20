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
         private$objMovements = factory$getObject("Movements")
         # Los tipos son numeros secuenciales (1,2,3)
         self$vars$types = rep(TRUE, max(unlist(CTES$TYPE)))
#         objMovements$loadMovements()
      }
     ,refreshData = function() {
        data = objMovements$getMovements()
        data = data[data$type %in% which(self$vars$types == TRUE),]
        data$month = lubridate::month(data$dateVal)
        df = data[,c("idGroup", "idCategory", "month", "expense", "amount")]
        objPage$setData(df)
     }
   )
  ,private = list(
     objMovements = NULL
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
   refresh = function () {
      message("refresh")
      pnl$refreshData()
      output$tblExpenses = updTable({ pnl$getExpenses(ns("tblExpenses")) })
      output$tblIncomes  = updTable({ pnl$getIncomes(ns("tblIncomes")) })
      output$tblSummary  = updTable({ pnl$getSummary() })
#      output$plot        = renderPlotly   ({ makePlot()  })
   }
   observeEvent(input$swExpected, {
              message("swExpected")
      pnl$vars$types[CTES$TYPE$Expected] = input$swExpected
      refresh()
   }, ignoreInit = TRUE)
   observeEvent(input$swProvision, {
      message("swProvision")
      pnl$vars$types[CTES$TYPE$Provision] = input$swExpected
      refresh()
   }, ignoreInit = TRUE)
   
   if (!pnl$loaded) {
      message("Loading")
      pnl$loaded = TRUE
      refresh()
   }
   
})
}
