modInputInput <- function(id, title) {
    ns <- NS(id)
   types = c("Real" = 1,"Previsto" = 2,"Provision" = 3)
    
#    main = tagList(tags$div(style="margin: auto"
#   main = fluidRow(column(2)
   main = fluidRow(
       column(1)
      ,column(3 # , h3("Datos 1")
       ,tags$table(id=ns("tblInput"), style="float: left"
        ,tags$tr( tags$td()
                 ,tags$td(switchInput( inputId=ns("swType"), onLabel = "Gasto", offLabel = "Ingreso"
                                      ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)))
        ,tags$tr(tags$td("Fecha"),     tags$td(guiDateInput( ns("dtInput"))))
        ,tags$tr(tags$td("Grupo"),     tags$td(guiCombo(ns("cboGroups"),     NULL, c("Group"   = 0))))
        ,tags$tr(tags$td("Categoria"), tags$td(guiCombo(ns("cboCategories"), NULL, c("Category"= 0))))
        ,tags$tr(tags$td("Medio"),     tags$td(guiCombo(ns("cboMethods"),    NULL, c("Method"  = 0))))
        ,tags$tr(tags$td("Tipo"),      tags$td(guiCombo(ns("cboType"),       NULL, types, selected=1)))
        ,tags$tr(tags$td("Importe"),   tags$td(guiNumericInput (ns("impExpense"),    NULL, 0)))
        ,tags$tr(tags$td("Nota"),      tags$td(guiTextArea(ns("txtNote"),       NULL, rows=3)))
        ,tags$tr(tags$td("Tags"),      tags$td(guiTextArea(ns("txtTags"),       NULL, rows=3)))
        ,tags$tr(tags$td(colspan="2",  textOutput(ns("txtMessage"))))
        ,tags$tr( tags$td()
                 ,tags$td( guiButton(ns("btnOK"),  label="Insertar",    type="success")
                          ,guiButton(ns("btnKO"),  label="Limpiar",     type="danger")
                          ,shinyjs::hidden(guiButton(ns("btnItemize"), label="Desglosar",  type="warning"))))
             )
         
       )
      ,column(1)
      ,column(3, shinyjs::hidden(tags$div(id=ns("divItemize") 
            ,tags$table( id=ns("tblSummarize")
                       ,tags$tr( tags$td(),tags$td(style="visibility: hidden", switchInput( inputId=ns("dummy")
                                                               ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)))
                        ,tags$tr( tags$td("Total"),     tags$td(guiLabelNumber(id=ns("lblTotal"))))
#               ,tags$tr( tags$td("Total"),     tags$td(textOutput(ns("lblTotal"))))
                       ,tags$tr( tags$td("Actual"),    tags$td(guiLabelNumber(id=ns("lblCurrent"))))
                       ,tags$tr( tags$td("Pendiente"), tags$td(guiLabelNumber(id=ns("lblPending"))))
            ) # End table
            ,reactableOutput(ns("tblItems"))
            ,tags$table( id=ns("tblButtons"), style="float: left"
                        ,tags$td( actionBttn(ns("btnProcess"),  label="Procesar", color="success", style="material-flat")
                                 ,actionBttn(ns("btnCancel"),   label="Anular",   color="danger",  style="material-flat"))
             )         
           ) # end div
         ) # End hidden
      ) # End column
      
      # ,column(1)#
      # ,column(3 #, h3("Datos 2")
      #    ,shinyjs::hidden(
      #  tags$table(id=ns("tblItemize")
      #   ,tags$tr( tags$td()
      #            ,tags$td(style="visibility: hidden", switchInput( inputId=ns("swType_item"), onLabel = "Gasto", offLabel = "Ingreso"
      #                                 ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)))
      #   ,tags$tr(style="visibility: hidden",tags$td("Fecha"),     tags$td(style="visibility: hidden", guiDateInput( ns("dtInput_item"))))
      #   ,tags$tr(tags$td("Grupo"),     tags$td(guiCombo(ns("cboGroups_item"),     NULL, c("Group"   = 0))))
      #   ,tags$tr(tags$td("Categoria"), tags$td(guiCombo(ns("cboCategories_item"), NULL, c("Category"= 0))))
      #   ,tags$tr(style="visibility: hidden", tags$td("Medio"),     tags$td(guiCombo(ns("cboMethods_item"),    NULL, c("Method"  = 0))))
      #   ,tags$tr(tags$td("Tipo"),      tags$td(guiCombo(ns("cboType_item"),       NULL, types, selected=1)))
      #   ,tags$tr(tags$td("Importe"),   tags$td(guiNumericInput (ns("impExpense_item"),    NULL, 0)))
      #   ,tags$tr(tags$td("Nota"),      tags$td(guiTextArea(ns("txtNote_item"),       NULL, rows=3)))
      #   ,tags$tr(tags$td("Tags"),      tags$td(guiTextArea(ns("txtTags_item"),       NULL, rows=3)))
      #   ,tags$tr(tags$td(colspan="2",  textOutput(ns("txtMessage_item"))))
      #   ,tags$tr( tags$td()
      #            ,tags$td( actionBttn(ns("btnOK_item"),  label="Insertar",     color="success", style="material-flat")
      #                     ,actionBttn(ns("btnKO_item"),  label="Limpiar",     color="danger",  style="material-flat")
      #                     ,actionBttn(ns("btnDone_item"), label="Hecho",  color="warning", style="material-flat")))
      #        )
      # 
      #   )
      #)
   )
   # main = tagList(fluidRow(
   #    column(1)
   #    ,column(3
   #     ,tags$table(style="float: left"
   #      ,tags$tr( tags$td()
   #               ,tags$td(switchInput( inputId=ns("swType"), onLabel = "Gasto", offLabel = "Ingreso"
   #                                    ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)))
   #      ,tags$tr(tags$td("Fecha"),     tags$td(guiDateInput( ns("dtInput"))))
   #      ,tags$tr(tags$td("Grupo"),     tags$td(guiCombo(ns("cboGroups"),     NULL, c("Group"   = 0))))
   #      ,tags$tr(tags$td("Categoria"), tags$td(guiCombo(ns("cboCategories"), NULL, c("Category"= 0))))
   #      ,tags$tr(tags$td("Medio"),     tags$td(guiCombo(ns("cboMethods"),    NULL, c("Method"  = 0))))
   #      ,tags$tr(tags$td("Tipo"),      tags$td(guiCombo(ns("cboType"),       NULL, types, selected=1)))
   #      ,tags$tr(tags$td("Importe"),   tags$td(guiNumericInput (ns("impExpense"),    NULL, 0)))
   #      ,tags$tr(tags$td("Nota"),      tags$td(guiTextArea(ns("txtNote"),       NULL, rows=3)))
   #      ,tags$tr(tags$td("Tags"),      tags$td(guiTextArea(ns("txtTags"),       NULL, rows=3)))
   #      ,tags$tr(tags$td(colspan="2",  textOutput(ns("txtMessage"))))
   #      ,tags$tr( tags$td()
   #               ,tags$td( actionBttn(ns("btnOK"),  label="Insertar",     color="success", style="material-flat")
   #                        ,actionBttn(ns("btnKO"),  label="Limpiar",     color="danger",  style="material-flat")
   #                        ,shinyjs::hidden(actionBttn(ns("btnItemize"), label="Desglosar",  color="warning", style="material-flat"))))
   #           )
   #      )
   #     ,column(1)
   #     ,column(3
   #     ,tags$table(style="float: left"
   #        ,tags$tr( tags$td()
   #               ,tags$td(switchInput( inputId=ns("swType"), onLabel = "Gasto", offLabel = "Ingreso"
   #                                    ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)))
   #      ,tags$tr(tags$td("Fecha"),     tags$td(guiDateInput( ns("dtInput"))))
   #      ,tags$tr(tags$td("Grupo"),     tags$td(guiCombo(ns("cboGroups"),     NULL, c("Group"   = 0))))
   #      ,tags$tr(tags$td("Categoria"), tags$td(guiCombo(ns("cboCategories"), NULL, c("Category"= 0))))
   #      ,tags$tr(tags$td("Medio"),     tags$td(guiCombo(ns("cboMethods"),    NULL, c("Method"  = 0))))
   #      ,tags$tr(tags$td("Tipo"),      tags$td(guiCombo(ns("cboType"),       NULL, types, selected=1)))
   #      ,tags$tr(tags$td("Importe"),   tags$td(guiNumericInput (ns("impExpense"),    NULL, 0)))
   #      ,tags$tr(tags$td("Nota"),      tags$td(guiTextArea(ns("txtNote"),       NULL, rows=3)))
   #      ,tags$tr(tags$td("Tags"),      tags$td(guiTextArea(ns("txtTags"),       NULL, rows=3)))
   #      ,tags$tr(tags$td(colspan="2",  textOutput(ns("txtMessage"))))
   #      ,tags$tr( tags$td()
   #               ,tags$td( actionBttn(ns("btnOK"),  label="Insertar",     color="success", style="material-flat")
   #                        ,actionBttn(ns("btnKO"),  label="Limpiar",     color="danger",  style="material-flat")
   #                        ,shinyjs::hidden(actionBttn(ns("btnItemize"), label="Desglosar",  color="warning", style="material-flat"))))
   #           )
   # 
   #  )))
    list(left=NULL, main=main, right=NULL)
}   
