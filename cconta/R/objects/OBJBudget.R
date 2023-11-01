OBJBudget = R6::R6Class("CONTA.OBJ.BUDGET"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       initialize = function(factory, ...) {
          super$initialize(factory, TRUE)
          args = JGGTools::args2list(...)
          if (!is.null(args$year)) private$year = args$year
          
          private$tblBudget     = factory$getTable("Budget")
          loadBudget()
       }
      ,loadBudget = function () {
         private$dfBudget = tblBudget$table(year = self$year)
         invisible(self)
      }
      ,getBudget = function () {
         private$dfBudget
      }      
      ,getBudgetByPeriod = function (month, reload=TRUE) {
         if (reload) loadBudget()
         df = dfBudget
         if (month == 0) {
            df = dfBudget[, c("idGroup", "idCategory", "month", "expense", "00")]
            colnames(df) = c("idGroup", "idCategory", "period", "expense", "amount")
         } else {
            df = dfBudget[dfBudget$month == month,]
            df = df[,3:(ncol(df))]
            df = within(df, rm("00", "sync"))
         }   
         # if (missing(expense)) return (df)
         # df %>% dplyr::filter(expense == expense)
         df
      }
      ,update = function (item, period, expense) {
          private$period = period
          private$expense = expense
          if (period == 0)
             updateMonths(item)
          else
             updateDays(item)
       }   

      # ,refresh   = function() {
      #    # Se debe llamar cuando han cambiado grupos o categorias
      #    df = tblBudget$table(year = self$year, active = 1)
      #    private$dfBudget = df[,c("idGroup", "idCategory", "month", "amount")]
      #    private$dfTypes  = objGrid$getDataBase()[,c("idGroup", "idCategory", "income", "expense")]
      #    browser()
      # }
      ,getExpenses   = function() {
         df = dplyr::inner_join(dfBudget, dfTypes, by=c("idGroup", "idCategory"))
         df = df[df$expense == 1,] # dfBudget %>% filter(grpExpense == 1 & catExpense == 1)
         objGrid$getGrid(df[,1:4])
      }
      ,getIncomes   = function() {
         df = dplyr::inner_join(dfBudget, dfTypes, by=c("idGroup", "idCategory"))
         df = df[df$income == 1,] # df = dfBudget %>% filter(grpIncome == 1 & catIncome == 1)
         objGrid$getGrid(df[,1:4])
       }
      ,getExpensesTotal  = function() { totals(getExpenses()) }
      ,getIncomesTotal   = function() { totals(getIncomes())  }
      ,setCategories     = function(categories) {
         objGrid$setCategories(categories)
         invisible(self)
      }
      ,setBudget     = function(data) {
         tryCatch({
            tblBudget$db$begin()
            for (month in data$from:data$to) {
               tblBudget$select(group=data$group, category=data$category, year=data$year, month=month, create=TRUE)
               tblBudget$set(amount=data$amount)
               tblBudget$apply()
            }
            tblBudget$db$commit()
         },error = function (cond) {
            browser()
            tblBudget$db$rollback()
         })
         
      }
   )
   ,private = list(
       tblBudget     = NULL
      ,tblGroups     = NULL
      ,tblCategories = NULL
      ,dfBase        = NULL
      ,dfTypes       = NULL
      ,dfBudget      = NULL
      ,expense       = TRUE
      ,period        = 0
      ,year          = lubridate::year(Sys.Date())
#      ,objGrid       = NULL
      ,loadBase      = function () {
        # Cogemos los grupos activos
        dfg = tblGroups$table(active = 1)
        dfg = dfg[,c("id", "name", "income", "expense")]
        colnames(dfg) = c("idGroup", "Group", "groupIncome", "groupExpense")
        # Cogemos las categorias activas
        dfc = tblCategories$table(active = 1)
        dfc = dfc[,c("idGroup", "id", "name", "income", "expense")]
        colnames(dfc) = c("idGroup", "idCategory", "Category", "catIncome", "catExpense")
        
        private$dfBase = inner_join(dfc, dfg)
      }
      ,updateMonths = function (item) {
         rc = tryCatch({
            tblBudget$db$begin()
            lapply(as.integer(item$col):12, updMonth, item)
            tblBudget$db$commit()
            FALSE
         }, error = function (e) {
            tblBudget$db$rollback()
            TRUE
         })
      }
      ,updateDays = function (item) {
         # Se actualiza desde ese dia hasta el final de agno
         # Si no hay presupuesto para el mes completo, se le pone la suma
         rc = tryCatch({
            tblBudget$db$begin()
            updDay(period, item$col, item)  # Mes actual
            if (period < 12) lapply((period + 1):12, updDay, 1, item) # Resto meses
            tblBudget$db$commit()
            FALSE
         }, error = function (e) {
            tblBudget$db$rollback()
            TRUE
         })
       }
      ,updMonth = function (month, item) {
         tblBudget$select( year    = private$year, month = month
                          ,idGroup = item$idGroup, idCategory=item$idCategory
                          ,expense = ifelse (expense, -1, 0), create=TRUE )
         tblBudget$set('00' = item$amount)
         tblBudget$apply()
      }
      ,updDay = function (period, day, item) {
         day = as.integer(day)
         tblBudget$select( year    = private$year, month = period
                          ,idGroup = item$idGroup, idCategory=item$idCategory
                          ,expense = ifelse (expense, -1, 0), create=TRUE )
         
         days = (31 - day + 1)
         cols = sprintf("%02d", day:31)
         data = as.list(rep(item$amount, days))
         names(data) = cols
         tblBudget$set(data)
         
         total = item$amount * (31 - day + 1)
         if (tblBudget$current$'00' == 0) tblBudget$set('00' = total) 
         tblBudget$apply()
      }
      
   #   ,loadBudget = function () {
   #      # Creamos un df clave/mes/0 (donde clave va de 1 a 12)
   #      dft = data.frame(month=seq(1,12), amount=0)
   # 
   #      # Ahora hacemos un full join por amount (que es la clave)
   #      #Y tenemos group/category/mes/0
   #      df2 = dfBase[,c("idGroup", "idCategory")]
   #      df2$amount = 0
   #      dfZeroes = full_join(df2,dft, by="amount", multiple="all")
   # 
   #      #Cogemos el presupuesto en funcion del agno
   #      dfb = tblBudget$table(year = self$year, active = 1)
   #      dfb = dfb[,c("idGroup", "idCategory", "month", "amount")]
   #      
   #      # los juntamos y los sumamos. 
   #      # Ahora tenemos por cada grupo/categoria 12 registros
   #      
   #      df = rbind(dfZeroes, dfb)
   #      df = df %>% dplyr::group_by(idGroup, idCategory, month) %>% 
   #                  dplyr::summarise(amount = sum(amount), .groups="keep")
   #      
   #      #Ahora le hacemos spread
   #      df = tidyr::spread(df, month, amount)
   #      private$dfBudget = dplyr::inner_join(dfBase, df,by=c("idGroup", "idCategory"))
   #   }
   # ,totals = function (df) {
   #       colSums(df[,5:16]) # Cogemos solo los valores numericos
   #  }
  )
)

