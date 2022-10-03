mod_status_server = function(id, session) {
ns = NS(id)
PNLStatus = R6::R6Class("CONTA.PNL.STATUS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase 
  ,public = list(
      byDateValue = TRUE     
     ,initialize  = function (id, session) {
         super$initialize(id, session, TRUE)
         private$frmSummary   = factory$getObject("FrameSummary",  force = TRUE)
         private$frmIncomes   = factory$getObject("FrameIncomes",  force = TRUE)
         private$frmExpenses  = factory$getObject("FrameExpenses", force = TRUE)
         private$objMovements = factory$getObject("Movements")
      }
     ,refreshData = function() {
        frmExpenses$set(objMovements$getExpenses(), dateValue = byDateValue)
        frmIncomes$set (objMovements$getIncomes (), dateValue = byDateValue)
        totExpenses = frmExpenses$getTotal()
        totIncomes  = frmIncomes$getTotal()
        frmSummary$setIncomes(totIncomes)
        frmSummary$setExpenses(totExpenses)
     }
     ,getSummary  = function (target) { frmSummary$getReactable (target) }
     ,getIncomes  = function (target) { frmIncomes$getReactable (target) }
     ,getExpenses = function (target) { frmExpenses$getReactable(target) }
   )
  ,private = list(
      frmSummary   = NULL
     ,frmIncomes   = NULL
     ,frmExpenses  = NULL
     ,objMovements = NULL
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLStatus, session)

   refresh = function () {
      pnl$refreshData()
      output$tblSummary  = renderReactable({ pnl$getSummary(ns("tblSummary")) })
      output$tblIncomes  = renderReactable({ pnl$getIncomes (ns("tblIncomes")) })
      output$tblExpenses = renderReactable({ pnl$getExpenses(ns("tblExpenses")) })
   }
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   
})
}
