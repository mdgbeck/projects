library(tidyverse)
library(lubridate)
library(rvest)


# put in current team name, get season urls
get_team_seasons <- function(team){
  
  team_url <- paste0("https://www.basketball-reference.com/teams/",
                     team, "/")
  
  team_html <- read_html(team_url)
  
  season_url <- team_html %>% 
    html_nodes("th a") %>% 
    html_attr("href")
  
  team_table <- team_html %>% 
    html_table() %>% 
    data.frame() %>% 
    janitor::clean_names() %>% 
    mutate(season_url = paste0(
      "https://www.basketball-reference.com", 
      str_replace(season_url, ".html", ""),
      "_games.html"))
}

# get every game in a season
get_season_data <- function(url){
  
  year_html <- read_html(url)
  
  box_url <- year_html %>% 
    html_nodes("#games .center a") %>% 
    html_attr("href")
  
  year_table <- year_html %>% 
    html_nodes("#games") %>% 
    html_table() %>% 
    data.frame() %>% 
    filter(G != "G") %>% 
    transmute(
      g = G,
      datetime = str_replace(paste(Date, Var.3), " ET", "m"),
      datetime = parse_date_time(datetime, "a, b! d!, Y I! M! p!",
                                 tz = "US/Eastern", truncated = 3),
      home = if_else(Var.6 == "@", FALSE, TRUE),
      opponent = Opponent,
      tm = Tm,
      opp = Opp,
      box_url = paste0("https://www.basketball-reference.com", box_url)
    )
  
  # home <- year_html %>%
  #   html_nodes("#games td:nth-child(6)") %>%
  #   html_text()
  # 
  # tm_score <- year_html %>%
  #   html_nodes("#games .center+ .right") %>%
  #   html_text()
  # 
  # opp_score <- year_html %>%
  #   html_nodes("#games .center~.right+ .center") %>%
  #   html_text()
  # 
  # season_df <- cbind(box_url, home, tm_score, opp_score) %>% 
  #   data.frame(stringsAsFactors = FALSE) %>%
  #   mutate(year = year,
  #          team = team,
  #          box_url = paste0("https://www.basketball-reference.com", box_url),
  #          home = if_else(home != "@", TRUE, FALSE))
  
  year_table
  
}


# function to pull attendance number from a game page
get_attendance <- function(page_url){
  
  box_html <- read_html(page_url) %>% 
    html_text()
  
  str_extract(box_html, "Attendance:.*[:digit:]") %>% parse_number()
}

dat <- get_team_seasons("CHA")

dat_season <- map_dfr(cha$season_url[2:6], get_season_data)

dat_att <- cha_season %>% 
  filter(home == TRUE) %>% 
  mutate(att = map_dbl(box_url, get_attendance))


# read in old csv
old_all_nba <- read_csv("sports_attendance/data/all_nba_attendance.csv")

new_att_data <- dat_att

all_nba <- bind_rows(new_att_data, old_all_nba)

#write_csv(all_nba, "sports_attendance/data/all_nba_attendance.csv", na="")