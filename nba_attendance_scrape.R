library(tidyverse)
library(rvest)

# get every game in a season
get_season_data <- function(team, year){
  
  year_url <- paste0("https://www.basketball-reference.com/teams/",
    team, "/",
    year, "_games.html")
  
  year_html <- read_html(year_url)
  
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

utah16 <- get_season_data("UTA", "1996")

# function to pull attendance number from a game page
get_attendance <- function(page_url){
  
  box_html <- read_html(page_url) %>% 
    html_text()
  
  str_extract(box_html, "Attendance:.*[:digit:]") %>% parse_number()
}

jazz16 <- utah16 %>% 
  filter(home == TRUE) %>% 
  mutate(att = map_dbl(box_url, get_attendance))

