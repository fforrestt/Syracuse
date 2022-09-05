library(caret)
library(e1071)
library(rpart)
library(rpart.plot)
library(dplyr)
library(stringr)
library(randomForest)
library(tidyverse)
library(sqldf)
library(ggplot2)
library(arules)
library(arulesViz)
options(stringsAsFactors = FALSE)


beer <- read.csv("C:/Users/forrest/Desktop/schoo/IST 707/pROJECT/beer_profile_and_ratings.csv")


#check for NAs
sum(is.na(beer))

#Rename a couple interesting column names
names(beer)[names(beer) == 'ï..Name'] <- 'Name'
names(beer)[names(beer) == 'Beer.Name..Full.'] <- 'Full Name'

#style names from chr to factor
as.factor(beer$Style)
#upon inspecting the variable types, all scores are marked as int or num, there is 
#no need for a factor datatype here. We are only working with beer names and their
#respective scores. 

#create new dataset with beers that are over 100 total reviews
beers2 <- sqldf("select * from beer where number_of_reviews > 100")

#rename styles
beers2$Style[beers2$Style=='IPA - American'] <- "IPA"
beers2$Style[beers2$Style=='IPA - Belgian'] <- "IPA"
beers2$Style[beers2$Style=='IPA - Black / Cascadian Dark Ale'] <- "IPA"
beers2$Style[beers2$Style=='IPA - English'] <- "IPA"
beers2$Style[beers2$Style=='IPA - Imperial'] <- "IPA"
beers2$Style[beers2$Style=='IPA - New England'] <- "IPA"
beers2$Style[beers2$Style=='Barleywine - American'] <- "Barleywine"
beers2$Style[beers2$Style=='Barleywine - English'] <- "Barleywine"
beers2$Style[beers2$Style=='Bitter - English Extra Special / Strong Bitter (ESB)'] <- "Bitter"
beers2$Style[beers2$Style=='Bitter - English'] <- "Bitter"
beers2$Style[beers2$Style=='Blonde Ale - American'] <- "Blonde Ale"
beers2$Style[beers2$Style=='Blonde Ale - Belgian'] <- "Blonde Ale"
beers2$Style[beers2$Style=='Bock - Doppelbock'] <- "Bock"
beers2$Style[beers2$Style=='Bock - Eisbock'] <- "Bock"
beers2$Style[beers2$Style=='Bock - Maibock'] <- "Bock"
beers2$Style[beers2$Style=='Bock - Traditional'] <- "Bock"
beers2$Style[beers2$Style=='Bock - Weizenbock'] <- "Bock"
beers2$Style[beers2$Style=='Brown Ale - American'] <- "Brown Ale"
beers2$Style[beers2$Style=='Brown Ale - Belgian Dark'] <- "Brown Ale"
beers2$Style[beers2$Style=='Brown Ale - English'] <- "Brown Ale"
beers2$Style[beers2$Style=='Farmhouse Ale - BiÃ¨re de Garde'] <- "Farmhouse Ale"
beers2$Style[beers2$Style=='Farmhouse Ale - Sahti'] <- "Farmhouse Ale"
beers2$Style[beers2$Style=='Farmhouse Ale - Saison'] <- "Farmhouse Ale"
beers2$Style[beers2$Style=='KÃ¶lsch'] <- "Kolsch"
beers2$Style[beers2$Style== 'Lager - Adjunct'] <- "Lager"
beers2$Style[beers2$Style=='Lager - American Amber / Red'] <- "Lager"
beers2$Style[beers2$Style=='Lager - American'] <- "Lager"
beers2$Style[beers2$Style=='Lager - European / Dortmunder Export'] <- "Lager"
beers2$Style[beers2$Style=='Lager - European Dark'] <- "Lager"
beers2$Style[beers2$Style=='Lager - European Pale'] <- "Lager"
beers2$Style[beers2$Style=='Lager - European Strong'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Helles'] <- "Lager"
beers2$Style[beers2$Style=='Lager - India Pale Lager (IPL)'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Japanese Rice'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Kellerbier / Zwickelbier'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Light'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Malt Liquor'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Munich Dunkel'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Märzen / Oktoberfest'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Rauchbier'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Schwarzbier'] <- "Lager"
beers2$Style[beers2$Style=='Lager - Vienna'] <- "Lager"
beers2$Style[beers2$Style=='Lambic - Faro'] <- "Lambic"
beers2$Style[beers2$Style=='Lambic - Fruit'] <- "Lambic"
beers2$Style[beers2$Style=='Lambic - Gueuze'] <- "Lambic"
beers2$Style[beers2$Style=='Lambic - Traditional'] <- "Lambic"
beers2$Style[beers2$Style=='Mild Ale - English Dark'] <- "Mild Ale"
beers2$Style[beers2$Style=='Mild Ale - English Pale'] <- "Mild Ale"
beers2$Style[beers2$Style=='Pale Ale - American'] <- "Pale Ale"
beers2$Style[beers2$Style=='Pale Ale - Belgian'] <- "Pale Ale"
beers2$Style[beers2$Style=='Pale Ale - English'] <- "Pale Ale"
beers2$Style[beers2$Style=='Pilsner - Bohemian / Czech'] <- "Pilsner"
beers2$Style[beers2$Style=='Pilsner - German'] <- "Pilsner"
beers2$Style[beers2$Style=='Pilsner - Imperial'] <- "Pilsner"
beers2$Style[beers2$Style=='Porter - American'] <- "Porter"
beers2$Style[beers2$Style=='Porter - Baltic'] <- "Porter"
beers2$Style[beers2$Style=='Porter - English'] <- "Porter"
beers2$Style[beers2$Style=='Porter - Imperial'] <- "Porter"
beers2$Style[beers2$Style=='Porter - Robust'] <- "Porter"
beers2$Style[beers2$Style=='Porter - Smoked'] <- "Porter"
beers2$Style[beers2$Style=='Red Ale - American Amber / Red'] <- "Red Ale"
beers2$Style[beers2$Style=='Red Ale - Imperial'] <- "Red Ale"
beers2$Style[beers2$Style=='Red Ale - Irish'] <- "Red Ale"
beers2$Style[beers2$Style=='Rye Beer - Roggenbier'] <- "Rye Beer"
beers2$Style[beers2$Style=='Sour - Berliner Weisse'] <- "Sour"
beers2$Style[beers2$Style=='Sour - Flanders Oud Bruin'] <- "Sour"
beers2$Style[beers2$Style=='Sour - Flanders Red Ale'] <- "Sour"
beers2$Style[beers2$Style=='Sour - Gose'] <- "Sour"
beers2$Style[beers2$Style=='Stout - American Imperial'] <- "Stout"
beers2$Style[beers2$Style=='Stout - American'] <- "Stout"
beers2$Style[beers2$Style=='Stout - English'] <- "Stout"
beers2$Style[beers2$Style=='Stout - Foreign / Export'] <- "Stout"
beers2$Style[beers2$Style=='Stout - Irish Dry'] <- "Stout"
beers2$Style[beers2$Style=='Stout - Oatmeal'] <- "Stout"
beers2$Style[beers2$Style=='Stout - Russian Imperial'] <- "Stout"
beers2$Style[beers2$Style=='Stout - Sweet / Milk'] <- "Stout"
beers2$Style[beers2$Style=='Strong Ale - American'] <- "Strong Ale"
beers2$Style[beers2$Style=='Strong Ale - Belgian Dark'] <- "Strong Ale"
beers2$Style[beers2$Style=='Strong Ale - Belgian Pale'] <- "Strong Ale"
beers2$Style[beers2$Style=='Strong Ale - English'] <- "Strong Ale"
beers2$Style[beers2$Style=='Wheat Beer - American Dark'] <- "Wheat Beer"
beers2$Style[beers2$Style=='Wheat Beer - American Pale'] <- "Wheat Beer"
beers2$Style[beers2$Style=='Wheat Beer - Dunkelweizen'] <- "Wheat Beer"
beers2$Style[beers2$Style=='Wheat Beer - Hefeweizen'] <- "Wheat Beer"
beers2$Style[beers2$Style=='Wheat Beer - Kristallweizen'] <- "Wheat Beer"
beers2$Style[beers2$Style=='Wheat Beer - Wheatwine'] <- "Wheat Beer"
beers2$Style[beers2$Style=='Wheat Beer - Witbier'] <- "Wheat Beer"

#remove flavor and aroma columns
beers2 <- beers2[,c(1,2,3,6,24,25)]

#create grades for review scores
levels <- c(-Inf, 1.0, 2.0, 3.0, 4.0, Inf)
labels <- c("F", "D", "C", "B", "A")
beers2$grades <- cut(beers2$review_overall, levels, labels)
beers2 <- droplevels(beers2)

#create grades for ABV levels
levels2 <- c(-Inf, 3.0, 6.0, 9.0, 12.0, Inf)
labels2 <- c("Low", "Average", "High", "Very High", "Booze")
beers2$abvGrade <- cut(beers2$ABV, levels2, labels2)

#set as factors
as.factor(beers2$grades)
as.factor(beers2$abvGrade)
beers2

#descriptive stats
summary(beers2$review_overall)

max = which(beers2$review_overall == max(beers2$review_overall), arr.ind=TRUE)   
print(paste("Maximum value: ",beers2$review_overall[max]))
print(max)
print(beers2[1676,c(4,6,24, 25)])

min = which(beers2$review_overall == min(beers2$review_overall), arr.ind=TRUE)
print(paste("Minimum value: ",beers2$review_overall[min]))
print(min)
print(beers2[557,c(4,6,24, 25)])

summary(beers2$review_overall)


groupAvg <- sqldf("select style, avg(review_overall) from beers2 group by style order by avg(review_overall) desc")
topGroups <- top_n(groupAvg, 10)
topGroups

ggplot(topGroups, aes(x=topGroups$Style, y=topGroups$`avg(review_overall)`, theme(axis.ticks.x = element_line(angle = 90)))) + geom_col()




beerTree <- beers2[c(2,7,8)]
beers2 <- droplevels(beers2)
beerTree


#Rules
rules <- apriori(beers2, list(supp = 0.01, conf = 0.2))
rules
inspect(rules[14:24])


mean(beers2$ABV)

#random forest
set.seed(222)
scores <- beers2[-c(5)]
scores <- droplevels(scores)

ind <- sample(2, nrow(scores), replace = TRUE, prob = c(0.7, 0.3))
train <- scores[ind==1,]
test <- scores[ind==2,]

beerforest <- randomForest(grades~., data=train, proximity=TRUE)
beerforest

p1 <- predict(beerforest, train)
confusionMatrix(p1, train$grades)

p2 <- predict(beerforest, test)
confusionMatrix(p2, test$grades)

plot(beerforest)

varImpPlot(beerforest,
           sort = T,
           n.var = 10,
           main = "Top Variable Importance")
importance(beerforest)

abv <- beers2[-c(4)]
ABVind <- sample(2, nrow(abv), replace = TRUE, prob = c(0.7, 0.3))
trainABV <- abv[ABVind==1,]
testABV <- abv[ABVind==2,]

abvforest <- randomForest(abvGrade~., data=trainABV, proximity=TRUE)
abvforest

ABVp1 <- predict(abvforest, trainABV)
confusionMatrix(ABVp1, trainABV$abvGrade)

ABVp2 <- predict(abvforest, test)
confusionMatrix(ABVp2, test$abvGrade)

plot(abvforest)

varImpPlot(abvforest,
           sort = T,
           n.var = 10,
           main = "Top 10 - Variable Importance")



rules <- apriori(beers2, list(supp = 0.01, conf = 0.2))
rules
inspect(rules[14:24])

mean(beers2$ABV)

high_abv <- sqldf("select Name, Style, ABV, review_overall from beers2 where ABV > '6'")
head(high_abv)
low_abv <- sqldf("select Name, Style, ABV, review_overall from beers2 where ABV < '6'")
head(low_abv)

abv_rules <- apriori(high_abv, list(supp = 0.01, conf=0.2))
inspect(abv_rules[7:20])
inspect(abv_rules[c(7,8,10,11,12)])

low_abv_rules <- apriori(low_abv, list(supp = 0.01, conf=0.2))
inspect(low_abv_rules[7:20])


