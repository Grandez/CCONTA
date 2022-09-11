mod_input_server <- function(id, session) {
ns = NS(id)
# PNLAdmin = R6::R6Class("PNL.ADMIN"
#   ,inherit    = WEBPanel
#   ,cloneable  = FALSE
#   ,lock_class = TRUE
#   ,public = list(
#       initialize     = function(id, parent, session) {
#          super$initialize(id, parent, session)
#       }
#    )
#   ,private = list(
#    )
# )

moduleServer(id, function(input, output, session) {
   # pnl = WEB$root$getPanel(PNLAdmin, id, parent, session)

loadExpense = function() {
   obj = WEB$factory$getObject("Expenses")
   df = obj$getMethods()
   updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
   df = obj$getGroups()
   updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
}
   
   observeEvent(input$swIncome, {
      if (input$swIncome) {
         shinyjs::hide("div_expense")
         shinyjs::show("div_income")
         
      } else {
         shinyjs::hide("div_income")
         shinyjs::show("div_expense")
         loadExpense()
      }
   })
   observeEvent(input$cboGroups, {
      if (input$cboGroups == -1) return()
      obj = WEB$factory$getObject("Expenses")
      obj$setGroup(input$cboGroups)
      df = obj$getCategories(input$cboGroups)
      updateSelectInput(session, "cboCategories", choices = WEB$makeCombo(df))
   })
   

})
}
