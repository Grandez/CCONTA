modTestInput <- function(id, title) {
    ns <- NS(id)
   types = c("Real" = 1,"Previsto" = 2,"Provision" = 3)
    
#    main = tagList(tags$div(style="margin: auto"
#   main = fluidRow(column(2)
   main = fluidRow(h2("test")
      ,reactableOutput(ns("table"))
   )
    list(left=NULL, main=main, right=NULL)
}   
