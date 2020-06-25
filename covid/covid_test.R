library(tidyverse)
library(lubridate)
library(mdgr)
library(zoo)

all <- read_csv("https://covidtracking.com/api/v1/us/daily.csv")

nc <- read_csv("https://covidtracking.com/api/v1/states/nc/daily.csv") %>% 
  mutate(
    date = ymd(date),
    new_pos7day = rollmean(positiveIncrease, 7, fill = NA)
  )



nc %>% 
  ggplot(aes(date, hospitalizedCurrently)) +
  geom_line() +
  theme_mdgr()

nc %>% 
  ggplot(aes(date, positiveIncrease)) +
  geom_line() +
  geom_line(aes(date, new_pos7day)) +
  theme_mdgr()


df <- data.frame(a = 1:3, e=sample(10, 3))
map_dfc(0:2, ~mutate(select(df, e), e=lead(e, .x)))