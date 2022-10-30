modConfigInput <- function(id, title) {
    ns <- NS(id)
    main = tagList(
       

awesomeRadio( inputId = "swType",NULL,inline=TRUE,checkbox=TRUE
             ,choices = c(Cuentas="1", Grupos="2"),selected = "1")


         ,reactableOutput(ns("tblSummary"))
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