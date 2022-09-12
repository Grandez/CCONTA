tabBudgetUI <- function(label, id) {
    ns <- NS(id)
    
    tabPanel(label, value=id, reactableOutput(ns("tblBudget"))
    )
}