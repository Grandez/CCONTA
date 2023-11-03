
tagList(shinyjs::useShinyjs()
,tags$head(tags$style('.navbar-nav {width: 95%;}
                                    .navbar-nav :last-child{float:right}'))
   
,JGGDashboard( title = "Conta", id = "mainMenu", theme = bslib::bs_theme(bootswatch = "default")
                 ,paths    = NULL,    cssFiles = NULL
                 ,jsFiles  = NULL, jsInit   = NULL
                 ,titleActive = FALSE,  lang     = "es"

   ,JGGTab(id="status",     "Situacion",      NULL, JGGUI("status"))         
   ,JGGTab(id="budget",     "Presupuesto",    NULL, JGGUI("budget"))      
# ,JGGTab(id="test",     "Test",        NULL, JGGUI("test") )     
   ,JGGTab(id="input",    "Entrada",        NULL, JGGUI("input") )

   # ,JGGTab(id="position",   "Posicion",       NULL, JGGUI("position"))
   
   # ,JGGTab(id="expected",   "Prevision",      NULL, JGGUI("expected"))   
   # ,JGGTab(id="detail",     "Detalle",        NULL, JGGUI("detail"))
   # 
    ,JGGTab(id="xfer",     "Transferencias", NULL, JGGUI("xfer"))
   ,JGGTab(id="export",     "Exportar", NULL, JGGUI("export"))
    ,JGGTab(id="config",   "Configuracion",  NULL, JGGUI("config"))
#   ,JGGTab(id="config",   "Configuracion",  NULL, JGGUI("config"))

   # ,navbarMenu("Entrada"
   #  ,JGGTab(id="income",    "Ingresos",        NULL, JGGUI("input") ) #tabPanel("Ingresos"),
   #  ,JGGTab(id="expense",   "Gastos",        NULL, JGGUI("input") ) #tabPanel("Gastos")
   # )


)
)