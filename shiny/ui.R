
tagList(shinyjs::useShinyjs()
,tags$head(tags$style('.navbar-nav {width: 95%;}
                                    .navbar-nav :last-child{float:right}'))
   
# ,navbarPage("Navbar!", id="mainMenu"
#   ,tabStatusUI("Situacion",   "status")
#   ,tabBudgetUI("Presupuesto", "budget")
#   ,tabDetailUI("Detalle",     "detail")
#   ,tabInputUI("Entrada",      "input")   
#   # ,tabPanel("Hoja2")
#   # ,tabPanel("Hoja3")
#                       
# )   
#  )

,JGGDashboard( title = "Conta", id = "mainMenu", theme = bslib::bs_theme(bootswatch = "default")
                 ,paths    = NULL,    cssFiles = NULL
                 ,jsFiles  = NULL, jsInit   = NULL
                 ,titleActive = FALSE,  lang     = "es"
   ,JGGTab(id="status", "Situacion",   NULL, JGGUI("status"))
   ,JGGTab(id="budget", "Presupuesto", NULL, JGGUI("budget"))
   ,JGGTab(id="detail", "Detalle",     NULL, JGGUI("detail"))   
   ,JGGTab(id="input",  "Entrada",     NULL, JGGUI("input"))   
))