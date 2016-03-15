library("ggplot2")
library("plyr")
resultados <- read.csv("../csv/resultados_elecciones_todas.csv")
resultados.x.eleccion <- data.frame(eleccion = paste(paste(resultados$Año,resultados$Mes,sep="/"),resultados$Tipo,sep="-"),Partido=resultados$Partido,Tipo=resultados$Tipo,Votos=as.numeric(as.character(resultados$Votos)))

#Calcula totales votos y partidos
votos <- ddply(.data=resultados.x.eleccion,.(eleccion,Tipo), summarise, RESULT=sum(Votos),PARTIDOS=length(Tipo))
votos.x.eleccion <- data.frame(Fecha=votos$eleccion,Tipo=votos$Tipo,votos=votos$RESULT,partidos=votos$PARTIDOS)
ggplot(votos.x.eleccion, aes(x=Fecha,y=votos,color=Tipo,size=partidos))+geom_point()+ theme(axis.text.x = element_text(angle = 90, hjust = 1))
