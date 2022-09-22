modDetailInput <- function (id, title) {
    ns <- NS(id)
    main = tagList(box(solidHeader = TRUE, title = "Filtros", collapsible = TRUE)
         ,reactableOutput(ns("tblDetail"))
       )
    left = tagList(awesomeRadio( inputId = ns("radType"), label = "Tipo", inline = TRUE 
                                    ,choices = c("Todo"=0, "Gastos"=2, "Ingresos"=1),selected = "0")
         ,dateRangeInput( ns("dtRange"), "Intervalo"
                         ,min = paste(year(Sys.Date()), "01", "01", sep="-")
                         ,max = paste(year(Sys.Date()), "12", "31", sep="-")
                         ,format    = "dd/mm/yyyy",startview = "month", weekstart = 1
                         ,language  = "es", separator = " to ",width = NULL,autoclose = TRUE)
         ,selectInput  (ns("cboGroups"),     NULL, c("Group"   = 0))
         ,selectInput  (ns("cboCategories"), NULL, c("Category"= 0))
         ,selectInput  (ns("cboMethods"),    NULL, c("Method"  = 0))             
         ,selectInput  (ns("cboType"),       NULL, c("Type"    = 0))     
         ,textInput    (ns("txtTags"),       NULL)
             
       )
   list(left=left, main=main, right=NULL)    
}
