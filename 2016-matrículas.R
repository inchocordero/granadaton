library(ggplot2)

datos <- read.csv('2016-campus-infantil.csv')
ggplot(data=datos)+geom_line( aes(x=Año,y=Chicos,col='Chicos'))+ geom_line( aes(x=Año,y=Chicas,col='Chicas'))
