modDetailInput <- function (id, title) {
    ns <- NS(id)
    main = tagList(#box(solidHeader = TRUE, title = "Filtros", collapsible = TRUE)
         shinyjs::hidden(tags$div(id=ns("nodata")
            ,tags$img(src="img/warning00.png"), h2("No hay datos")
         ))
         ,tags$div(id=ns("data")   
              ,guiBox(ns("boxPlot"), "Grafico")
             ,reactableOutput(ns("tblDetail"))
         )
       )
    left = tagList(awesomeRadio( inputId = ns("radType"), label = "Tipo", inline = TRUE 
                                ,choices = c("Todo"=0, "Gastos"=1, "Ingresos"=-1),selected = "0")
         ,selectizeInput  (ns("cboGroups"),     "Grupos", c("Group"   = 0))
         ,selectizeInput  (ns("cboCategories"), "Categorias", c("Category"= 0))
         ,selectizeInput  (ns("cboMethods"),    NULL, c("Method"  = 0))             
         ,dateRangeInput( ns("dtRange"), "Intervalo"
                         ,min   = paste(year(Sys.Date()), "01", "01", sep="-")
                         ,max   = paste(year(Sys.Date()), "12", "31", sep="-")
                         ,start = paste(year(Sys.Date()), month(Sys.Date()), "01", sep="-")
                         ,format    = "dd/mm/yyyy",startview = "month", weekstart = 1
                         ,language  = "es", separator = " to ",width = NULL,autoclose = TRUE)
         ,selectInput  (ns("cboType"),       NULL, c("Type"    = 0))     
         ,textInput    (ns("txtTags"),       NULL)
  #            numericRangeInput(
  # inputId,
  # label,
  # value,
  # width = NULL,
  # separator = " to ",
  # min = NA,
  # max = NA,
  # step = NA
  #)
       )
   list(left=left, main=main, right=NULL)    
}
