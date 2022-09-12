mod_budget_server <- function(id, session) {
ns = NS(id)
PNLBudget = R6::R6Class("CONTA.PNL.BUDGET"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,active = list(
     loaded = function(value) {
      if (missing(value)) {
         .loaded
      }
      else {
         private$.loaded = value
         invisible(self)
      }
    }
  )   
  ,public = list(
      initialize     = function(id, factory, session) {
         private$factory = factory
         # super$initialize(id, parent, session)
         private$obj = OBJBudget$new(factory)
      }
     ,loadBudget = function () { obj$getBudget() }
   )
  ,private = list(
     .loaded  = FALSE
     ,factory = NULL
     ,obj     = NULL
   )
)

moduleServer(id, function(input, output, session) {
    pnl = WEB$getPanel(PNLBudget, id, NULL, session)

    jscode = function() {
       data = paste("{ row: rowInfo.index + 1, colName: colInfo.id")
       data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
       evt = paste0("Shiny.setInputValue('", ns("tblBudget"), "',", data, ",{ priority: 'event' });")

         if (is.null(self$id)) return (NULL)
         js_code = "function(rowInfo, colInfo) {"
         # Exclude columns
#         js_code = paste(js_code, " if (colInfo.id !== 'details') { return;  }", sep="\n")
#         js_code = paste(js_code, "window.alert('Details for row ' + rowInfo.index + ':\\n' + JSON.stringify(rowInfo.row, null, 2));", sep="\n")
         js_code = paste(js_code, evt, sep="\n")
         js_code = paste(js_code, "}", sep="\n")
         JS(js_code)
    }
    loadPanel = function () {
       browser()
       df = pnl$loadBudget()
       cols = lapply(1:12, function(x) colDef(aggregate = "sum"))
       names(cols) = as.character(seq(1,12))
       cols[["idGroup"]]    = colDef(show = FALSE)
       cols[["idCategory"]] = colDef(show = FALSE)
       table = reactable(df, groupBy = "Group", columns = cols, onClick = jscode() )
       output$tblBudget = renderReactable({table})
    }
    if (!pnl$loaded) loadPanel()
    
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
   observeEvent(input$tbl_budget, {
      browser()
   })
   

})
}
