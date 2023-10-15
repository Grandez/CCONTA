mod_export_server <- function(id, session) {
ns = NS(id)
PNLExport = R6::R6Class("CONTA.PNL.EXPORT"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,public     = list(
      initialize    = function(id, parent, session) {
         super$initialize(id, session, TRUE) 
         private$objExcel = factory$getObject("Excel")
         # self$vars$inactives = TRUE
         # self$vars$type      = "all"
         # private$objGroups     = factory$getObject("Groups")
         # self$refresh()
      }
     ,generateExcel = function(period = 0) {
        objExcel$period = 2023
        OBJExcel$month = period
        objExcel$generate()
     }
   )
  ,private = list(
     objExcel = NULL
     ,xlsFile = "c:/TEMP/conta.xlsx"
#       tblGroups     = NULL
#      ,tblCategories = NULL
#      ,objGroups     = NULL
#      ,dfGroups      = NULL
#      ,dfCategories  = NULL
#      ,applyFilters  = function (dfIn) {
#          df = dfIn
# #         if (!self$vars$inactives) df = dfIn[dfIn$active == 1,]
#          if (self$vars$type == "expenses") return (df[df$expense == 1,])
#          if (self$vars$type == "incomes")  return (df[df$income == 1,])
#          df
#      }
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLExport, NULL, session)
   observeEvent(input$btnOK, {
      pnl$generateExcel(as.integer(input$cboPeriod))
   })
})
}