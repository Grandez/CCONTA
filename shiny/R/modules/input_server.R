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
      data = list()
     ,itemized = FALSE
     ,initialize    = function(id, session) {
         super$initialize(id, session, TRUE) 
         private$obj = factory$getObject("Movements")
      }
     ,getGroups     = function ()          { obj$getGroups     (ifelse(.expense, "expenses", "incomes")) }
     ,getCategories = function (group = 0) { obj$getCategories (.expense, group)         }
     ,getMethods    = function ()          { obj$getMethods    (.expense)                }
     ,getGroupName  = function (group)     {
        df = obj$getGroups     (ifelse(.expense, "expenses", "incomes"))
        df = df[df$id == group,]
        as.character(df[1,"name"])
     }
     ,getCategoryName  = function (group, category)     {
        df = obj$getCategories (.expense, group)
        df = df[df$id == category,]
        as.character(df[1,"name"])
     }
     
     ,add           = function (...)   { obj$add(...)  }
     ,itemize       = function ()      { 
        if (data$origin$pending > 0) {
            item = list( idGroup    = data$base$idGroup
                        ,idCategory = data$base$idCategory
                        ,amount     = data$origin$pending
                        ,note       = data$base$note
                        ,tags       = data$base$tags)
           data$items[[length(data$items) + 1]] = item
        }
        obj$itemize(data$base, data$items) 
      } 
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
      ,itemize = FALSE
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
      if (!pnl$itemized) return (FALSE)
      
      if (input$impExpense > pnl$data$origin$pending) {
         output$txtMessage = renderText({"Invalid amount. Excess original expense"})
         return (TRUE)
      }
      
      FALSE
   }
   clearForm = function(value = 0) {
      updNumericInput("impExpense", value = value)
      updateTextAreaInput(session, "txtNote", value="")
      updateTextAreaInput(session, "txtTags", value="")
   }
   addItem = function() {
      item = list( 
          idGroup    = as.integer(input$cboGroups)
         ,idCategory = as.integer(input$cboCategories)
         ,amount   = input$impExpense
         ,note     = input$txtNote
         ,tags     = input$txtTags
      )
      idx = length(pnl$data$items) + 1
      pnl$data$items[[idx]] = item
      
      pnl$data$origin$current = pnl$data$origin$current + item$amount
      pnl$data$origin$pending = pnl$data$origin$pending - item$amount
      updateItemization(item)
      clearForm(pnl$data$origin$pending)      
   }
   updateItemization = function (item) {
      
      output$lblTotal   =  updLabelNumber(pnl$data$origin$total)
      output$lblCurrent =  updLabelNumber(pnl$data$origin$current)
      output$lblPending =  updLabelNumber(pnl$data$origin$pending)
      
      if (missing(item)) return()
      
      szGroup    = pnl$getGroupName   (item$idGroup)
      szCategory = pnl$getCategoryName(item$idGroup, item$idCategory)
      
      df1         = data.frame(Grupo=szGroup,Categoria=szCategory,Importe=item$amount)
      pnl$data$df = rbind(pnl$data$df, df1)
      
      output$tblItemization  = renderReactable({ reactable(pnl$data$df) })
   }
   
   ##################################################################
   # Flags event
   ##################################################################
   
   observeEvent(flags$type, ignoreInit = TRUE, {
      df = pnl$getMethods()
      updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
      df = pnl$getGroups()
      updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
   })
   observeEvent(flags$itemize, ignoreInit = TRUE, {
      pnl$itemized     = !pnl$itemized
      shinyjs::toggle("divItemize")
      shinyjs::toggle("btnItemize")
      fnEnable = shinyjs::enable
      if (pnl$itemized) fnEnable = shinyjs::disable     
      fnEnable("dtInput")
      fnEnable("cboMethods")
      fnEnable("cboType")
      
      if (!pnl$itemized) {
         base = pnl$data$base
         # restart values to origin
         updCombo("cboGroups",     selected = base$idGroup)
         updCombo("cboCategories", selected = base$idCategory)
         updNumericInput("impExpense", value = base$amount)
         updTextArea("txtNote", base$note)
         updTextArea("txtTags", base$tags)
         updButton("btnOK", label="Desglosar")
      }  else {
         updButton("btnOK", label="Insertar")
      }   

   })
   
   ##################################################################
   # Events
   ##################################################################
   
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
   observeEvent(input$impExpense,    { 
      if (!is.numeric(input$impExpense)) return () # No valido
      if (pnl$itemized)                  return()
      
      if (!pnl$expense || input$impExpense <= 0) {
         shinyjs::hide("btnItemize")
         return()
      }
      shinyjs::show("btnItemize")
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
      if (!pnl$itemized) {
          id = pnl$add( dateOper = input$dtInput,    dateVal = input$dtInput
                       ,amount   = input$impExpense
                       ,note     = input$txtNote,    tags   = input$txtTags)
          if (id > 0) {
              clearForm()
              output$txtMessage = renderText({paste(txtType, "introducido con id ", id)})
          }
      }
      if (pnl$itemized) addItem()
   })
   observeEvent(input$btnKO, { clearForm() })
   observeEvent(input$btnItemize, {
      if (validate()) return()
      flags$itemize  = isolate(!flags$itemize)
      pnl$data$origin = list( total = input$impExpense, current = 0, pending = input$impExpense)
      pnl$data$base = list( 
          dateOper   = input$dtInput
         ,dateVal    = input$dtInput
         ,amount     = input$impExpense
         ,note       = input$txtNote
         ,tags       = input$txtTags
         ,idGroup    = as.integer(input$cboGroups)
         ,idCategory = as.integer(input$cboCategories)
         ,idMethod   = as.integer(input$cboMethods)
      )
      updateItemization()
   })
  observeEvent(input$btnCancel, {
     pnl$data$items  = NULL
     flags$itemize  = isolate(!flags$itemize)
     # Desahcer todo
  })
  observeEvent(input$btnProcess, {
     txtType = ifelse(pnl$expense, "Gasto", "Ingreso")
     id = pnl$itemize()
     if (id > 0) {
         flags$itemize  = isolate(!flags$itemize)
         clearForm()
         output$txtMessage = renderText({paste(txtType, "introducido con id ", id)})
     }
  })
  
  
})
}
