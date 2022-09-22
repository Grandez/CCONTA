modBudgetInput = function(id,title) {
   ns <- NS(id)
   main = tagList(reactableOutput(ns("tblBudget")))
   list(left=NULL, main=main, right=NULL)    
}