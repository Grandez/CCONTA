mod_input_server <- function(id, session) {
ns = NS(id)
PNLInput = R6::R6Class("CONTA.PNL.INPUT"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,active = list(
      expense = function(value) {
         if (missing(value)) return (.expense)
         private$.expense = value
         obj$set(expense = ifelse(value, 1, 0))
         invisible(self)
      }
   )  
  ,public     = list(
      initialize    = function(id, session) {
         super$initialize(id, session, TRUE) 
         private$obj = factory$getObject("Movements")
      }
     ,getGroups     = function ()          { obj$getGroups     (ifelse(.expense, "expenses", "incomes")) }
     ,getCategories = function (group = 0) { obj$getCategories (.expense, group)         }
     ,getMethods    = function ()          { obj$getMethods    (.expense)                }
     ,add           = function (...)       { obj$add(...)                                }
     ,set           = function ( ... ) {
        obj$set(...)
        invisible(self)
     }
     # ,add        = function(...) { obj$add(...)    }
     # ,loadBudget = function ()   { obj$getBudget() }
   )
  ,private = list(
      .expense = FALSE
     ,obj      = NULL
   )
)

moduleServer(id, function(input, output, session) {

   pnl = WEB$getPanel(id, PNLInput, session)

   flags = reactiveValues(
         type    = FALSE
   ) 

   validate  = function() {
      # dfInput se supone que siempre tiene valor
      if (as.integer(input$cboMethods) == 0) {
         output$txtMessage = renderText({"Invalid Method"})
         return (TRUE)
      }
      if (as.integer(input$cboGroups) == 0) {
         output$txtMessage = renderText({"Invalid Group"})
         return (TRUE)
      }
      if (as.integer(input$cboCategories) == 0) {
         output$txtMessage = renderText({"Invalid Category"})
         return (TRUE)
      }
      if (input$impExpense <= 0) {
         output$txtMessage = renderText({"Invalid amount"})
         return (TRUE)
      }
      FALSE
   }
   clearForm = function() {
      updateNumericInput (session, "impExpense", value=0)
      updateTextAreaInput(session, "txtNote", value="")
      updateTextAreaInput(session, "txtTags", value="")
   }
   
   # Flags event
   observeEvent(flags$type, ignoreInit = TRUE, {
      df = pnl$getMethods()
      updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
      df = pnl$getGroups()
      updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
   })
   observeEvent(input$swType,        {
      pnl$expense = input$swType
      flags$type  = isolate(!flags$type)
   })
   observeEvent(input$cboGroups,     {
      if (input$cboGroups == 0) return()
      group = as.integer(input$cboGroups)
      pnl$set(idGroup = group)
      df = pnl$getCategories(group)
      updateSelectInput(session, "cboCategories", choices = WEB$makeCombo(df))
   })
   observeEvent(input$cboMethods,    { pnl$set(idMethod   = as.integer(input$cboMethods))    })
   observeEvent(input$cboCategories, { pnl$set(idCategory = as.integer(input$cboCategories)) })
   observeEvent(input$cboType,       { pnl$set(type       = as.integer(input$cboType))       })
   observeEvent(input$dtInput,       { pnl$set(dateOper   = input$dtInput)                   
                                       pnl$set(dateVal    = input$dtInput)                   })
   
   observeEvent(input$btnOK, {
      txtType = ifelse(pnl$expense, "Gasto", "Ingreso")
      if (validate()) return()
      
      output$txtMessage = renderText({""})
      mtype = as.integer(input$cboType)
      if (pnl$expense) mtype = mtype * -1
      id = pnl$add( dateOper   = input$dtInput, dateVal   = input$dtInput
                   # ,idMethod   = as.integer(input$cboMethods),    idGroup = as.integer(input$cboGroups)
                   # ,idCategory = as.integer(input$cboCategories)
                   ,amount = input$impExpense
                   ,note     = input$txtNote,                   tags   = input$txtTags)
      if (id > 0) {
         clearForm()
         output$txtMessage = renderText({paste(txtType, "introducido con id ", id)})
      }
   })
   observeEvent(input$btnKO, { clearForm() })

})
}
