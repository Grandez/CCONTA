mod_input_server <- function(id, session) {
ns = NS(id)
PNLInput = R6::R6Class("CONTA.PNL.INPUT"
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
     ,expense = function(value) {
      if (missing(value)) {
         .expense
      }
      else {
         private$.expense = value
         if (value)  private$obj = private$objExpense
         if (!value) private$obj = private$objIncome
         invisible(self)
      }
    }
     
  )   
  ,public = list(
      initialize     = function(id, factory, session) {
         private$factory = factory
         private$objExpense = factory$getObject("Expenses")
         private$objIncome  = factory$getObject("Incomes")
         private$obj        =  private$objIncome
         if (self$expense) private$obj = private$objExpense
      }
     ,add        = function(...) { obj$add(...)    }
     ,loadBudget = function ()   { obj$getBudget() }
   )
  ,private = list(
      .loaded  = FALSE
     ,.expense = TRUE
     ,objExpense = NULL
     ,objIncome  = NULL
     ,factory    = NULL
     ,obj        = NULL
   )
)

moduleServer(id, function(input, output, session) {

   pnl = WEB$getPanel(PNLInput, id, parent, session)

   loadExpense = function() {
      obj = WEB$factory$getObject("Expenses")
      df = obj$getMethods()
      updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
      df = obj$getGroups()
      updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
   }
   validateExpense = function() {
      # dfInput se supone que siempre tiene valor
      if (as.integer(input$cboMethods) < 1) {
         output$txtMessage = renderText({"Invalid Method"})
         return (TRUE)
      }
      if (as.integer(input$cboGroups) < 1) {
         output$txtMessage = renderText({"Invalid Group"})
         return (TRUE)
      }
      if (as.integer(input$cboCategories) < 1) {
         output$txtMessage = renderText({"Invalid Category"})
         return (TRUE)
      }
      if (input$impExpense <= 0) {
         output$txtMessage = renderText({"Invalid amount"})
         return (TRUE)
      }
      FALSE
   }
   makeExpense = function() {
      output$txtMessage = renderText({""})
      if (validateExpense()) return(0)
      pnl$add( date     = input$dtInput
              ,method   = as.integer(input$cboMethods),    group = as.integer(input$cboGroups)
              ,category = as.integer(input$cboCategories), amount = input$impExpense
              ,note     = input$txtNote,                   tags   = input$txtTags, type = 1)
   }
   observeEvent(input$swIncome, {
      if (input$swIncome) {
         shinyjs::hide("div_expense")
         shinyjs::show("div_income")
         pnl$expense = FALSE
         
      } else {
         shinyjs::hide("div_income")
         shinyjs::show("div_expense")
         pnl$expense = TRUE
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
   observeEvent(input$btnOK, {
      txtType = ifelse(pnl$expense, "Gasto", "Ingreso")
      rc = ifelse(pnl$expense, makeExpense(), makeIncome())
      browser()
      if (rc > 0) {
         output$txtMessage = renderText({paste(txtType, "introducido con id ", rc)})
      }
   })
   observeEvent(input$btnKO, {
      updateDateInput    (session, "dtInput",    value=Sys.Date())
      updateNumericInput (session, "impExpense", value=0)
      updateTextAreaInput(session, "txtNote", value="")
      updateTextAreaInput(session, "txtTags", value="")
   })

})
}
