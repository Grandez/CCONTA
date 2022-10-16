modPositionInput <- function(id, title) {
   ns <- NS(id)

   main = tagList(reactableOutput(ns("tblPosition"))
   )
   list(left=NULL, main=main, right=NULL)
}   
