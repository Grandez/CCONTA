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
         private$frmSummary   = factory$getObject("FrameSummary",  force = TRUE)
         private$frmIncomes   = factory$getObject("FrameIncomes",  force = TRUE)
         private$frmExpenses  = factory$getObject("FrameExpenses", force = TRUE)
      }
     ,getSummary  = function (target) { frmSummary$getReactable (target) }
     ,getIncomes  = function (target) { frmIncomes$getReactable (target) }
     ,getExpenses = function (target) { 
        data = frmExpenses$getData() 
        cnames = lapply(1:12, function(x) month_short(x))
        names(cnames) = as.character(seq(1,12))
        tbl = makeGroupedTable( data
                               ,group="Group", columns=as.character(seq(1,12)), method="sum"
                               ,colNames=cnames, click=ns("tblExpenses")
                               ,hide=c("idGroup", "idCategory", "row")
                              )
        tbl
      # ,getReactable = function (idTable) {
      #     cols = lapply(1:12, function(x) colDef(name=monthLong[x], aggregate = "sum"))
      #     names(cols) = as.character(seq(1,12))
      #     cols[["idGroup"]]    = colDef(show = FALSE)
      #     cols[["idCategory"]] = colDef(show = FALSE)
      #     cols[["Group"]]      = colDef(name = "Grupo",     width = 150)
      #     cols[["Category"]]   = colDef(name = "Categoria", width = 200)
      #     if ("row" %in% colnames(dfData)) cols[["row"]] = colDef(show = FALSE)
      #    
      #     reactable(private$dfData, groupBy = "Group", columns = cols) # , onClick = jscode(idTable) )
      # }
      #   
      }
     
     ,loadBudget = function () { obj$getBudget() }
   )
  ,private = list(
      frmSummary   = NULL
     ,frmIncomes   = NULL
     ,frmExpenses  = NULL
   )
)
   
moduleServer(id, function(input, output, session) {
    pnl = WEB$getPanel(id, PNLBudget, NULL, session)

   refresh = function () {
      #pnl$refreshData()
      output$tblSummary  = renderReactable({ pnl$getSummary(ns("tblSummary"))   })
      output$tblIncomes  = renderReactable({ pnl$getIncomes (ns("tblIncomes"))  })
      tbl = pnl$getExpenses(ns("tblExpenses"))
      output$tblExpenses = updTable({tbl})
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
      browser()
   })
   

})
}
