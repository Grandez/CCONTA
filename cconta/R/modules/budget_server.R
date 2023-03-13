mod_budget_server = function(id, full, pnlParent, parent=NULL) {
ns = NS(id)
PNLBudget = R6::R6Class("CONTA.PNL.BUDGET"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase   
  ,public = list(
      initialize     = function (id, parent, session) {
         super$initialize(id, session, TRUE)
         private$objBudget     = factory$getObject("Budget")
         private$gridSummary   = factory$getObject("GridTable", force = TRUE)
         private$gridIncomes   = factory$getObject("GridTable", force = TRUE, grouping="group")
         private$gridExpenses  = factory$getObject("GridTable", force = TRUE, grouping="group")
      }
     ,getSummary  = function () { 
         Ingresos = objBudget$getIncomesTotal()
         Gastos   = objBudget$getExpensesTotal() * -1
         df = rbind(Ingresos, Gastos)
         Diff = colSums(df)
         Acum = Diff
         for (idx in 2:length(Acum)) Acum[idx] = Acum[idx] + Acum[idx - 1]
         mat = rbind(df, Diff, Acum)
         df = as.data.frame(mat)
         gridSummary$setData(as.data.frame(mat))
         gridSummary$getTable()
      }
     ,getIncomes  = function (target, refresh=TRUE) { 
        if (refresh) gridIncomes$setData(objBudget$getIncomes())
        gridIncomes$getTable(target)
      }
     ,getExpenses = function (target, refresh=TRUE) { 
        if (refresh) gridExpenses$setData(objBudget$getExpenses())
        gridExpenses$getTable(target)
      }
     ,loadBudget = function () { obj$getBudget() }
     ,updateBudget = function() {
        browser()
         data = list( group = vars$row$idGroup
                     ,category = vars$row$idCategory
                     ,year     = WEB$year
                     ,from     = vars$from
                     ,to       = vars$to
                     ,amount   = vars$amount
                    )
        objBudget$setBudget(data)  
        invisible(self)
     }
   )
  ,private = list(
      gridSummary   = NULL
     ,gridIncomes   = NULL
     ,gridExpenses  = NULL
     ,objBudget    = NULL
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
      output$tblExpenses = updTable({ pnl$getExpenses(ns("tblExpenses"), TRUE) })
      output$tblIncomes  = updTable({ pnl$getIncomes(ns("tblIncomes"), TRUE) })
      output$tblSummary  = updTable({ pnl$getSummary() })
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
