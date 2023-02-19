mod_config_server <- function(id, session) {
ns = NS(id)
PNLConfig = R6::R6Class("CONTA.PNL.CONFIG"
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
     ,getGroups     = function (type = c("all", "expenses", "incomes")) { 
         type = match.arg(type)
         if (type == "expenses") return (tblGroups$table(expense = 1))
         if (type == "incomes")  return (tblGroups$table(income = 1))
         tblGroups$table()
     }     
     ,getCategories = function (idGroup) {
        dfCategories[dfCategories$idGroup == idGroup,]
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
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLConfig, NULL, session)
   
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
      dfg = pnl$getGroups("expenses")
      dfg$edit = 0
#       browser()

cols = list(
   id=colDef(show=FALSE)
   ,name=colDef(name="Nombre")
   ,descr=colDef(name="Descripcion")
   ,income = colDef(name="Ingreso", cell = function(value){
      if (value == 0) shiny::icon("times", style = "color: red")
      else            shiny::icon("check", style = "color: green")
   })
   ,expense = colDef(name="Gasto", cell = function(value){
      if (value == 0) shiny::icon("times", style = "color: red")
      else            shiny::icon("check", style = "color: green")
   })
   ,edit = colDef(name="", cell=function(value) {if (value==0) shiny::icon("pencil", style = "color: blue")})

)      
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
onClick = jscode(ns("tblGroups"))
output$tblGroups = renderReactable(reactable(dfg, columns=cols, pagination = FALSE, onClick=onClick,
rowStyle = function(index) {
    if (dfg[index, "active"] == 0) {
      list(background = "lightGrey", fontStyle = "italic")
    }
  }   
   ))
#output$tblCategories = renderReactable(obj)
}

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
   # observeEvent(input$swType, {
   #    browser()
   # })
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
   

   # flags = reactiveValues(
   #       type    = FALSE
   # ) 
   # 
   # validate  = function() {
   #    # dfInput se supone que siempre tiene valor
   #    if (as.integer(input$cboMethods) == 0) {
   #       output$txtMessage = renderText({"Invalid Method"})
   #       return (TRUE)
   #    }
   #    if (as.integer(input$cboGroups) == 0) {
   #       output$txtMessage = renderText({"Invalid Group"})
   #       return (TRUE)
   #    }
   #    if (as.integer(input$cboCategories) == 0) {
   #       output$txtMessage = renderText({"Invalid Category"})
   #       return (TRUE)
   #    }
   #    if (input$impExpense <= 0) {
   #       output$txtMessage = renderText({"Invalid amount"})
   #       return (TRUE)
   #    }
   #    FALSE
   # }
   # clearForm = function() {
   #    updateNumericInput (session, "impExpense", value=0)
   #    updateTextAreaInput(session, "txtNote", value="")
   #    updateTextAreaInput(session, "txtTags", value="")
   # }
   # 
   # # Flags event
   # observeEvent(flags$type, ignoreInit = TRUE, {
   #    df = pnl$getMethods()
   #    updateSelectInput(session, "cboMethods", choices = WEB$makeCombo(df))
   #    df = pnl$getGroups()
   #    updateSelectInput(session, "cboGroups", choices = WEB$makeCombo(df))
   # })
   # observeEvent(input$swType,        {
   #    pnl$expense = input$swType
   #    flags$type  = isolate(!flags$type)
   # })
   # observeEvent(input$cboGroups,     {
   #    if (input$cboGroups == 0) return()
   #    group = as.integer(input$cboGroups)
   #    pnl$set(group = group)
   #    df = pnl$getCategories(group)
   #    updateSelectInput(session, "cboCategories", choices = WEB$makeCombo(df))
   # })
   # observeEvent(input$cboMethods,    { pnl$set(method   = as.integer(input$cboMethods))    })
   # observeEvent(input$cboCategories, { pnl$set(category = as.integer(input$cboCategories)) })
   # observeEvent(input$dtInput,       { pnl$set(date     = input$dtInput)                   })
   # 
   # observeEvent(input$btnOK, {
   #    txtType = ifelse(pnl$expense, "Gasto", "Ingreso")
   #    if (validate()) return()
   #    
   #    output$txtMessage = renderText({""})
   # 
   #    id = pnl$add( date     = input$dtInput
   #                 ,idMethod   = as.integer(input$cboMethods),    idGroup = as.integer(input$cboGroups)
   #                 ,idCategory = as.integer(input$cboCategories), amount = input$impExpense
   #                 ,note     = input$txtNote,                   tags   = input$txtTags, type = 1)
   #    if (id > 0) {
   #       clearForm()
   #       output$txtMessage = renderText({paste(txtType, "introducido con id ", id)})
   #    }
   # })
   # observeEvent(input$btnKO, { clearForm() })

})
}
