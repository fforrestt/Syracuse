library(sqldf)
library(ggplot2)
library(randomForest)






d1=read.csv("C:/Users/Case&Fo/Desktop/student-por.csv",header=TRUE)


d1$address <- tolower(d1$address)
d1$sex <- tolower(d1$sex)
d1$school <- tolower(d1$school)
d1$famsize <- tolower(d1$famsize)
d1$Pstatus <- tolower(d1$Pstatus)
d1$total <- d1$G1 + d1$G2 + d1$G3
View(d1$total)


failing <- sqldf('select * from d1 where G1 <= 10 and G2 <= 10 and G3 <= 10')


passing <- sqldf('select * from d1 where G1 >= 10 and G2 >= 10 and G3 >= 10')
studentsPassing <- passing[,-c(31,32,33)]
studentsFailing <- failing[,-c(31,32,33)]
dataNoGs <- d1[,-c(31,32,33)]

p3rf <- randomForest(total ~ ., importance = TRUE, data = d1)
p3rf
varImpPlot(p3rf)


p3rf2 <- randomForest(total ~ ., importance = TRUE, data = dataNoGs)
p3rf2
varImpPlot(p3rf2)



fffrf <- randomForest(total ~., data = studentsFailing, importance = TRUE, ntree = 500)
fffrf
varImpPlot(fffrf)


mean(studentsFailing$age)
mean(studentsPassing$age)
mean(d1$age)


ppprf <- randomForest(total ~., data = studentsPassing, importance = TRUE, ntree = 500)
ppprf
varImpPlot(ppprf)











