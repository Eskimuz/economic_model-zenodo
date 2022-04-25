#!/usr/bin/env Rscript

##Argument parser:
#Create parser object
library("argparse")
library(tidyverse)
library(readr)
library(dplyr)

parser <- ArgumentParser()

#Define desired outputs:
#GLOBAL FEATURES:
parser$add_argument("-input", "--Input_name", type="character", help="Input filenames.")
parser$add_argument("-output", "--Output_prefix", type="character", help="Output prefix for plots")
#parser$add_argument("-fasta", "--Fasta_file", type="character", help="Genome fasta file.")
#parser$add_argument("-ini_pos", "--Initial_position", type="integer", default=50, help="Initial position [default %(default)].")
#parser$add_argument("-fin_pos", "--Final_position", type="integer", help="Final position.")


######### OUTPUT ANALYSIS ##########

#Get command line options, if help option encountered - print help and exit:
args <- parser$parse_args()

input_file <- args$Input_name


output_plot1 <- paste(args$Output_prefix, "_1.pdf", sep="")
output_plot2 <- paste(args$Output_prefix, "_2.pdf", sep="")
output_plot3 <- paste(args$Output_prefix, "_3.pdf", sep="")


#varname for the different variables 

## importing data
#rm(list = ls())

outputs <- read_csv(input_file, 
                    col_types = cols(X1 = col_number()), 
                    skip = 6,)


# rename [step] to avoid problems with [] in R
outputs <- outputs %>%
  rename(turn = 41,ID = 1)

outputs

exit

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

pdf(output_plot2)
print(prices)
dev.off()


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

pdf(output_plot2)
print(wealth)
dev.off()


