modBudgetInput = function(id,title) {
    ns <- NS(id)
    left = tagList(
        h5("Periodo"), guiCombo(ns("cboPeriod"), NULL, c("Año"=0, months_as_combo()))
       ,checkboxGroupInput( ns("chkCategories"), "Tipo de movimiento:"
                           ,choiceNames  = list("Fijos", "Variables", "Aperiodicos")
                           ,choiceValues = list(10,20,30)
                           ,selected=c(10,20,30) )
   )    
    main = ui_status(id)
    list(left=left, main=main, right=NULL)
}