modExportInput = function(id, title) {
   ns <- NS(id)
   periods = c("Año"  = 0, "Enero"      = 1, "Febrero" =  2, "Marzo"     =  3, "Abril"     =  4
                         , "Mayo"       = 5, "Junio"   =  6, "Julio"     =  7, "Agosto"    =  8
                         , "Septiembre" = 9,"Octubre"  = 10, "Noviembre" = 11, "Diciembre" = 12)
   main = tagList(br()
      ,tags$table(style="margin: auto"
        ,tags$tr(tags$td("Año"),      tags$td(guiNumericInput (ns("numYear"),    NULL, year(Sys.Date()))))
        ,tags$tr(tags$td("Periodo"),  tags$td(guiCombo(ns("cboPeriod"),    NULL, periods)))         
        ,tags$tr(tags$td(colspan="2", textOutput(ns("txtMessage"))))
        ,tags$tr( tags$td()             
                 ,tags$td( actionBttn(ns("btnOK"), label="Generar Excel", color="success", style="jelly")
                          ,actionBttn(ns("btnKO"), label="Cancelar",  color="danger",  style="jelly")))
             )
    )       

    list(left=NULL, main=main, right=NULL)
}   
