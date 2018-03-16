library(tidyverse)

nba <- read_csv("https://projects.fivethirtyeight.com/nba-model/nba_elo.csv")

# make standings?
make_nba_standings <- function(df){
  
  df <- df %>% filter(is.na(playoff))
  
  df1 <- df %>% 
  select(team = team1,
         other = team2,
         pts_for = score1,
         pts_agt = score2)
  
  df2 <- df %>% 
  select(team = team2,
         other = team1,
         pts_for = score2,
         pts_agt = score1)
  
  df_all <- bind_rows(df1, df2)

  df_all %>% 
    group_by(team) %>% 
    summarize(G = n(),
            W = sum(pts_for > pts_agt),
            T = sum(pts_for == pts_agt),
            L = G - W)
  
}

test <- nba %>% 
  group_by(season) %>% 
  nest() 

test2 <- test %>% 
  mutate(
    standings = map(data, make_nba_standings)
  )
test2$standings[[1]]
