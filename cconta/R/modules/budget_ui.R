modBudgetInput = function(id,title) {
    ns <- NS(id)
    left = tagList(
        h5("Periodo"), guiCombo(ns("cboPeriod"), NULL, c("Año"=0, months_as_combo()))
       # ,checkboxGroupInput(ns("chkCategory"), "Categoria:", c("Fijos"=1, "Variables"=2), selected=c(1,2))
       # ,checkboxGroupInput(ns("chkTipo"),     "Tipo:",      c("Real"= 1, "Previsto" =2), selected=c(1,2))
       # ,switchInput(inputId=ns("swAcum"), "Acumulado", value=FALSE)
       # ,guiNumericInput (ns("impBudget"),    NULL, 0)
       # ,guiButton(ns("btnOK"),  label="Insertar",    type="success")
       # ,guiButton(ns("btnKO"),  label="Limpiar",     type="danger")       
   )    
    main = ui_status(id)
    list(left=left, main=main, right=NULL)
}