mod_position_server <- function(id, session) {
ns = NS(id)
PNLPosition = R6::R6Class("CONTA.PNL.POSITION"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,public     = list(
      data = list()
     ,position = NULL
     ,initialize    = function(id, parent, session) {
         super$initialize(id, session, TRUE) 
         private$tblAcc  = factory$getTable("Accounts")
         private$xfer = factory$getObject("Transfers")
#         private$tblMov  = factory$gettable("Accounts")
         self$data$accounts = tblAcc$table(active = 1)
         self$data$accounts = self$data$accounts[,c("id", "name","descr")]
         for (m in 1:12) self$data$accounts[,as.character(m)] = 0
         self$data$accounts$descr = ifelse(is.na(data$accounts$descr), data$accounts$name, data$accounts$descr)
     }
     ,calculatePosition = function() {
        df = xfer$getHistory()
        acc = data$accounts
        if (nrow(df) == 0) return()
        for (row in 1:nrow(df)) {
           idx = which(acc[, "id"] == as.integer(df[row, "origin"]))
           value = as.numeric(acc[idx, as.character(df[row,"month"])])
           acc[idx, as.character(df[row,"month"])] = value - df[row,"amount"]
           idx   = which(acc[, "id"] == as.integer(df[row, "target"]))
           value = as.numeric(acc[idx, as.character(df[row,"month"])])
           acc[idx, as.character(df[row,"month"])] = value + df[row,"amount"]
        }
        self$data$accounts = acc
     }
   )
  ,private = list(
      .expense = FALSE
     ,tblAcc   = NULL
     ,xfer  = NULL
     ,tblMov   = NULL
     ,dfAccounts = NULL
   )
)

moduleServer(id, function(input, output, session) {

   pnl = WEB$getPanel(id, PNLPosition, NULL, session)

   flags = reactiveValues(
       type    = FALSE
      ,itemize = FALSE
   ) 

  #  validate  = function() {
  #     # dfInput se supone que siempre tiene valor
  #     if (as.integer(input$cboMethods) == 0) {
  #        output$txtMessage = renderText({"Invalid Method"})
  #        return (TRUE)
  #     }
  #     if (as.integer(input$cboGroups) == 0) {
  #        output$txtMessage = renderText({"Invalid Group"})
  #        return (TRUE)
  #     }
  #     if (as.integer(input$cboCategories) == 0) {
  #        output$txtMessage = renderText({"Invalid Category"})
  #        return (TRUE)
  #     }
  #     if (input$impExpense <= 0) {
  #        output$txtMessage = renderText({"Invalid amount"})
  #        return (TRUE)
  #     }
  #     if (!pnl$itemized) return (FALSE)
  #     
  #     if (input$impExpense > pnl$data$origin$pending) {
  #        output$txtMessage = renderText({"Invalid amount. Excess original expense"})
  #        return (TRUE)
  #     }
  #     
  #     FALSE
  #  }
  #  clearForm = function(value = 0) {
  #     updNumericInput("impExpense", value = value)
  #     updateTextAreaInput(session, "txtNote", value="")
  #     updateTextAreaInput(session, "txtTags", value="")
  #  }
  #  addItem = function() {
  #     item = list( 
  #         idGroup    = as.integer(input$cboGroups)
  #        ,idCategory = as.integer(input$cboCategories)
  #        ,amount   = input$impExpense
  #        ,note     = input$txtNote
  #        ,tags     = input$txtTags
  #     )
  #     idx = length(pnl$data$items) + 1
  #     pnl$data$items[[idx]] = item
  #     
  #     pnl$data$origin$current = pnl$data$origin$current + item$amount
  #     pnl$data$origin$pending = pnl$data$origin$pending - item$amount
  #     browser()
  #     updateItemization(item)
  #     clearForm(pnl$data$origin$pending)      
  #  }
  #  updateItemization = function (item) {
  #     
  #     output$lblTotal   =  updLabelNumber(pnl$data$origin$total)
  #     output$lblCurrent =  updLabelNumber(pnl$data$origin$current)
  #     output$lblPending =  updLabelNumber(pnl$data$origin$pending)
  #     
  #     if (missing(item)) return()
  #     
  #     szGroup    = pnl$getGroupName   (item$idGroup)
  #     szCategory = pnl$getCategoryName(item$idGroup, item$idCategory)
  #     
  #     df1         = data.frame(Grupo=szGroup,Categoria=szCategory,Importe=item$amount)
  #     pnl$data$df = rbind(pnl$data$df, df1)
  #     
  #     output$tblItemization  = renderReactable({ reactable(pnl$data$df) })
  #  }
  #  
  #  ##################################################################
  #  # Flags event
  #  ##################################################################
  #  
  #  observeEvent(flags$type, ignoreInit = TRUE, {
  #     df = pnl$getMethods()
  #     updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
  #     df = pnl$getGroups()
  #     updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
  #  })
  #  observeEvent(flags$itemize, ignoreInit = TRUE, {
  #     pnl$itemized     = !pnl$itemized
  #     shinyjs::toggle("divItemize")
  #     shinyjs::toggle("btnItemize")
  #     fnEnable = shinyjs::enable
  #     if (pnl$itemized) fnEnable = shinyjs::disable     
  #     fnEnable("dtInput")
  #     fnEnable("cboMethods")
  #     fnEnable("cboType")
  #     
  #     if (!pnl$itemized) {
  #        base = pnl$data$base
  #        # restart values to origin
  #        updCombo("cboGroups",     selected = base$idGroup)
  #        updCombo("cboCategories", selected = base$idCategory)
  #        updNumericInput("impExpense", value = base$amount)
  #        updTextArea("txtNote", base$note)
  #        updTextArea("txtTags", base$tags)
  #        updButton("btnOK", label="Desglosar")
  #     }  else {
  #        updButton("btnOK", label="Insertar")
  #     }   
  # 
  #  })
  #  
  #  ##################################################################
  #  # Events
  #  ##################################################################
  #  
  #  observeEvent(input$swType,        {
  #     pnl$expense = input$swType
  #     flags$type  = isolate(!flags$type)
  #  })
  #  observeEvent(input$cboGroups,     {
  #     if (input$cboGroups == 0) return()
  #     group = as.integer(input$cboGroups)
  #     pnl$set(idGroup = group)
  #     df = pnl$getCategories(group)
  #     updateSelectInput(session, "cboCategories", choices = WEB$makeCombo(df))
  #  })
  #  observeEvent(input$impExpense,    { 
  #     if (!is.numeric(input$impExpense)) return () # No valido
  #     if (pnl$itemized)                  return()
  #     
  #     if (!pnl$expense || input$impExpense <= 0) {
  #        shinyjs::hide("btnItemize")
  #        return()
  #     }
  #     shinyjs::show("btnItemize")
  #  })
  #  
  #  observeEvent(input$cboMethods,    { pnl$set(idMethod   = as.integer(input$cboMethods))    })
  #  observeEvent(input$cboCategories, { pnl$set(idCategory = as.integer(input$cboCategories)) })
  #  observeEvent(input$cboType,       { pnl$set(type       = as.integer(input$cboType))       })
  #  observeEvent(input$dtInput,       { pnl$set(dateOper   = input$dtInput)                   
  #                                      pnl$set(dateVal    = input$dtInput)                   })
  #  observeEvent(input$btnOK, {
  #     txtType = ifelse(pnl$expense, "Gasto", "Ingreso")
  #     if (validate()) return()
  #     
  #     output$txtMessage = renderText({""})
  #     mtype = as.integer(input$cboType)
  #     if (pnl$expense) mtype = mtype * -1
  #     if (!pnl$itemized) {
  #         id = pnl$add( dateOper = input$dtInput,    dateVal = input$dtInput
  #                      ,amount   = input$impExpense
  #                      ,note     = input$txtNote,    tags   = input$txtTags)
  #         if (id > 0) {
  #             clearForm()
  #             output$txtMessage = renderText({paste(txtType, "introducido con id ", id)})
  #         }
  #     }
  #     if (pnl$itemized) addItem()
  #  })
  #  observeEvent(input$btnKO, { clearForm() })
  #  observeEvent(input$btnItemize, {
  #     if (validate()) return()
  #     flags$itemize  = isolate(!flags$itemize)
  #     pnl$data$origin = list( total = input$impExpense, current = 0, pending = input$impExpense)
  #     pnl$data$base = list( 
  #         dateOper   = input$dtInput
  #        ,dateVal    = input$dtInput
  #        ,amount     = input$impExpense
  #        ,note       = input$txtNote
  #        ,tags       = input$txtTags
  #        ,idGroup    = as.integer(input$cboGroups)
  #        ,idCategory = as.integer(input$cboCategories)
  #        ,idMethod   = as.integer(input$cboMethods)
  #     )
  #     updateItemization()
  #  })
  # observeEvent(input$btnCancel, {
  #    pnl$data$items  = NULL
  #    flags$itemize  = isolate(!flags$itemize)
  #    # Desahcer todo
  # })
  # observeEvent(input$btnProcess, {
  #    txtType = ifelse(pnl$expense, "Gasto", "Ingreso")
  #    id = pnl$itemize()
  #    if (id > 0) {
  #        flags$itemize  = isolate(!flags$itemize)
  #        clearForm()
  #        output$txtMessage = renderText({paste(txtType, "introducido con id ", id)})
  #    }
  # })
  
   if (!pnl$loaded) {
      pnl$calculatePosition()
      output$tblPosition  = renderReactable({ reactable(pnl$data$accounts) })
   }  
})
}
