
tagList(shinyjs::useShinyjs()
,tags$head(tags$style('.navbar-nav {width: 95%;}
                                    .navbar-nav :last-child{float:right}'))
   
,navbarPage("Navbar!", id="mainMenu"
  ,tabStatusUI("Situacion",   "status")
  ,tabBudgetUI("Presupuesto", "budget")
  ,tabInputUI("Entrada",      "input")   
  # ,tabPanel("Hoja2")
  # ,tabPanel("Hoja3")
                      
)   
 )
