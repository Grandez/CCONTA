mod_expected_server = function(id, full, pnlParent, parent=NULL) {
ns = NS(id)
PNLExpected = R6::R6Class("CONTA.PNL.EXPECTED"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase   
  ,public = list(
      initialize     = function (id, parent, session) {
         super$initialize(id, session, TRUE)
         private$objMov        = factory$getObject("Movements")
         private$gridSummary   = factory$getObject("Grid", force = TRUE)
         private$gridIncomes   = factory$getObject("Grid", force = TRUE, grouping="Group")
         private$gridExpenses  = factory$getObject("Grid", force = TRUE, grouping="Group")
         reload()
      }
     ,reload      = function () {
        self$data$df = objMov$getPrevision()
     }
     ,getSummary  = function () {
         Ingresos = objBudget$getIncomesTotal()
         Gastos   = objBudget$getExpensesTotal() * -1
         df = rbind(Ingresos, Gastos)
         Diff = colSums(df)
         Acum = Diff
         for (idx in 2:length(Acum)) Acum[idx] = Acum[idx] + Acum[idx - 1]
         mat = rbind(df, Diff, Acum)
         gridSummary$setData(as.data.frame(mat))
         gridSummary$getTable()
      }
     ,getIncomes  = function (target, refresh=TRUE) {
        if (refresh) gridIncomes$setData(objMov$getIncomes())
        gridIncomes$getTable(target)
      }
     ,getExpenses = function (target) {
        browser()
        gridExpenses$setData(data$df[data$df$expense == 1,])$getTable(target)
         gridExpenses$getTable(target)
      }
     # 
     # ,loadBudget = function () { obj$getBudget() }
     # ,updateBudget = function() {
     #    browser()
     #     data = list( group = vars$row$idGroup
     #                 ,category = vars$row$idCategory
     #                 ,year     = WEB$year
     #                 ,from     = vars$from
     #                 ,to       = vars$to
     #                 ,amount   = vars$amount
     #                )
     #    objBudget$setBudget(data)  
     #    invisible(self)
     # }
   )
  ,private = list(
      objMov = NULL
     ,gridSummary   = NULL
     ,gridIncomes   = NULL
     ,gridExpenses  = NULL
   )
)
   
moduleServer(id, function(input, output, session) {
    pnl = WEB$getPanel(id, PNLExpected, NULL, session)

   # popupModal = function(failed = FALSE) {
   #    info = pnl$vars$row
   #    modalDialog(
   #       tags$table(
   #           tags$tr(tags$td("Grupo"),           tags$td(strong(info$Group)))
   #          ,tags$tr(tags$td("Categoria"),       tags$td(strong(info$Category)))
   #          ,tags$tr(tags$td(strong("Desde")),   tags$td(guiComboMonth(ns("cboFrmFrom"), info$month)))
   #          ,tags$tr(tags$td(strong("Hasta")),   tags$td(guiComboMonth(ns("cboFrmTo"), 12)))
   #          ,tags$tr(tags$td(strong("Importe")), tags$td(guiNumericInput (ns("numFrmAmount"),    NULL, info[[info$month]])))
   #       )
   #      ,if (failed)
   #           div(tags$b("You did not input anything", style = "color: red;")),
   #           footer = tagList(
   #              modalButton("Cancel"),
   #              actionButton(ns("btnFrmOK"), "OK")
   #           )
   #       )
   # }    
   refresh = function () {
      output$tblExpenses = updTable({ pnl$getExpenses(ns("tblExpenses"), TRUE) })
      output$tblIncomes  = updTable({ pnl$getIncomes(ns("tblIncomes"), TRUE) })
      output$tblSummary  = updTable({ pnl$getSummary() })
   }
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
    
#     jscode = function() {
#        data = paste("{ row: rowInfo.index + 1, colName: colInfo.id")
#        data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
#        evt = paste0("Shiny.setInputValue('", ns("tblBudget"), "',", data, ",{ priority: 'event' });")
# 
#          if (is.null(self$id)) return (NULL)
#          js_code = "function(rowInfo, colInfo) {"
#          # Exclude columns
# #         js_code = paste(js_code, " if (colInfo.id !== 'details') { return;  }", sep="\n")
# #         js_code = paste(js_code, "window.alert('Details for row ' + rowInfo.index + ':\\n' + JSON.stringify(rowInfo.row, null, 2));", sep="\n")
#          js_code = paste(js_code, evt, sep="\n")
#          js_code = paste(js_code, "}", sep="\n")
#          JS(js_code)
#     }
#     loadPanel = function () {
#        browser()
#        df = pnl$loadBudget()
#        cols = lapply(1:12, function(x) colDef(aggregate = "sum"))
#        names(cols) = as.character(seq(1,12))
#        cols[["idGroup"]]    = colDef(show = FALSE)
#        cols[["idCategory"]] = colDef(show = FALSE)
#        table = reactable(df, groupBy = "Group", columns = cols, onClick = jscode() )
#        output$tblBudget = renderReactable({table})
#     }
#     if (!pnl$loaded) loadPanel()
    
# loadExpense = function() {
#    obj = WEB$factory$getObject("Expenses")
#    df = obj$getMethods()
#    updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
#    df = obj$getGroups()
#    updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
# }
#    
#    observeEvent(input$swIncome, {
#       if (input$swIncome) {
#          shinyjs::hide("div_expense")
#          shinyjs::show("div_income")
#          
#       } else {
#          shinyjs::hide("div_income")
#          shinyjs::show("div_expense")
#          loadExpense()
#       }
#    })
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
