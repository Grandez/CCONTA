mod_budget_server = function(id, full, pnlParent, parent=NULL) {
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
     ,refreshData = function() {
        data = objBudget$getBudget()
        objPage$setData(data)
     }
   )
  ,private = list(
      objBudget    = NULL
   )
)
   
moduleServer(id, function(input, output, session) {
    pnl = WEB$getPanel(id, PNLBudget, NULL, session)

   popupModal = function(failed = FALSE) {
      info = pnl$vars$row
      modalDialog(
         tags$table(
             tags$tr(tags$td("Grupo"),           tags$td(strong(info$Group)))
            ,tags$tr(tags$td("Categoria"),       tags$td(strong(info$Category)))
            ,tags$tr(tags$td(strong("Desde")),   tags$td(guiComboMonth(ns("cboFrmFrom"), info$month)))
            ,tags$tr(tags$td(strong("Hasta")),   tags$td(guiComboMonth(ns("cboFrmTo"), 12)))
            ,tags$tr(tags$td(strong("Importe")), tags$td(guiNumericInput (ns("numFrmAmount"),    NULL, info[[info$month]])))
         )
        ,if (failed)
             div(tags$b("You did not input anything", style = "color: red;")),
             footer = tagList(
                modalButton("Cancel"),
                actionButton(ns("btnFrmOK"), "OK")
             )
         )
   }  
   refresh = function () {
      browser()
      message("refresh")
      pnl$refreshData()
      output$tblExpenses = updTable({ pnl$getExpenses(ns("tblExpenses")) })
      output$tblIncomes  = updTable({ pnl$getIncomes(ns("tblIncomes")) })
      output$tblSummary  = updTable({ pnl$getSummary() })
#      output$plot        = renderPlotly   ({ makePlot()                         })
   }
   
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   observeEvent(input$tblExpenses, {
      month = suppressWarnings(as.integer(input$tblExpenses$colName))
      pnl$vars$row = jsonlite::fromJSON(input$tblExpenses$detail)
      pnl$vars$row$month = month
   
      if (!is.na(month) && !is.null(pnl$vars$row$idCategory)) {
          showModal(popupModal())
      }
   })
   observeEvent(input$btnFrmOK, {
      pnl$vars$from = as.integer(input$cboFrmFrom)
      pnl$vars$to   = as.integer(input$cboFrmTo)
      pnl$vars$amount = input$numFrmAmount
      removeModal()
      pnl$updateBudget()
   })
})
}
