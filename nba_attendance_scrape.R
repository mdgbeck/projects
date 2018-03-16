library(tidyverse)
library(rvest)

utah16_url <- "https://www.basketball-reference.com/teams/UTA/2016_games.html"

box_urls <- read_html(utah16_url) %>% 
  html_nodes(".center a") %>% 
  html_attr("href") %>% 
  data_frame()

full_urls <- box_urls %>% 
  select(url = 1) %>% 
  mutate(url = paste0("https://www.basketball-reference.com", url))
  
get_attendance <- function(page_url){
  
  box_html <- read_html(page_url) %>% 
    html_text()
  
  str_extract(box_html, "Attendance:.*[:digit:]") %>% parse_number()
  
}

jazz16_att <- lapply(full_urls$url, get_attendance)

box_html <- read_html(box_url) %>% 
  html_text()

str_detect(box_html, "ttendance")

x <- str_extract(box_html, "Attendance:.*[:digit:]") %>% parse_number()
