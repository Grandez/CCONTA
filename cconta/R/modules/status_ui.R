modStatusInput <- function(id, title) {
    ns <- NS(id)
    left = tagList(
        h5("Periodo"), guiCombo(ns("cboPeriod"), NULL, c("Año"=0, months_as_combo()))
       ,checkboxGroupInput( ns("chkCategories"), "Categoria de movimientos:"
                           ,choiceNames  = list("Fijos", "Variables", "Aperiodicos")
                           ,choiceValues = list(10,20,30)
                           ,selected=c(10,20,30) )

       ,checkboxGroupInput(ns("chkType"),  "Tipo:",c("Real"= 1, "Previsto" = 2), selected=c(1,2))
       ,prettyRadioButtons(ns("radBudget"), "Vista:", choices = c("Realizado" = 0, "Contra presupuesto" = 1))
       ,switchInput(ns("swAccum"), "Acumulado", value=FALSE)
       ,guiNumericInput (ns("impBudget"),    NULL, 0)
       ,guiButton(ns("btnOK"),  label="Insertar",    type="success")
       ,guiButton(ns("btnKO"),  label="Limpiar",     type="danger")
   )    
    main = ui_status(id)
    list(left=left, main=main, right=NULL)
}