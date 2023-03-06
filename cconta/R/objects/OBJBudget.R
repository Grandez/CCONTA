OBJBudget = R6::R6Class("CONTA.OBJ.BUDGET"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,inherit    = OBJBase
   ,public = list(
       year = lubridate::year(Sys.Date())
      ,initialize = function(factory) {
         super$initialize(factory, TRUE)
         private$tblBudget     = factory$getTable("Budget")
         private$tblGroups     = factory$getTable("Groups")
         private$tblCategories = factory$getTable("Categories")
         refresh()
      }
      ,refresh   = function() {
         # Se debe llamar cuando han cambiado grupos o categorias
         loadBase()
         loadBudget()
      }
      ,getExpenses   = function() {
         df = dfBudget %>% filter(groupExpense == 1 & catExpense == 1)
         removeColumns(df)
      }
      ,getIncomes   = function() {
         df = dfBudget %>% filter(groupIncome == 1 & catIncome == 1)
         removeColumns(df)
      }
      
      # ,getBudget     = function() {
      #    df = loadBudgetBase()
      #    dfb = loadBudget()
      #    mountBudget(df, dfb)
      # }
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
      ,dfBudget      = NULL
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
     ,loadBudget = function () {
        # Creamos un df clave/mes/0 (donde clave va de 1 a 12)
        dft = data.frame(month=seq(1,12), amount=0)

        # Ahora hacemos un full join por amount (que es la clave)
        #Y tenemos group/category/mes/0
        df2 = dfBase[,c("idGroup", "idCategory")]
        df2$amount = 0
        dfZeroes = full_join(df2,dft, by="amount", multiple="all")

        #Cogemos el presupuesto en funcion del agno
        dfb = tblBudget$table(year = self$year, active = 1)
        dfb = dfb[,c("idGroup", "idCategory", "month", "amount")]
        
        # los juntamos y los sumamos. 
        # Ahora tenemos por cada grupo/categoria 12 registros
        
        df = rbind(dfZeroes, dfb)
        df = df %>% dplyr::group_by(idGroup, idCategory, month) %>% 
                    dplyr::summarise(amount = sum(amount), .groups="keep")
        
        #Ahora le hacemos spread
        df = tidyr::spread(df, month, amount)
        private$dfBudget = dplyr::inner_join(dfBase, df,by=c("idGroup", "idCategory"))
     }
    ,removeColumns = function (df) {
         df[,c("catIncome", "catExpense")] = NULL
         df[,c("groupIncome", "groupExpense")] = NULL
         df
    }   
     # ,mountBudget = function (df, dfb) {
     #    for (row in 1:nrow(df)) {
     #       if (df[row, "idCategory"] == 0) next
     #       data = dfb[dfb$category == df[row, "idCategory"],]
     #       if(nrow(data) == 0) next
     #       # Los meses empiezan en la columna 5
     #       start = data[1,"month"]
     #       repeat {
     #          df[row, start + 4] = data[1, "amount"]
     #          inc = ifelse (data[1, "frequency"] == 0, 12, data[1, "frequency"])
     #          start = start + inc
     #          if (start > 12) break
     #       }
     #    }
     #    df
     # }
   )
)

