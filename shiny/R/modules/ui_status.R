ui_status = function(id) {
   ns <- NS(id)
   tagList(
      guiBox(ns("boxPlot"),     "Plot",      h3("Aqui va el grafico")) # reactableOutput(ns("tblSummary")))      
     ,guiBox(ns("boxSummary"),  "Situacion", reactableOutput(ns("tblSummary")))
     ,guiBox(ns("boxIngresos"), "Ingresos",  reactableOutput(ns("tblIncomes")))
     ,guiBox(ns("boxGstos"),    "Gastos",    reactableOutput(ns("tblExpenses")))
   )
}
