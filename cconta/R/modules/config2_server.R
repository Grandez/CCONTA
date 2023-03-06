mod_config2_server <- function(id, session) {
ns = NS(id)
PNLConfig2 = R6::R6Class("CONTA.PNL.CONFIG"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,active = list(
      expense = function(value) {
         if (missing(value)) return (.expense)
         private$.expense = value
         obj$set(type = ifelse(value, 1, -1))
         invisible(self)
      }
   )  
  ,public     = list(
      initialize    = function(id, parent, session) {
         super$initialize(id, session, TRUE) 
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         self$vars$inactives = TRUE
         self$vars$type      = "all"
         self$refresh()
      #   private$frmExpenses  = factory$getObject("FrameExpenses", force = TRUE)         
        #  private$obj = factory$getObject("Movements")

        #           private$objMovements = factory$getObject("Movements")
        #                         data = objMovements$getExpenses()
        # frmExpenses$set(data, dateValue = byDateValue)

      }
     ,refresh = function() {
        private$dfGroups     = tblGroups$table()
        private$dfCategories = tblCategories$table()
     }
     ,getGroups     = function () { 
         applyFilters(dfGroups)     
      }     
     ,getCategories = function (idGroup) { 
         applyFilters (dfCategories[dfCategories$idGroup == idGroup,])
      }
     # ,getTableExpenses = function (target) { 
     #    browser()
     #    frmExpenses$getReactable(target) }     
     # ,getExpenses   = function () {
     #    browser()
     #    dfg = obj$getGroups("expenses")
     #    dfg
     # }

     # ,getCategories = function (group = 0) { obj$getCategories (group)                   }
     # ,getMethods    = function ()          { obj$getMethods    ()                        }
     # ,add           = function (...)       { obj$add(...)                                }
     # ,set           = function ( ... ) {
     #    obj$set(...)
     #    invisible(self)
     # }
     # ,add        = function(...) { obj$add(...)    }
     # ,loadBudget = function ()   { obj$getBudget() }
   )
  ,private = list(
      tblGroups     = NULL
     ,tblCategories = NULL
     ,dfGroups      = NULL
     ,dfCategories  = NULL
     ,applyFilters  = function (dfIn) {
         df = dfIn
         if (!self$vars$inactives) df = dfIn[dfIn$active == 1,]
         if (self$vars$type == "expenses") return (df[df$expense == 1,])
         if (self$vars$type == "incomes")  return (df[df$income == 1,])
         df
     }
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLConfig2, NULL, session)
   
   jscode = function(idTable) {
      data = paste("{ row: rowInfo.index + 1, colName: colInfo.id")
      data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
      evt = paste0("Shiny.setInputValue('", idTable, "',", data, ",{ priority: 'event' });")

      js_code = "function(rowInfo, colInfo) {"
      js_code = paste(js_code, evt, sep="\n")
      js_code = paste(js_code, "}", sep="\n")
      htmlwidgets::JS(js_code)
   }
   iconType = function (value) {
      if (value == 0) shiny::icon("times", style = "color: red")
      else            shiny::icon("check", style = "color: green")
   }
   iconEdit = function (value) {
      shiny::icon("pencil", style = "color: blue")
   }
   rowInactive = function (index) {
      if (pnl$data$df[index, "active"] == 0) {
          list(background = "lightGrey", fontStyle = "italic")
      }
   }
   makeReactable = function (df, categories = FALSE) {
#      browser()
      target = ifelse(categories, "tblCategories", "tblGroups")
      onClick = jscode(ns(target))
      df$edit = 0
      outlined = ifelse(categories, TRUE, FALSE)
      subTable = function (index) {
            dfc = pnl$getCategories(df[index, "id"])
            htmltools::div(style = "padding: 1rem", makeReactable(dfc, TRUE)) #reactable(dfc, outlined = TRUE))
      }

      if (categories) subTable = NULL
      
      cols = list(
         id=colDef(show=FALSE)
        ,active=colDef(show=FALSE)
        ,sync=colDef(show=FALSE)
        ,name=colDef(name="Nombre")
        ,descr=colDef(name="Descripcion")
        ,income = colDef(name="Ingreso", cell = function(value) {
                        if (value == 0) shiny::icon("times", style = "color: red")
                        else            shiny::icon("check", style = "color: green")
                       })
        ,expense = colDef(name="Gasto", cell = function(value) {
                          if (value == 0) shiny::icon("times", style = "color: red")
                          else            shiny::icon("check", style = "color: green")
                         })
        ,edit = colDef( name = "+" # name=shiny::icon("plus", style = "color: blue")
                       ,cell=function(value) {
                             if (value==0) shiny::icon("pencil", style = "color: blue")
                        })
     )      
   
     if (categories) cols$idGroup = colDef(show = FALSE)   
     reactable(df, columns=cols, pagination = FALSE, onClick=onClick
                 , rowStyle = function(index) {
                      if (df[index, "active"] == 0) {
                          list(background = "lightGrey", fontStyle = "italic")
                      } 
                 }
                 ,outlined = outlined
                 ,details = subTable
# ,details = function (index) {
#    dfc = pnl$getCategories(dfg[index, "id"])
#      htmltools::div(style = "padding: 1rem",
#     reactable(dfc, outlined = TRUE)
#   )

#}   
   )
      
   }
   updateTableCategories = function (data) {
      info = jsonlite::fromJSON(data)
      pnl$data$df = pnl$getCategories(info$id)
      pnl$data$df$edit = 0
      cols = list( id=colDef(show=FALSE), idGroup=colDef(show = FALSE)
                  ,name=colDef(name="Nombre")
                  ,descr=colDef(name="Descripcion")
                  ,income = colDef(name="Ingreso", cell = function(value) iconType(value))
                  ,expense = colDef(name="Gasto",  cell = function(value) iconType(value))
                  ,edit = colDef(name="", cell=function(value) iconEdit(value))
            )      
     
     obj = reactable( pnl$data$df
                     ,columns=cols
                     ,pagination = FALSE
                     ,onClick=jscode(ns("tblCategories"))
                     ,rowStyle = function(index) rowInactive(index)
     )
     output$tblCategories = renderReactable(obj)
      
   }
   refresh = function () {
#      browser()
      dfg = pnl$getGroups()
#      dfg$edit = 0
#       browser()
# browser()
# cols = list(
#    id=colDef(show=FALSE)
#    ,name=colDef(name="Nombre")
#    ,descr=colDef(name="Descripcion")
#    ,income = colDef(name="Ingreso", cell = function(value){
#       if (value == 0) shiny::icon("times", style = "color: red")
#       else            shiny::icon("check", style = "color: green")
#    })
#    ,expense = colDef(name="Gasto", cell = function(value){
#       if (value == 0) shiny::icon("times", style = "color: red")
#       else            shiny::icon("check", style = "color: green")
#    })
#    ,edit = colDef(name="", cell=function(value) {if (value==0) shiny::icon("pencil", style = "color: blue")})
# 
# )      
# reactable(iris,searchable = TRUE,sortable = TRUE,pagination=FALSE,bordered =TRUE,highlight = TRUE,showSortIcon = TRUE,
#                    columns= list(Petal.Width = colDef(name =  'Petal.Width', align = 'center',
#                 cell = function(value) {
#                   if (value  < 0.2 )  shiny::icon("warning", class = "fas",  
#                     style = "color: orange") else value
#                     }
#                    )))

# 
# obj = reactable(
#   iris[1:5, ],
#   columns = list(
#     Sepal.Length = colDef(name = "Sepal Length"),
#     Sepal.Width = colDef(name = "Sepal Width"),
#     Species = colDef(align = "center")
#   )
# )
#output$table = renderReactable(obj)
#output$tblGroups = renderReactable(reactable(dfg))
#onClick = jscode(ns("tblGroups"))
output$tblGroups = renderReactable(makeReactable(dfg,FALSE))
# output$tblGroups = renderReactable(reactable(dfg, columns=cols, pagination = FALSE, onClick=onClick,
# rowStyle = function(index) {
#     if (dfg[index, "active"] == 0) {
#       list(background = "lightGrey", fontStyle = "italic")
#     }
# }
# ,details = function (index) {
#    dfc = pnl$getCategories(dfg[index, "id"])
#      htmltools::div(style = "padding: 1rem",
#     reactable(dfc, outlined = TRUE)
#   )
# 
# }   
#    ))
# #output$tblCategories = renderReactable(obj)
# }

#       output$tblExpenses  = renderReactable({ reactable::reactable(dfg)   })
#             output$tblExpenses = renderReactable({ pnl$getTableExpenses(ns("tblExpenses")) })
#    } 
      #    ,getReactable = function (idTable) {
      #     cols = lapply(1:12, function(x) colDef(name=monthLong[x], aggregate = "sum"))
      #     names(cols) = as.character(seq(1,12))
      #     cols[["idGroup"]]    = colDef(show = FALSE)
      #     cols[["idCategory"]] = colDef(show = FALSE)
      #     cols[["Group"]]      = colDef(name = "Grupo",     width = 150)
      #     cols[["Category"]]   = colDef(name = "Categoria", width = 200)
      #     if ("row" %in% colnames(dfData)) cols[["row"]] = colDef(show = FALSE)
      #    
      #     reactable(private$dfData, groupBy = "Group", columns = cols) # , onClick = jscode(idTable) )
      # }
}
   flags = reactiveValues(
       type    = FALSE
      ,itemize = FALSE
   ) 

   observeEvent(input$tblGroups, {
      if (input$tblGroups$colName == "edit") {
         return
      }
      updateTableCategories(input$tblGroups$detail)
   })
   
   # Filtros
   observeEvent(input$cboType, {
      pnl$vars$type = input$cboType
      if (pnl$loaded) refresh()
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$swActive, {
      pnl$vars$inactives = input$swActive
      if (pnl$loaded) refresh()
   })
   
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   
})
}
