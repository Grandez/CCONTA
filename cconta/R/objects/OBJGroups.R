# Clase de manejo de Grupos y Categorias
OBJGroups = R6::R6Class("JGG.OBJ.GROUPS"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
      initialize = function(factory) {
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
      }
      ,getGroups = function (date) {
         # Devuelve los grupos activos a esa fecha o dia del sistema
         if (missing(date)) date = Sys.Date()
         df = loadGroups()
         df %>% dplyr::filter(since <= date & until >= date)
      }
      ,getGroupsByPeriod = function (year, month) {
         # Devuelve los grupos que estan o han estado activos en ese agno
         if (missing(year))  year  = lubridate::year(Sys.Date())
         if (missing(month)) month = 0
         df = loadGroups()
         df = df %>% dplyr::filter(lubridate::year(since) <= year & lubridate::year(until) >= year)
         if (month > 0) { 
            df = df %>% dplyr::filter(lubridate::month(since) <= month & 
                                      lubridate::month(until) >= month)
         }
         df
      }
      ,getGroupsByType = function (type, date) {
         df = getGroups(date)
         if (type == CTES$TYPE$Expenses) df = df[df$expense == 1,]
         if (type == CTES$TYPE$Incomes)  df = df[df$income  == 1,]
         df
      }
      ,getGroupByName = function (name) { 
         dfGroups[dfGroups$lower == tolower(name),]
      }
      ,getAllGroups  = function () {
         loadGroups()
      }
      ,getCategories = function (date) {
         # Devuelve las categorias activas a esa fecha o dia del sistema del grupo
         if (missing(date)) date = Sys.Date()
         loadCategories()
      }
      ,getCategoriesByGroup = function (group, date) {
         # Devuelve las categorias activas a esa fecha o dia del sistema del grupo
         if (missing(date)) date = Sys.Date()
         df = loadCategories()
         df %>% dplyr::filter(idGroup == group & since <= date & until >= date)
      }
      ,getCategoriesByType = function (idGroup, type, date) {
         df = getCategoriesByGroup(idGroup, date)
         if (type == CTES$TYPE$Expenses) df = df[df$expense != 0,]
         if (type == CTES$TYPE$Incomes)  df = df[df$income  != 0,]
         df
      }
      ,getCategoriesByPeriod = function (year, month) {
         # Devuelve las categorias activas a esa fecha o dia del sistema del grupo
         if (missing(year)) year = lubridate::year(Sys.Date())
         if (missing(month)) month = 0         
         df = loadCategories()
         df = df %>% dplyr::filter(lubridate::year(since) <= year & 
                                   lubridate::year(until) >= year)

         if (month > 0) { 
            df = df %>% dplyr::filter(lubridate::month(since) <= month & 
                                      lubridate::month(until) >= month)
         }
         df
      }
      ,getCategory = function (group, idcat) {
         loadCategories()
         as.list(dfCategories %>% filter(idGroup == group & id == idcat))
      }
      ,addGroup = function(...) {
         data = JGGTools::args2list(...)
         data$id = getNextId()
         tblGroups$add(data, isolated=TRUE)
         data$id
      }
      ,updateGroup = function(...) {
         data = JGGTools::args2list(...)
         tblGroups$select(id=data$id)
         data$sync = 0
         tblGroups$set(data)
         tblGroups$apply(isolated = TRUE)
         data$id
      }
      ,addCategory = function(...) {
         data = JGGTools::args2list(...)
         data$id = getNextId(data$idGroup)
         tblCategories$add(data, isolated=TRUE)
         data$id
      }
      ,updateCategory = function(...) {
         data = JGGTools::args2list(...)
         tblCategories$select(idGroup = data$idGroup, id=data$id)
         data$sync = 0
         tblCategories$set(data)
         tblCategories$apply(isolated = TRUE)
         data$id
      }
   )
   ,private = list(
       tblGroups     = NULL
      ,tblCategories = NULL
      ,dfGroups      = NULL
      ,dfCategories  = NULL
      ,loadGroups      = function () { 
          if (!is.null(dfGroups)) return (dfGroups)
          private$dfGroups       = tblGroups$table()     
          private$dfGroups$lower = tolower(private$dfGroups$name)
          private$dfGroups
       }
      ,loadCategories  = function () { 
         if (!is.null(dfCategories)) return (dfCategories)
         private$dfCategories = tblCategories$table() 
         private$dfCategories$lower = tolower(private$dfCategories$name)
         private$dfCategories
      }
     ,getNextId = function (idGroup) {
        if (missing(idGroup)) {
           id = tblGroups$max("id")
        } else {
           id = tblCategories$max("id", idGroup = idGroup)
        }   
        id + 1
     }      
   )
)
