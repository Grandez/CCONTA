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
      ,getGroupsAtYear = function (year) {
         # Devuelve los grupos que estan o han estado activos en ese agno
         if (missing(year)) year = lubridate::year(Sys.Date())
         df = loadGroups()
         df %>% dplyr::filter(lubridate::year(since) <= year & lubridate::year(until) >= year)
      }
      ,getGroupsByType = function (type, date) {
         df = getGroups(date)
         if (type == CTES$TYPE$Expenses) df = df[df$expense == 1,]
         if (type == CTES$TYPE$Incomes)  df = df[df$income  == 1,]
         df
      }
      ,getAllGroups  = function () {
         loadGroups()
      }
      ,getCategories = function (group, date) {
         # Devuelve las categorias activas a esa fecha o dia del sistema del grupo
         if (missing(date)) date = Sys.Date()
         df = loadCategories()
         df %>% dplyr::filter(idGroup == group & since <= date & until >= date)
      }
      ,getCategoriesByType = function (idGroup, type, date) {
         df = getCategories(idGroup, date)
         if (type == CTES$TYPE$Expenses) df = df[df$expense == 1,]
         if (type == CTES$TYPE$Incomes)  df = df[df$income  == 1,]
         df
      }
      ,getCategoriesAtYear = function (idGroup, year) {
         # Devuelve las categorias activas a esa fecha o dia del sistema del grupo
         if (missing(year)) year = lubridate::year(Sys.Date())
         df = loadCategories()
         df %>% dplyr::filter(idGroup == idGroup & 
                              lubridate::year(since) <= year & 
                              lubridate::year(until) >= year)
      }
      
   )
   ,private = list(
       tblGroups     = NULL
      ,tblCategories = NULL
      ,dfGroups      = NULL
      ,dfCategories  = NULL
      ,loadGroups      = function () { 
          if (is.null(dfGroups)) private$dfGroups     = tblGroups$table()     
          private$dfGroups
       }
      ,loadCategories  = function () { 
         if (is.null(dfCategories)) private$dfCategories = tblCategories$table() 
         private$dfCategories
       }
   )
)
