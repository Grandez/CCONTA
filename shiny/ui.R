
tagList(shinyjs::useShinyjs()
,tags$head(tags$style('.navbar-nav {width: 95%;}
                                    .navbar-nav :first-child{float:right}'))
   
,navbarPage("Navbar!", id="mainMenu"
  ,tabInputUI("Entrada", "input")
  ,tabGeneralUI("General", "general")
  ,tabBudgetUI("Presupuesto", "budget")
  # ,tabPanel("Hoja2")
  # ,tabPanel("Hoja3")
                      
)   
 )
