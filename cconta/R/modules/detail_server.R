mod_detail_server <- function(id, session) {
ns = NS(id)
PNLDetail = R6::R6Class("CONTA.PNL.DETAIL"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase 
  ,public = list(
      data = NULL
     ,initialize     = function (id, parent, session) {
          super$initialize(id, session, TRUE)
          private$objMov     = factory$getObject("Movements")
          private$objGroups  = factory$getObject("Groups")
          private$objMethods = factory$getObject("Methods")
          private$objTable  = factory$getObject("TableDetail")
          self$data$filter = list(source = 0, group = 0, category = 0, method = 0
                                            , minAmount = 0, maxAmount = 0)
     }
     ,setSource     = function (value) {
        private$reload = TRUE
        self$data$filter$source = as.integer(value)
        invisible (self)
     }
     ,setFilter     = function (key, value)       {
        self$data$filter[[key]] = value
        invisible(self)
     }
     ,getSource     = function() { self$data$filter$source }     
     ,getData       = function () {
        if (reload) reloadData()
        df = dfBase
        if (nrow(df) == 0) return (df)
        df =  applyFilters()
        if (nrow(df) == 0) return (df)
        df
        # filters = names(filter2)
        # idx = 0
        # while (idx < length(filter2)) {
        #    if (filters[idx + 1] == "date") {
        #       df = df[df$date >= filter2[[idx + 1]][1] & df$date <= filter2[[idx + 1]][2],]
        #       if (nrow(df) == 0) return(df)
        #    }
        #    idx = idx + 1
        # }
        # self$data = df
        # df
     }
     ,getFilter     = function (filterName) { self$data$filter[[filerName]] }
     ,getGroups     = function ()   { 
         df = objGroups$getGroups() 
         if (getSource() == 1) df = df[df$expense != 0,]
         if (getSource() == 2) df = df[df$income  != 0,]
         df
      }
     ,getCategories = function (group = 0)  { 
         df = objGroups$getCategories()
         if (group == 0)   return (objGroups$getCategories())
         objGroups$getCategoriesByGroup(group)
      }
     ,getMethods    = function ()           { objMethods$getMethods    ()       }
     ,refreshData = function() {
#        if (reload) reloadData()
        # objMovements
        # frmExpenses$set(objMovements$getExpenses())
        # frmIncomes$set (objMovements$getIncomes ())
        # totExpenses = frmExpenses$getTotal()
        # totIncomes  = frmIncomes$getTotal()
        # frmSummary$setIncomes(totIncomes)
        # frmSummary$setExpenses(totExpenses)
     }
     # ,getSummary  = function (target) { frmSummary$getReactable (target) }
     # ,getIncomes  = function (target) { frmIncomes$getReactable (target) }
     # ,getExpenses = function (target) { frmExpenses$getReactable(target) }
   )
  ,private = list(
      objMov     = NULL
     ,objGroups  = NULL
     ,objMethods = NULL
     ,objTable   = NULL
     ,dfBase     = NULL
     ,reload     = TRUE
     
     ,reloadData = function () {
        type = self$data$filter$source
        dfExpenses = NULL
        dfIncomes = NULL
        if (type == 0 || type == 1) dfExpenses = objMov$getExpenses()
        if (type == 0 || type == 2) dfIncomes  = objMov$getIncomes()
        private$dfBase = rbind(dfExpenses, dfIncomes)
        private$reload = FALSE
     }
     ,applyFilters = function () {
        filter = self$data$filter
        df = dfBase
        if (filter$group     != 0) df = df %>% filter (idGroup    == filter$group)
        if (filter$category  != 0) df = df %>% filter (idCategory == filter$category)
        if (filter$method    != 0) df = df %>% filter (idMethod   == filter$category)
        if (filter$minAmount != 0) df = df %>% filter (amount     >= filter$minAmount)
        if (filter$maxAmount != 0) df = df %>% filter (amount     <= filter$minAmount)
        df
     }
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLDetail, NULL, session)

   loadFilters = function () {
       loadGroups()
       loadCategories() 
       cbo = WEB$makeCombo(pnl$getMethods(),"Todos" = 0)
       updCombo("cboMethods",choices = cbo,selected = "0")

   }
   showData = function (nrows) {
      DATA = TRUE
      if (nrows == 0) {
          shinyjs::show("nodata")
          shinyjs::hide("data")
          DATA = FALSE
      } else {
          shinyjs::show("data")
          shinyjs::hide("nodata")
      }
      DATA
   }
   refresh = function () {
      browser()
      pnl$data$refreshing = TRUE
      df = pnl$getData()
      if (!showData(nrow(df))) return
      minAmount = ceiling(min(df$amount))
      maxAmount = floor(max(df$amount) + 1)
      updateSliderInput(inputId="sldAmount", value=c(min(df$amount), max(df$amount)), min=minAmount, max=maxAmount)
      output$tblDetail  = updTable({ df })
      pnl$loaded = TRUE
   }
   
   loadGroups = function () {
      cbo = WEB$makeCombo(pnl$getGroups(),"Todos" = 0)
      updCombo("cboGroups",choices = cbo,selected = "0")
   }
   loadCategories = function () {
      cbo = WEB$makeCombo(pnl$getCategories(),"Todas" = 0)
      updCombo("cboCategories",choices = cbo,selected = "0")
   }
   observeEvent(input$radType, ignoreInit = TRUE,   { 
      pnl$setSource(input$radType)
      loadGroups() 
      refresh()
   })
   observeEvent(input$cboGroups, ignoreInit = TRUE,   { 
      pnl$setFilter("group", as.integer(input$cboGroups))
      loadCategories() 
      # refresh() Se refresca en categoria
   })
   observeEvent(input$cboCategories, ignoreInit = TRUE,   { 
      pnl$setFilter("category", as.integer(input$cboCategories))
      refresh()
   })
   observeEvent(input$cboMethods, ignoreInit = TRUE,   { 
      pnl$setFilter("method", as.integer(input$cboMethods))
      refresh()
   })
   observeEvent(input$sldAmount, ignoreInit = TRUE,   { 
      pnl$setFilter("minAmount", as.numeric(input$sldAmount[1]))
      pnl$setFilter("maxAmount", as.numeric(input$sldAmount[2]))

      if (!pnl$data$refreshing) refresh()
      pnl$data$refreshing = FALSE
   })

   observeEvent(input$dtRange, ignoreInit = TRUE,   { 
      pnl$setFilter(date=input$dtRange)
      refresh()
   })
   observeEvent(input$tblDetail, {
      browser()
      shinyjs::show("form_container")
      output$form = renderUI({movementUI(paste0(id, "_form"), insert = FALSE) })
      #output$form = renderUI({tagList(h1("Titulo 1"), h2("Titulo 2")) })
         #movementUI(paste0(id, "_form"), insert = FALSE) })
#       showModal(modalDialog(movementUI(id, insert = FALSE),
#   title = NULL,
#   footer = modalButton("Dismiss"),
#   size = "xl",
#   easyClose = TRUE,
#   fade = TRUE
# ))
   })

   if (!pnl$loaded) {
       loadFilters()
       refresh()
   }
   
   
})
}
