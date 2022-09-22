mod_detail_server <- function(id, session) {
ns = NS(id)
PNLDetail = R6::R6Class("CONTA.PNL.DETAIL"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase 
  ,public = list(
      initialize     = function (id, factory, session) {
          super$initialize(id, factory, session, TRUE)
         # private$frmSummary   = factory$getObject("FrameSummary",  force = TRUE)
         # private$frmIncomes   = factory$getObject("FrameIncomes",  force = TRUE)
         # private$frmExpenses  = factory$getObject("FrameExpenses", force = TRUE)
          private$objMovements = factory$getObject("Movements")
      }
     ,refreshData = function() {
        # objMovements
        # frmExpenses$set(objMovements$getExpenses())
        # frmIncomes$set (objMovements$getIncomes ())
        # totExpenses = frmExpenses$getTotal()
        # totIncomes  = frmIncomes$getTotal()
        # frmSummary$setIncomes(totIncomes)
        # frmSummary$setExpenses(totExpenses)
     }
     # ,getSummary  = function (target) { frmSummary$getReactable (target) }
     # ,getIncomes  = function (target) { frmIncomes$getReactable (target) }
     # ,getExpenses = function (target) { frmExpenses$getReactable(target) }
   )
  ,private = list(
     #  frmSummary   = NULL
     # ,frmIncomes   = NULL
     # ,frmExpenses  = NULL
     objMovements = NULL
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(PNLDetail, id, NULL, session)
   # 
   refresh = function () {
      pnl$refreshData()
   #    output$tblSummary  = renderReactable({ pnl$getSummary(ns("tblSummary")) })
   #    output$tblIncomes  = renderReactable({ pnl$getIncomes (ns("tblIncomes")) })
   #    output$tblExpenses = renderReactable({ pnl$getExpenses(ns("tblExpenses")) })
   }
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   observeEvent(input$cboGroups, {
# shinyjs::enable("range")
#             }else{
#                 shinyjs::disable("range")      
   })
   
})
}
