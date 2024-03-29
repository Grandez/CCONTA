modDetailInput <- function (id, title) {
    ns <- NS(id)
    main = tagList(#box(solidHeader = TRUE, title = "Filtros", collapsible = TRUE)
         shinyjs::hidden(tags$div(id=ns("nodata")
            ,tags$img(src="img/warning00.png"), h2("No hay datos")
         ))
         ,tags$div(id=ns("data")   
             ,guiBox(ns("boxPlot"),    "Plot",      plotlyOutput(ns("pltDetail")))
             ,guiBox(ns("boxDetail"),  "Situacion", guiTable(ns("tblDetail")))
         )
       )
    
    left = tagList(awesomeRadio( inputId = ns("radType"), label = "Tipo", inline = TRUE 
                                ,choices = c("Todo"=0, "Gastos"=1, "Ingresos"=2),selected = "0")
         ,guiCombo  (ns("cboGroups"),     "Grupos",     c("Group"   = 0))
         ,guiCombo  (ns("cboCategories"), "Categorias", c("Category"= 0))
         ,guiCombo  (ns("cboMethods"),    "Metodo",     c("Method"  = 0))
         ,guiCombo  (ns("cboTypes"),      "Tipo movimiento",     c("Tipo"  = 0))             
         ,sliderInput(ns("slDate"),    "Periodo", min = as.Date(paste0(year(Sys.Date()), "/01/01"))
                                                , max = as.Date(paste0(year(Sys.Date()), "/12/31"))
                                                ,value = c( as.Date(paste0(year(Sys.Date()), "/01/01"))
                                                           ,as.Date(paste0(year(Sys.Date()), "/12/31"))))
         ,sliderInput(ns("sldAmount"), "Importe",  min = 1, max = 1000, value = c(200,500)),
    )
   list(left=left, main=main, right=NULL)    
}
