tabStatusUI <- function(label, id) {
    ns <- NS(id)
    tabPanel(label, value=id
        ,reactableOutput(ns("tblSummary"))
        ,reactableOutput(ns("tblIncomes"))
        ,reactableOutput(ns("tblExpenses"))
    )
}