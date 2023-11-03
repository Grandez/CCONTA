mod_budget_server = function(id, session) {
ns = NS(id)
PNLBudget = R6::R6Class("CONTA.PNL.BUDGET"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLStatusBase 
  ,public = list(
      initialize  = function (id, parent, session) {
         super$initialize(id, session, TRUE)
         private$objBudget = factory$getObject("Budget")
      }
     ,refreshData = function(reload) {
        df = objBudget$getBudgetByPeriod(self$data$period, reload)
        # Si son datos de un mes, vienen en columnas. Pasarlos a filas
        # if (self$data$period > 0) {
        #    df = pivot_longer(df, cols=4:ncol(df), names_to = "period", values_to="amount")
        #    df$period = as.integer(df$period) # Ajustar el dia que es caracter
        # }
        objPage$setData(df, self$data$period)
     }
     ,updateBudget = function (amount) {
        item = vars$item
        item$amount = amount
        objBudget$update(item, data$period, vars$expense)
     }
   )
  ,private = list(
     objBudget = NULL
   )
)

moduleServer(id, function(input, output, session) {
    pnl = WEB$getPanel(id, PNLBudget, NULL, session)

    dataModal <- function(failed = FALSE) {
       item = pnl$vars$item
       monthNumber = ifelse(pnl$data$period == 0, as.integer(item$col), pnl$data$period)
       monthName   = month_long(monthNumber)
       if (pnl$data$period > 0) monthName = paste(monthName, "-", item$col)
       modalDialog(
           tags$h5(paste(item$group, "/" , item$category))
          ,tags$h5(monthName)
          ,guiNumericInput(ns("impFormBudget"), NULL, item[[item$col]])
          ,span('El valor se aplicara a todo el año')
          ,if (failed) {
               div(tags$b("Invalid name of data object", style = "color: red;"))
           }  
          ,title = "Presupuesto"
          ,footer = tagList(modalButton("Cancel"),actionButton(ns("formOK"), "Aplicar"))
          ,easyClose = TRUE
          ,fade = TRUE
       )
    }

   # makePlot = function() {
   #    df = pnl$getDataSummary()
   #    df = df[df$idGroup > 0,]
   #    df = df[,-c(1,2)]
   #    dfi =  gather(df[df$Concepto == "Ingresos",], "Mes", "Concepto")
   #    dfg =  gather(df[df$Concepto == "Gastos",],   "Mes", "Concepto")
   #    colnames(dfi) = c("Mes", "Ingresos")
   #    colnames(dfg) = c("Mes", "Gastos")
   #    df2 = full_join(dfi, dfg, by="Mes")
   #    
   #    df2$Mes = as.integer(df2$Mes)
   #    fig = plot_ly(df2, x=~Mes, y=~Gastos, type="bar")
   #    #fig %>% add_trace(x=~Mes, y=~Ingresos, type="bar")
   #    fig      
   # }
   refresh = function (reload = TRUE) {
      pnl$refreshData(reload)
      output$tblExpenses = updTable({ pnl$getExpensesTable(ns("tblExpenses")) })
      output$tblIncomes  = updTable({ pnl$getIncomesTable(ns("tblIncomes")) })
      output$tblSummary  = updTable({ pnl$getSummaryTable() })
#      output$plot        = renderPlotly   ({ makePlot()  })
   }
   observeEvent(input$cboPeriod, { 
      pnl$data$period = as.integer(input$cboPeriod)
      refresh(FALSE)
   }, ignoreInit = TRUE)
   observeEvent(input$chkCategories, { 
      pnl$setCategories(input$chkCategories)
      refresh(FALSE)
   }, ignoreInit = TRUE)
   

   observeEvent(input$tblExpenses, {
      # Las filas son zero-based
      value = suppressWarnings(as.integer(input$tblExpenses$rowId))
      if (is.na(value)) return() # Es la fila de agrupacion
      value = suppressWarnings(as.integer(input$tblExpenses$colId))
      if (is.na(value)) return() # Es la columna de categoria

      pnl$vars$expense  = TRUE
      pnl$vars$item     = jsonlite::fromJSON(input$tblExpenses$detail)
      pnl$vars$item$row = input$tblExpenses$row
      pnl$vars$item$col = input$tblExpenses$colId
      
      showModal(dataModal())   
   })
   observeEvent(input$tblIncomes, {
      # Las filas son zero-based
      value = suppressWarnings(as.integer(input$tblExpenses$rowId))
      if (is.na(value)) return() # Es la fila de agrupacion
      value = suppressWarnings(as.integer(input$tblExpenses$colId))
      if (is.na(value)) return() # Es la columna de categoria
      
      pnl$vars$expense  = FALSE
      pnl$vars$item     = jsonlite::fromJSON(input$tblIncomes$detail)
      pnl$vars$item$row = input$tblIncomes$row
      pnl$vars$item$col = input$tblIncomes$colId

      showModal(dataModal())   
   })

   observeEvent(input$formOK, {
      if (input$impFormBudget < 0) {
         showModal(dataModal(failed = TRUE))   
      } else {
        rc = pnl$updateBudget(input$impFormBudget)   
        removeModal()  
        if (rc) {
            showModal(modalDialog(title = "La cagaste",easyClose = TRUE,footer = NULL))           
        } else {
           refresh(TRUE)
        }
      }
   })   
   
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   
})
}
