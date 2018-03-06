library(tidyverse)

nba <- read_csv("https://projects.fivethirtyeight.com/nba-model/nba_elo.csv")

# make standings?
make_nba_season <- function(df, year){
  
  season <- df %>% 
    filter(season == year &
             is.na(playoff))
  
  df1 <- season %>% 
  select(team = team1,
         other = team2,
         pts_for = score1,
         pts_agt = score2)
  
  df2 <- season %>% 
  select(team = team2,
         other = team1,
         pts_for = score2,
         pts_agt = score1)
  
  df_all <- bind_rows(df1, df2)

  out <- df_all %>% 
    group_by(team) %>% 
    summarize(G = n(),
            W = sum(pts_for > pts_agt),
            T = sum(pts_for == pts_agt),
            L = G - W)
}

x <- make_nba_season(nba, 2015)
