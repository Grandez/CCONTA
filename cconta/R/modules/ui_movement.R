ui_movement = function(id, insert = TRUE) {
   ns = NS(id)
   lblOK = ifelse(insert, "Insertar", "Actualizar")
   lblKO = ifelse(insert, "Limpiar", "Cancelar")
   types = c("Real" = 1,"Previsto" = 2,"Provision" = 3)
   tagList(tags$table(style="margin: auto"
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
                 ,tags$td( actionBttn(ns("btnOK"),  label=lblOK,     color="success", style="jelly")
                          ,actionBttn(ns("btnKO"),  label=lblKO,     color="danger",  style="jelly")
                          ,shinyjs::hidden(actionBttn(ns("btnItemize"), label="Desglosar",  color="warning", style="jelly"))))
             )
       
    )       
}