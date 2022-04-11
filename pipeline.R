######### OUTPUT ANALYSIS ##########

#varname for the different variables 

#required packages 
install.packages("tidyverse")
install.packages("readr")
install.packages('dplyr')

library(tidyverse)
library(readr)
library(dplyr)


## importing data
rm(list = ls())
outputs <- read_csv("high-initial-wages-yes-government.tsv", 
                    col_types = cols(X1 = col_number()), 
                    skip = 6,)

as_tibble(outputs)

# rename [step] to avoid problems with [] in R
outputs <- outputs %>%
  rename(turn = 41,ID = 1)


##### CHANGE NAME FROM <variable> to desired variable of ouput -> to have all would be nice

###mean of desired variable
variable_average  <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`nameofvariable`), list(variable_mean = mean))

###quantiles of desired variable
variablequantiles <- outputs %>%
  group_by(turn) %>%
  summarize(min_variable = quantile(`nameofvariable`, probs = 0), 
            max_variable = quantile(`nameofvariable`, probs = 1),
            high_variable = quantile(`nameofvariable`, probs = 0.975),
            low_variable = quantile(`nameofvariable`, probs = 0.025))

merged_for_variable <- merge(variable_average,variable_quantiles,by="turn") #merges datasets

#for ribbons graph with max and min line too
## do this for all ouput variables, from column 42 onwards

desired_graph <- ggplot(data = merged_for_variable, aes(x=turn)) + ##produces the plot
  geom_line(aes(y=variable_mean,color="variable")) +
  geom_line(aes(y=min_variable, color="min value of variable", linetype = "twodash")) +
  geom_line(aes(y=max_variable, color="max value of variable", linetype = "twodash")) +
  labs(x = 'Time', y = 'GDP' ) + #changes the plot to a line
  ggtitle("Average nameofvariable") +
  scale_color_manual(name = "Classes", values = c("variable" = "red","min value of variable" = "orange", "min value of variable" = "orange"))+
  geom_ribbon(merged_for_variable = for_ribbons, aes(ymin = low_variable, ymax = high_variable), alpha=0.2) + ##produces area around mean,
  geom_vline(xintercept = 100) + #line for time change
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) ##removes all backgrounds and adds a black line

desired_graph

## comparison graphs, only for wealth and  prices 




## prices

bourgeoisiesprice <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`mean [price] of bourgeoisie`),list(bourgeoisieprices = mean))

bourgeoisiespricessshades <- outputs %>%
  group_by(turn) %>%
  summarize(highbourgpr = quantile(`mean [price] of bourgeoisie`, probs = 0.975),
            lowbourgpr = quantile(`mean [price] of bourgeoisie`, probs = 0.025))
bourgeoisiesprice <- merge(bourgeoisiesprice,bourgeoisiespricessshades, by = "turn")

firmsprice <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`mean [price] of firms`),list(firmsprices = mean))

firmspricesshades <- outputs %>%
  group_by(turn) %>%
  summarize(highfirmpr = quantile(`mean [price] of firms`, probs = 0.975),
            lowfirmpr = quantile(`mean [price] of firms`, probs = 0.025))
firmsprice <- merge(firmsprice,firmspricesshades, by = "turn")


farmsprice <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`mean [price] of farms`),list(farmsprices = mean))

farmspricesshades <- outputs %>%
  group_by(turn) %>%
  summarize(highfarmpr = quantile(`mean [price] of farms`, probs = 0.975),
            lowfarmpr = quantile(`mean [price] of farms`, probs = 0.025))
farmsprice <- merge(farmsprice,farmspricesshades, by = "turn")

forprices <- merge(bourgeoisiesprice,firmsprice,by="turn")
forprices <- merge(forprices,farmsprice,by="turn")

prices <- ggplot(data = forprices, aes(x=turn)) + ##produces the plot
  geom_line(aes(y=bourgeoisieprices,color="Bourgeoisie")) +
  geom_line(aes(y=firmsprices, color="Firms")) +
  geom_line(aes(y=farmsprices, color="Farms")) +
  geom_ribbon(data = forprices,aes(x=turn,y=firmsprices,ymin = lowfirmpr, ymax = highfirmpr), alpha=0.1) +
  geom_ribbon(data = forprices,aes(x=turn,y=bourgeoisieprices,ymin = lowbourgpr, ymax = highbourgpr), alpha=0.1) +
  geom_ribbon(data = forprices,aes(x=turn,y=farmsprices,ymin = lowfarmpr, ymax = highfarmpr), alpha=0.1) +
  labs(x = 'Time', y = 'Value' ) + #changes the plot to a line
  ggtitle('Prices averages') +
  scale_color_manual(name = "Classes", values = c("Bourgeoisie" = "orange", "Firms" = "yellow", "farms" = "green"))+
  geom_vline(xintercept = 100) + #line for time change
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

prices

##WEALTH

bourgeoisiesincomes <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`mean [wealth] of bourgeoisie`),list(bourgeoisiewealth = mean))

bourgeoisiesincomesshades <- outputs %>%
  group_by(turn) %>%
  summarize(highbourg = quantile(`mean [wealth] of bourgeoisie`, probs = 0.975),
            lowbourg = quantile(`mean [wealth] of bourgeoisie`, probs = 0.025))

bourgeoisiesincomes <- merge(bourgeoisiesincomes,bourgeoisiesincomesshades, by = "turn")

workersincomes <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`mean [wealth] of workers`), list(workerswealth = mean))
workersincomesshades <- outputs %>%
  group_by(turn) %>%
  summarize(highwork = quantile(`mean [wealth] of workers`, probs = 0.975),
            lowwork = quantile(`mean [wealth] of workers`, probs = 0.025))
workersincomes <- merge(workersincomes,workersincomesshades, by = "turn")

noblesincomes <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`mean [wealth] of nobles`),list(nobleswealth = mean))
noblesincomeshades <- outputs %>%
  group_by(turn) %>%
  summarize(highnobles = quantile(`mean [wealth] of nobles`, probs = 0.975),
            lownobles = quantile(`mean [wealth] of nobles`, probs = 0.025))

noblesincomes <- merge(noblesincomes,noblesincomeshades,by="turn")

farmscapital <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`average-capital-farms`),list(farmscapital = mean))

farmsshades <- outputs %>%
  group_by(turn) %>%
  summarize(highfarms = quantile(`average-capital-farms`, probs = 0.975),
            lowfarms = quantile(`average-capital-farms`, probs = 0.025))

farmscap <- merge(farmscapital,farmsshades,by="turn")


firmscapital <- outputs %>%
  group_by(turn) %>%
  summarise_at(vars(`average-capital-firms`),list(firmscapital = mean))

firmsshades <- outputs %>%
  group_by(turn) %>%
  summarize(highfirms = quantile(`average-capital-firms`, probs = 0.975),
            lowfirms = quantile(`average-capital-firms`, probs = 0.025))

firmscap <- merge(firmscapital,firmsshades,by="turn")

forcapital <- merge(firmscap,farmscap,by="turn")

forincomes <- merge(bourgeoisiesincomes,workersincomes,by="turn")
forincomes <- merge(forincomes,noblesincomes,by="turn")
forincomes <- merge(forincomes,forcapital,by="turn")

names<-c('bourgeoisies','workers','nobles','farms','firms')


wealth <- ggplot(data = forincomes, aes(x=turn)) + ##produces the plot
  geom_line(aes(y=bourgeoisiewealth,color='Bourgeoisies')) +
  geom_line(aes(y=workerswealth,color='Workers')) +
  geom_line(aes(y=nobleswealth,color='Nobles')) +
  geom_line(aes(y=farmscapital,color='Farms')) +
  geom_line(aes(y=firmscapital,color='Firms')) +
  geom_ribbon(data = forincomes,aes(x=turn,y=bourgeoisiewealth,ymin = lowbourg, ymax = highbourg), alpha=0.1) +
  geom_ribbon(data = forincomes,aes(x=turn,y=nobleswealth,ymin = lownobles, ymax = highnobles), alpha=0.1) +
  geom_ribbon(data = forincomes,aes(x=turn,y=workerswealth,ymin = lowwork, ymax = highwork), alpha=0.1) +
  geom_ribbon(data = forincomes,aes(x=turn,y=farmscapital,ymin = lowfarms, ymax = highfarms), alpha=0.1) +
  geom_ribbon(data = forincomes,aes(x=turn,y=firmscapital,ymin = lowfirms, ymax = highfirms), alpha=0.1) +
  labs(x = 'Time', y = 'Wealth' ) + #changes the plot to a line
  ggtitle('Wealth Averages') +
  scale_color_manual(name = "Classes", values = c("Bourgeoisies" = "orange", "Workers" = "red","Nobles" = "blue", "Farms" = "green", "Firms" = "yellow"))+
  geom_vline(xintercept = 100) + #line for time change
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))

wealth

