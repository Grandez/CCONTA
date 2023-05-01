modConfigInput <- function(id, title) {
    ns <- NS(id)
    left = tagList(
        guiCombo(ns("cboType"),choices=c("Todos"="all","Gastos"="expenses","Ingresos"="incomes"))
       ,guiSwitchLabel(ns("swActive"),"Inactivos")
    )
    main = tagList(
       fluidRow( column(1)
                ,column(4, actionButton(ns("btnAddGroup"), "Nuevo grupo"), h3("Grupos")
                         , guiTable(ns("tblGroups")))
                ,column(1)
                ,column(4, shinyjs::disabled(actionButton(ns("btnAddCategory"), "Nueva categoria")), h3("Categorias")
                         ,guiTable(ns("tblCategories")))
               )
    )
    list(left=left, main=main, right=NULL)
}