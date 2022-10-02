modXferInput = function(id, title) {
   ns <- NS(id)
   main = tagList(br()
      ,tags$table(style="margin: auto"
        ,tags$tr(tags$td("Fecha"),    tags$td(guiDateInput(ns("dtInput"))))
        ,tags$tr(tags$td("De"),       tags$td(guiCombo(ns("cboFrom"))))
        ,tags$tr(tags$td("A"),        tags$td(guiCombo(ns("cboTo"))))
        ,tags$tr(tags$td("Importe"),  tags$td(guiNumericInput (ns("impTransfer"),  min=0)))
        ,tags$tr(tags$td("Nota"),     tags$td(textAreaInput(ns("txtNote"),     NULL, rows=3)))
        ,tags$tr(tags$td(colspan="2", textOutput(ns("txtMessage"))))
        ,tags$tr( tags$td()             
                 ,tags$td( actionBttn(ns("btnOK"), label="Transferir", color="success", style="jelly")
                          ,actionBttn(ns("btnKO"), label="Cancelar",  color="danger",  style="jelly")))
             )
    )       

    list(left=NULL, main=main, right=NULL)
}   
