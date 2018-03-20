library(tidyverse)
library(lubridate)
library(rvest)


team <- "SDP"

get_team_seasons <- function(team){
  
  team_url <- paste0("https://www.baseball-reference.com/teams/",
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
      "https://www.baseball-reference.com", 
      str_replace(season_url, ".shtml", ""),
      "-schedule-scores.shtml"))
}

url <- team_table$season_url[2]

get_season_data <- function(url){
  
  year_html <- read_html(url)
  
  table_year <- str_extract(url, '\\d{4}')
  
  box_url <- year_html %>% 
    html_nodes("") %>% 
    html_attr("href")
  
  year_table <- year_html %>% 
    html_table() %>% 
    data.frame() %>% 
    janitor::clean_names() %>% 
    filter(gm != "Gm#") %>% 
    transmute(
      tm,
      gm,
      date = paste(str_replace(date, " \\(.\\)", ""), table_year),
      date = parse_date_time(date, "a, b! d! Y!"),
      home = if_else(var_5 == "@", FALSE, TRUE),
      opp = opp,
      r,
      ra,
      w_l
    )
  
  year_table
  
}
