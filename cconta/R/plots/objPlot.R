OBJPlot = R6::R6Class("JGG.OBJ.PLOT"
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = FALSE
   ,public = list(
       factory    = NULL
      ,initialize = function(factory, child=FALSE) {
      }
      ,groupedBar = function (data) {
         df = transform(data)
         dfl = reshape2::melt(df, value.name = "Importe")
         dfl$Periodo = as.integer(dfl$Periodo)
         p = ggplot(dfl,aes(Periodo,Importe,fill=variable)) +
             geom_bar(stat="identity",position="dodge")
         p = p + theme_classic() + theme(legend.position = "none")
         p = p + labs(x=NULL, y=NULL)
         ggplotly(p)   
      }
      ,stackedBar = function (data) {
         df = transform(data)
         dfl = reshape2::melt(df, value.name = "Importe")
         dfl$Periodo = as.integer(dfl$Periodo)
         p = ggplot(dfl,aes(Periodo,Importe,fill=variable)) +
             geom_bar(stat="identity")
         p = p + theme_classic() + theme(legend.position = "none")
         p = p + labs(x=NULL, y=NULL)
         ggplotly(p)   
      }
      
   )
   ,private = list(
      transform = function (data) {
         df = t(data[, 3:ncol(data)])
         colnames(df) = data[,2]
         df = as.data.frame(df)
         cbind(Periodo=row.names(df), df)
      }
   )
)
