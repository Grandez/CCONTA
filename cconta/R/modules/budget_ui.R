modBudgetInput = function(id,title) {
   ns <- NS(id)
   main = ui_status(id)
   left = tagList(
        h4("Grupo"),     guiCombo        (ns("cboGroups"),     NULL, c("Group"   = 0))
       ,h4("Categoria"), guiCombo        (ns("cboCat"),       NULL, c("Categoria"   = 0))
       ,h4("Fecha"),     guiDateInput    (ns("dtInput"))      
       ,h4("Importe"),   guiNumericInput (ns("impExpense"),    NULL, 0)
       ,h4("Puntual"),   switchInput( inputId=ns("swType"), onLabel = "Unico", offLabel = "Agrupado"
                                      ,onStatus = "danger", offStatus = "success", size="large", value=TRUE)
       ,h4("Periodo"),   guiNumericInput (ns("numPeriod"),    NULL, 0)
      
       ,guiButton(ns("btnOK"),  label="Insertar",    type="success")
       ,guiButton(ns("btnKO"),  label="Limpiar",     type="danger")       
   )
   list(left=left, main=main, right=NULL)
}