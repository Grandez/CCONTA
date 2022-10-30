ui_status = function(id) {
   ns <- NS(id)
   tagList(
      guiBox(ns("boxPlot"),     "Plot",      plotlyOutput(ns("plot")))
     ,guiBox(ns("boxSummary"),  "Situacion", guiTable(ns("tblSummary")))
     ,guiBox(ns("boxIngresos"), "Ingresos",  guiTable(ns("tblIncomes")))
     ,guiBox(ns("boxGstos"),    "Gastos",    guiTable(ns("tblExpenses")))
   )
}
