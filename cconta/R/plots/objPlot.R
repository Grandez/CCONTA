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
         applyLabs(p, colnames(data[ncol(data)]))
      }
      ,stackedBar = function (data) {
         df = transform(data)
         dfl = reshape2::melt(df, value.name = "Importe")
         dfl$Periodo = as.integer(dfl$Periodo)
         p = ggplot(dfl,aes(Periodo,Importe,fill=variable)) +
             geom_bar(stat="identity")
         applyLabs(p, colnames(data[ncol(data)]))      
      }
      
   )
   ,private = list(
      transform = function (data) {
         df = t(data[, 3:ncol(data)])
         colnames(df) = data[,2]
         df = as.data.frame(df)
         cbind(Periodo=row.names(df), df)
      }
      ,applyLabs = function (p, last) {
         p = p + theme_classic() + theme(legend.position = "none")
         p = p + labs(x=NULL, y=NULL)
         p = p + scale_x_continuous(breaks=seq(1,as.integer(last),1))
         #p = p + theme(axis.text.x=element_text(hjust=0.5))
         ggplotly(p)   
      }
   )
)
