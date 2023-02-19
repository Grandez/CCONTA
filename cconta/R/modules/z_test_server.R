mod_test_server <- function(id, session) {
ns = NS(id)
PNLTest = R6::R6Class("CONTA.PNL.TEST"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,public     = list(
      data = list()
     ,position = NULL
     ,initialize    = function(id, parent, session) {
#          super$initialize(id, session, TRUE) 
#          private$tblAcc  = factory$getTable("Accounts")
#          private$xfer = factory$getObject("Transfers")
# #         private$tblMov  = factory$gettable("Accounts")
#          self$data$accounts = tblAcc$table(active = 1)
#          self$data$accounts = self$data$accounts[,c("id", "name","descr")]
#          for (m in 1:12) self$data$accounts[,as.character(m)] = 0
#          self$data$accounts$descr = ifelse(is.na(data$accounts$descr), data$accounts$name, data$accounts$descr)
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
message("Entering server")
   pnl = WEB$getPanel(id, PNLTest, NULL, session)
   browser()
output$table <- renderReactable({reactable(iris)})
   # if (!pnl$loaded) {
   #    pnl$calculatePosition()
   #    output$tblPosition  = renderReactable({ reactable(pnl$data$accounts) })
   # }  
})
}
