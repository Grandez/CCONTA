modStatusInput <- function(id, title) {
    ns <- NS(id)
    main = tagList(
         reactableOutput(ns("tblSummary"))
        ,reactableOutput(ns("tblIncomes"))
        ,reactableOutput(ns("tblExpenses"))
       
    )
    # tabPanel(label, value=id
    #     ,reactableOutput(ns("tblSummary"))
    #     ,reactableOutput(ns("tblIncomes"))
    #     ,reactableOutput(ns("tblExpenses"))
    # )
    list(left=NULL, main=main, right=NULL)
}