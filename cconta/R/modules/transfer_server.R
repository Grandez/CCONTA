mod_xfer_server <- function(id, session) {
ns = NS(id)
PNLXfer = R6::R6Class("CONTA.PNL.TARNSFER"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,public     = list(
      accounts = NULL
     ,initialize    = function(id, parent, session) {
         super$initialize(id, session, TRUE) 
         private$obj = factory$getObject("Transfers")
         self$accounts = obj$getAccounts()
     }
     ,add = function (...) { 
        res = obj$add(...) 
        if (res == 0) self$exception = obj$exception
        res
      }
   )
  ,private = list(
      obj = NULL
   )
)

moduleServer(id, function(input, output, session) {

   pnl = WEB$getPanel(id, PNLXfer, NULL, session)

   validate  = function() {
      val = suppressWarnings(as.integer(input$cboFrom))
      if (is.na(val)) {
         output$txtMessage = renderText({"Cuenta origen invalida"})
         return (TRUE)
      }
      val = suppressWarnings(as.integer(input$cboTo))
      if (is.na(val)) {
         output$txtMessage = renderText({"Cuenta destino invalida"})
         return (TRUE)
      }
      if (input$impTransfer <= 0) {
         output$txtMessage = renderText({"Cantidad a transferir invalida"})
         return (TRUE)
      }
      FALSE
   }
   
   clearForm = function() {
      updNumericInput("impTransfer")
   }
   observeEvent(input$cboFrom, ignoreInit = TRUE, ignoreNULL = TRUE, {
      df = pnl$accounts
      df = df[df$id != as.integer(input$cboFrom),]
      updCombo("cboTo", choices = WEB$makeCombo(df))
   })
   observeEvent(input$btnOK, {
      if (validate()) return()
      output$txtMessage = renderText({""})
      id = pnl$add( origin = as.integer(input$cboFrom), target = as.integer(input$cboTo)
                   ,dtOper = as.character(as.Date(input$dtInput))
                   ,dtVal  = as.character(as.Date(input$dtInput))
                   ,amount = input$impTransfer, note = input$txtNote)

      if (id > 0) {
         clearForm()
         output$txtMessage = renderText({paste("Trasnferencia realizada con id ", id)})
      }
   })
   
   observeEvent(input$btnKO, { clearForm() })   

   if (!pnl$loaded) {
      pnl$loaded = TRUE
      updCombo("cboFrom", choices = WEB$makeCombo(pnl$accounts))
   }
})
}
