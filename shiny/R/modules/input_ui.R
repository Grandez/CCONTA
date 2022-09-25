modInputInput <- function(id, title) {
    ns <- NS(id)
    main = movementUI(id, insert = TRUE)
    # main = tagList(tags$table(
    #      tags$tr( tags$td()
    #              ,tags$td(switchInput( inputId=ns("swType"), onLabel = "Gasto", offLabel = "Ingreso"
    #                                   ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)))
    #     ,tags$tr(tags$td("Fecha"), tags$td(dateInput( ns("dtInput"), NULL, format = "dd/mm/yyyy"
    #                                                  ,startview = "month", weekstart = 1, language = "es")))
    #     ,tags$tr(tags$td("Grupo"),      tags$td(selectInput  (ns("cboGroups"),     NULL, c("Group"   = 0))))
    #     ,tags$tr(tags$td("Categoria"),  tags$td(selectInput  (ns("cboCategories"), NULL, c("Category"= 0))))
    #     ,tags$tr(tags$td("Cuenta"),     tags$td(selectInput  (ns("cboMethods"),    NULL, c("Method"  = 0))))             
    #     ,tags$tr(tags$td("Importe"),    tags$td(numericInput (ns("impExpense"),    NULL, 0)))
    #     ,tags$tr(tags$td("Nota"),       tags$td(textAreaInput(ns("txtNote"),       NULL, rows=3)))
    #     ,tags$tr(tags$td("Tags"),       tags$td(textAreaInput(ns("txtTags"),       NULL, rows=3)))
    #     ,tags$tr(tags$td(colspan="2",   textOutput(ns("txtMessage"))))
    #     ,tags$tr( tags$td()             
    #              ,tags$td( actionBttn(ns("btnOK"), label="Insertar", color="success", style="jelly")
    #                       ,actionBttn(ns("btnKO"), label="Limpiar",  color="danger",  style="jelly")))
    #          )
    #    
    # )       
    list(left=NULL, main=main, right=NULL)
}   
   
# tabInputUI <- function(label, id) {
#     ns <- NS(id)
#     
#     tabPanel(label, value=id
#           ,tags$table(
#               tags$tr( tags$td()
#                       ,tags$td(switchInput( inputId=ns("swType"), onLabel = "Gasto", offLabel = "Ingreso"
#                                            ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)))
#              ,tags$tr(tags$td("Fecha"), tags$td(dateInput(ns("dtInput"), NULL, format = "dd/mm/yyyy", startview = "month", weekstart = 1,
#   language = "es")))
#              ,tags$tr(tags$td("Grupo"),      tags$td(selectInput  (ns("cboGroups"),     NULL, c("Group"   = 0))))
#              ,tags$tr(tags$td("Categoria"),  tags$td(selectInput  (ns("cboCategories"), NULL, c("Category"= 0))))
#              ,tags$tr(tags$td("Cuenta"),     tags$td(selectInput  (ns("cboMethods"),    NULL, c("Method"  = 0))))             
#              ,tags$tr(tags$td("Importe"),    tags$td(numericInput (ns("impExpense"),    NULL, 0)))
#              ,tags$tr(tags$td("Nota"),       tags$td(textAreaInput(ns("txtNote"),       NULL, rows=3)))
#              ,tags$tr(tags$td("Tags"),       tags$td(textAreaInput(ns("txtTags"),       NULL, rows=3)))
#              #,tags$tr(tags$td(colspan="2",   ns("txtMessage")))
#              # ,tags$tr(tags$td(colspan="2",   actionBttn(ns("btnOK"), label="Procesar", color="success")
#              #                             ,   actionBttn(ns("btnKO"), label="Cancelar", color="danger")))
# #             )
#         
#     #))
#  #        ,tags$table(
#              ,tags$tr(tags$td(colspan="2",   textOutput(ns("txtMessage"))))
#              ,tags$tr(tags$td(), tags$td( actionBttn(ns("btnOK"), label="Insertar", color="success", style="jelly")
#                                          ,actionBttn(ns("btnKO"), label="Limpiar",  color="danger",  style="jelly")))
#              )
#        
#     )
# }