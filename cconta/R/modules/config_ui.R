modConfigInput <- function(id, title) {
    ns <- NS(id)
    left = tagList(
        guiCombo(ns("cboType"),choices=c("Todos"=0,"Gastos"=1,"Ingresos"=2))
       ,guiSwitchLabel(ns("swActive"),"Inactivos")
    )
    main = tagList(
       fluidRow( column(1)
                ,column(5,h3("Grupos"),guiTable(ns("tblGroups")))
                ,column(1)
                ,column(5, h3("Categorias"),guiTable(ns("tblCategories")))
               )
    )
    list(left=left, main=main, right=NULL)
}