modStatusInput <- function(id, title) {
    ns <- NS(id)
    main = ui_status(id)
    # main = tagList(
    #      guiBox(ns("boxSummary"),  "Situacion", reactableOutput(ns("tblSummary")))
    #     ,guiBox(ns("boxIngresos"), "Ingresos",  reactableOutput(ns("tblIncomes")))
    #     ,guiBox(ns("boxGstos"),    "Gastos",    reactableOutput(ns("tblExpenses")))
    #    
    # )
    # tabPanel(label, value=id
    #     ,reactableOutput(ns("tblSummary"))
    #     ,reactableOutput(ns("tblIncomes"))
    #     ,reactableOutput(ns("tblExpenses"))
    # )
    list(left=NULL, main=main, right=NULL)
}