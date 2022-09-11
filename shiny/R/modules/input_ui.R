tabInputUI <- function(label, id) {
    ns <- NS(id)
    
    tabPanel(label, value=id
       ,switchInput( inputId=ns("swIncome"), onLabel = "Ingreso", offLabel = "Gasto"
                    ,onStatus = "success", offStatus = "danger")
       ,shinyjs::hidden(div(id=ns("div_income"), h1("Panel de ingresos")))
       ,shinyjs::hidden(div(id=ns("div_expense"), 
          tags$table(
             tags$tr(tags$td("Fecha"), tags$td(dateInput(ns("dtInput"), NULL, format = "dd/mm/yyyy", startview = "month", weekstart = 1,
  language = "es")))
             ,tags$tr(tags$td("Cuenta"),     tags$td(selectInput  (ns("cboMethods"),    NULL, c("Method"  = -1))))
             ,tags$tr(tags$td("Grupo"),      tags$td(selectInput  (ns("cboGroups"),     NULL, c("Group"   = -1))))
             ,tags$tr(tags$td("Categoria"),  tags$td(selectInput  (ns("cboCategories"), NULL, c("Category"= -1))))
             ,tags$tr(tags$td("Importe"),    tags$td(numericInput (ns("impExpense"),    NULL, 0)))
             ,tags$tr(tags$td("Nota"),       tags$td(textAreaInput(ns("txtNote"),       NULL, rows=3)))
             ,tags$tr(tags$td("Tags"),       tags$td(textAreaInput(ns("txtTags"),       NULL, rows=3)))
             ,tags$tr(tags$td(colspan="2",   "mensaje"))
             ,tags$tr(tags$td(colspan="2",   actionBttn(ns("btnOK"), label="Procesar", color="success")
                                         ,   actionBttn(ns("btnKO"), label="Cancelar", color="danger")))
             )
        
    ))
    )
}