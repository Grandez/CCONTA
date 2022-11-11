mod_config_server <- function(id, session) {
ns = NS(id)
PNLConfig = R6::R6Class("CONTA.PNL.CONFIG"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,active = list(
      expense = function(value) {
         if (missing(value)) return (.expense)
         private$.expense = value
         obj$set(type = ifelse(value, 1, -1))
         invisible(self)
      }
   )  
  ,public     = list(
      initialize    = function(id, parent, session) {
         super$initialize(id, session, TRUE) 
         private$obj = factory$getObject("Movements")
      }
     ,getGroups     = function ()          { obj$getGroups     (ifelse(.expense, 1, -1)) }
     ,getCategories = function (group = 0) { obj$getCategories (group)                   }
     ,getMethods    = function ()          { obj$getMethods    ()                        }
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

   # pnl = WEB$getPanel(id, PNLInput, session)
   # 
   # flags = reactiveValues(
   #       type    = FALSE
   # ) 
   # 
   # validate  = function() {
   #    # dfInput se supone que siempre tiene valor
   #    if (as.integer(input$cboMethods) == 0) {
   #       output$txtMessage = renderText({"Invalid Method"})
   #       return (TRUE)
   #    }
   #    if (as.integer(input$cboGroups) == 0) {
   #       output$txtMessage = renderText({"Invalid Group"})
   #       return (TRUE)
   #    }
   #    if (as.integer(input$cboCategories) == 0) {
   #       output$txtMessage = renderText({"Invalid Category"})
   #       return (TRUE)
   #    }
   #    if (input$impExpense <= 0) {
   #       output$txtMessage = renderText({"Invalid amount"})
   #       return (TRUE)
   #    }
   #    FALSE
   # }
   # clearForm = function() {
   #    updateNumericInput (session, "impExpense", value=0)
   #    updateTextAreaInput(session, "txtNote", value="")
   #    updateTextAreaInput(session, "txtTags", value="")
   # }
   # 
   # # Flags event
   # observeEvent(flags$type, ignoreInit = TRUE, {
   #    df = pnl$getMethods()
   #    updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
   #    df = pnl$getGroups()
   #    updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
   # })
   # observeEvent(input$swType,        {
   #    pnl$expense = input$swType
   #    flags$type  = isolate(!flags$type)
   # })
   # observeEvent(input$cboGroups,     {
   #    if (input$cboGroups == 0) return()
   #    group = as.integer(input$cboGroups)
   #    pnl$set(group = group)
   #    df = pnl$getCategories(group)
   #    updateSelectInput(session, "cboCategories", choices = WEB$makeCombo(df))
   # })
   # observeEvent(input$cboMethods,    { pnl$set(method   = as.integer(input$cboMethods))    })
   # observeEvent(input$cboCategories, { pnl$set(category = as.integer(input$cboCategories)) })
   # observeEvent(input$dtInput,       { pnl$set(date     = input$dtInput)                   })
   # 
   # observeEvent(input$btnOK, {
   #    txtType = ifelse(pnl$expense, "Gasto", "Ingreso")
   #    if (validate()) return()
   #    
   #    output$txtMessage = renderText({""})
   # 
   #    id = pnl$add( date     = input$dtInput
   #                 ,idMethod   = as.integer(input$cboMethods),    idGroup = as.integer(input$cboGroups)
   #                 ,idCategory = as.integer(input$cboCategories), amount = input$impExpense
   #                 ,note     = input$txtNote,                   tags   = input$txtTags, type = 1)
   #    if (id > 0) {
   #       clearForm()
   #       output$txtMessage = renderText({paste(txtType, "introducido con id ", id)})
   #    }
   # })
   # observeEvent(input$btnKO, { clearForm() })

})
}
