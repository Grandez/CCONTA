mod_config_server <- function(id, session) {
ns = NS(id)
PNLConfig = R6::R6Class("CONTA.PNL.CONFIG"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = PNLBase
  ,public     = list(
      initialize    = function(id, parent, session) {
         super$initialize(id, session, TRUE) 
         self$vars$inactives = TRUE
         self$vars$type      = "all"
         private$objGroups     = factory$getObject("Groups")
         self$refresh()
      }
     ,refresh = function() {
        private$dfGroups     = objGroups$getAllGroups()
     }
     ,getGroups     = function () { 
         self$data$dfGroups = applyFilters (dfGroups)
         self$data$dfGroups
      }     
     ,getCategories = function (row) { 
        self$data$dfCategories = objGroups$getCategories(self$data$dfGroups[row, "id"])
        self$data$dfCategories
     }
     ,getGroup = function (id) {
        as.list(private$dfGroups[private$dfGroups$id == id,])
     }
     ,getIdGroup = function (row) { self$data$dfGroups[row,"id"] }
     
     ,updateGroup = function () {
        data = self$vars$data
        if (data$edit) {
           id = objGroups$updateGroup(data)
        } else {
           id = objGroups$addGroup(data)
        }
        id
     }
     ,updateCategory = function () {
        data = self$vars$data
        if (data$edit) {
           id = objGroups$updateCategory(data)
        } else {
           id = objGroups$addCategory(data)
        }
        id
     }
     ,checkName = function (data) {
        if (data$group) {
           df = objGroups$getGroupByName(data$name)
           if (nrow(df) > 0) return (TRUE)
        }
        FALSE
     }
   )
  ,private = list(
      tblGroups     = NULL
     ,tblCategories = NULL
     ,objGroups     = NULL
     ,dfGroups      = NULL
     ,dfCategories  = NULL
     ,applyFilters  = function (dfIn) {
         df = dfIn
#         if (!self$vars$inactives) df = dfIn[dfIn$active == 1,]
         if (self$vars$type == "expenses") return (df[df$expense == 1,])
         if (self$vars$type == "incomes")  return (df[df$income == 1,])
         df
     }
   )
)

moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id, PNLConfig, NULL, session)
   jscode = function(idTable) {
     if (is.null(idTable)) return (NULL)
     data = paste("{ row: rowInfo.index + 1, col: colInfo.index + 1, colName: colInfo.id")
     data = paste(data, ",detail: JSON.stringify(rowInfo.row)}")
     evt = paste0("Shiny.setInputValue('", idTable, "',", data, ",{ priority: 'event' });")

     js_code = "function(rowInfo, colInfo) {"
     js_code = paste(js_code, evt, sep="\n")
     js_code = paste(js_code, "}", sep="\n")
     htmlwidgets::JS(js_code)
   }

   validateForm = function (data) {
      if (nchar(trimws(data$name)) == 0)         return ("Nombre no puede estar vacio")
      if (data$income == 0 && data$expense == 0) return ("Se debe indicar si acepta gastos y/o ingresos")
      if (data$since >= data$until)              return ("Fechas de validez incorrectas o ilogicas") 
      if (data$edit && data$name != data$oldName) {
         if (pnl$checkName(data))     return ("El nombre ya existe")  
      } 
      if (!data$edit && pnl$checkName(data))     return ("El nombre ya existe")     

      NULL
   }
   renderTable = function(category, df, uiTable) {
      df$edit = 0
      cols = list(
         id=colDef(show=FALSE)
        ,sync=colDef(show=FALSE)
        ,since = colDef (show = FALSE)
        ,until = colDef (show = FALSE)    
        ,lower = colDef (show = FALSE)       
        ,name=colDef(name="Nombre")
        ,desc=colDef(name="Descripcion")
        ,income = colDef( name="Ingreso", width = 75, align = "center"
                         ,cell = function(value) {
                             if (value == 0) shiny::icon("times", style = "color: red")
                             else            shiny::icon("check", style = "color: green")
                         })
        ,expense = colDef( name="Gasto", width = 75, align = "center"
                          ,cell = function(value) {
                              if (value == 0) shiny::icon("times", style = "color: red")
                              else            shiny::icon("check", style = "color: green")
                           })
        ,edit = colDef( name = "", width = 50 # name=shiny::icon("plus", style = "color: blue")
                       ,cell=function(value) {
                             if (value==0) shiny::icon("pencil", style = "color: blue")
                        })
     )
     parms = list(data=df, columns = cols
                                    ,pagination = FALSE, wrap = FALSE
                                    ,highlight = TRUE
                                    ,striped = TRUE
                                    ,onClick=jscode(uiTable))

     if (category) {
         cols$idGroup = colDef(show = FALSE)   
     } else {
         rowSel = NULL
         if (!is.null(pnl$vars$rowGroup)) rowSel = pnl$vars$rowGroup
         parms$selection = "single"
         parms$defaultSelected = rowSel
     }
     
     do.call("reactable", parms)
   }
   renderGroups = function (uiTable) {
      obj = renderTable(FALSE, pnl$getGroups(), uiTable)
      output$tblGroups = reactable::renderReactable(obj)      
   }
   renderCategories = function (uiTable, row) {
      obj = renderTable(TRUE, pnl$getCategories(row), uiTable)
      output$tblCategories = reactable::renderReactable(obj)      
   }
   formItem = function(data, message = NULL) {
      chkIncome  = ifelse(data$income  == 0, FALSE, TRUE)
      chkExpense = ifelse(data$expense == 0, FALSE, TRUE)
      title = ifelse(data$edit, "Modificacion de ", "Nuevo ")
      title = paste(title, ifelse(data$group, "grupo", "categoria"))

      modalDialog(
         tags$table(
             tags$tr( tags$td(strong("Nombre"))
                     ,tags$td(textInput(ns("frmTxtName"),label=NULL,value=data$name)))
            ,tags$tr( tags$td(strong("Descripcion"))
                     ,tags$td(textInput(ns("frmTxtDesc"),label=NULL,value=data$desc)))
            ,tags$tr( tags$td(strong("Desde"))
                     ,tags$td(guiDateInput(ns("frmCboFrom"), value=data$since)))
            ,tags$tr( tags$td(strong("Hasta"))
                     ,tags$td(guiDateInput(ns("frmCboTo"), value=data$until)))
            ,tags$tr( tags$td(strong("Ingresos"))
                     ,tags$td(guiCheckbox(ns("frmChkIncome"),  value = chkIncome, color="success")))
            ,tags$tr( tags$td(strong("Gastos"))
                     ,tags$td(guiCheckbox(ns("frmChkExpense"), value = chkExpense, color="danger")))
         )
        ,if (!is.null(message)) div(tags$b(message, style = "color: red;"))
        ,title = title
        ,footer = tagList(
                modalButton("Cancel"),
                actionButton(ns("btnFrmOK"), "OK")
             )
        ,easyClose = TRUE   
         )
   }  
   formAdd = function(group) {   
      if (!group) pnl$vars$data$idGroup = pnl$getIdGroup(pnl$vars$rowGroup)
      pnl$vars$data$group = group
      pnl$vars$data$edit  = FALSE
      pnl$vars$data$since = Sys.Date()
      pnl$vars$data$until = as.Date("2999/12/31")
      pnl$vars$data$income  = 0
      pnl$vars$data$expense = 1
      showModal(formItem(pnl$vars$data))
   }
      
   refresh = function(changedGroup) {
      if (missing(changedGroup)) {
         changedGroup = TRUE
      } else {
         pnl$refresh()
      }
         
      if (changedGroup) {
         renderGroups(ns("tblGroups"))
      } else {
         renderCategories(ns("tblCategories"), pnl$vars$rowGroup)
      }
   }   
   flags = reactiveValues(
       type    = FALSE
      ,itemize = FALSE
   ) 

   observeEvent(input$btnAddGroup,    { formAdd(TRUE)  })
   observeEvent(input$btnAddCategory, { formAdd(FALSE) })
   observeEvent(input$tblGroups, {
      if (input$tblGroups$colName != "edit") return()
      pnl$vars$row = jsonlite::fromJSON(input$tblGroups$detail)
      pnl$vars$data = pnl$getGroup(pnl$vars$row$id)
      pnl$vars$data$oldName = pnl$vars$data$name
      pnl$vars$data$idGroup = pnl$vars$data$id
      pnl$vars$data$edit = TRUE
      pnl$vars$data$group = TRUE
      showModal(formItem(pnl$vars$data))
   })
   observeEvent(input$tblCategories, {
      if (input$tblCategories$colName != "edit") return()
      pnl$vars$data = jsonlite::fromJSON(input$tblCategories$detail)
      pnl$vars$data$oldName = pnl$vars$data$name
      pnl$vars$data$idCAtegory = pnl$vars$data$id
      pnl$vars$data$edit = TRUE
      pnl$vars$data$group = FALSE
      pnl$vars$data$idGroup = pnl$getIdGroup(pnl$vars$rowGroup)
      showModal(formItem(pnl$vars$data))
   })   
   observeEvent(input$tblGroups__reactable__selected, {
      row = getReactableState("tblGroups", "selected")
      if (is.null(row)) return()
      shinyjs::enable("btnAddCategory")
      pnl$vars$rowGroup = row
      renderCategories(ns("tblCategories"), row)
   })

   observeEvent(input$btnFrmOK, {
      pnl$vars$data$name    = input$frmTxtName
      pnl$vars$data$desc    = input$frmTxtDesc
      pnl$vars$data$since   = input$frmCboFrom
      pnl$vars$data$until   = input$frmCboTo
      pnl$vars$data$income  = ifelse(input$frmChkIncome,  1, 0)
      pnl$vars$data$expense = ifelse(input$frmChkExpense, 1, 0)
      msg = validateForm(pnl$vars$data)

      if (!is.null(msg)) {
         showModal(formItem(pnl$vars$data, msg))
         return()
      }
      if (pnl$vars$data$group) {
          pnl$updateGroup()   
      } else {
         pnl$updateCategory()   
      }
      refresh(pnl$vars$data$group)
      removeModal()      
   })
   
   if (!pnl$loaded) {
      pnl$loaded = TRUE
      refresh()
   }
})
}
