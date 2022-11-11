mod_status_server = function(id, session) {
ns = NS(id)
PNLStatus = R6::R6Class("CONTA.PNL.STATUS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase 
  ,public = list(
      byDateValue = TRUE     
     ,initialize  = function (id, parent, session) {
         super$initialize(id, session, TRUE)
         private$frmSummary   = factory$getObject("FrameSummary",  force = TRUE)
         private$frmIncomes   = factory$getObject("FrameIncomes",  force = TRUE)
         private$frmExpenses  = factory$getObject("FrameExpenses", force = TRUE)
         private$objMovements = factory$getObject("Movements")
      }
     ,refreshData = function() {
        data = objMovements$getExpenses()
        frmExpenses$set(data, dateValue = byDateValue)
        #frmExpenses$set(objMovements$getExpenses(), dateValue = byDateValue)
        data = objMovements$getIncomes ()
        frmIncomes$set (data, dateValue = byDateValue)
        #frmIncomes$set (objMovements$getIncomes (), dateValue = byDateValue)
        totExpenses = frmExpenses$getTotal()
        totIncomes  = frmIncomes$getTotal()
        frmSummary$setIncomes(totIncomes)
        frmSummary$setExpenses(totExpenses)
     }
     ,getTableSummary  = function (target) { frmSummary$getReactable (target) }
     ,getTableIncomes  = function (target) { frmIncomes$getReactable (target) }
     ,getTableExpenses = function (target) { frmExpenses$getReactable(target) }
     ,getDataSummary   = function ()       { frmSummary$getData ()            }     
   )
  ,private = list(
      frmSummary   = NULL
     ,frmIncomes   = NULL
     ,frmExpenses  = NULL
     ,objMovements = NULL
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLStatus, NULL, session)

   makePlot = function() {
      df = pnl$getDataSummary()
      df = df[df$idGroup > 0,]
      df = df[,-c(1,2)]
      dfi =  gather(df[df$Concepto == "Ingresos",], "Mes", "Concepto")
      dfg =  gather(df[df$Concepto == "Gastos",],   "Mes", "Concepto")
      colnames(dfi) = c("Mes", "Ingresos")
      colnames(dfg) = c("Mes", "Gastos")
      df2 = full_join(dfi, dfg, by="Mes")
      
      df2$Mes = as.integer(df2$Mes)
      fig = plot_ly(df2, x=~Mes, y=~Gastos, type="bar")
      #fig %>% add_trace(x=~Mes, y=~Ingresos, type="bar")
      fig      
   }
   refresh = function () {
      pnl$refreshData()
      output$tblSummary  = renderReactable({ pnl$getTableSummary(ns("tblSummary"))   })
      output$tblIncomes  = renderReactable({ pnl$getTableIncomes (ns("tblIncomes"))  })
      output$tblExpenses = renderReactable({ pnl$getTableExpenses(ns("tblExpenses")) })
      output$plot        = renderPlotly   ({ makePlot()                         })
   }
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   
})
}
