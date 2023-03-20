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
         df = tblBudget$table(year = self$year, active = 1)
         private$dfBudget = df[,c("idGroup", "idCategory", "month", "expense", "amount")]
         invisible(self)
      }
      ,getBudget = function () {
         private$dfBudget
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

