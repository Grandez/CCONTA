ui_status = function(id) {
   ns <- NS(id)
   tagList(
      guiBox(ns("boxPlot"),     "Plot",      plotlyOutput(ns("plot")))
     ,guiBox(ns("boxSummary"),  "Situacion", reactableOutput(ns("tblSummary")))
     ,guiBox(ns("boxIngresos"), "Ingresos",  reactableOutput(ns("tblIncomes")))
     ,guiBox(ns("boxGstos"),    "Gastos",    reactableOutput(ns("tblExpenses")))
   )
}
