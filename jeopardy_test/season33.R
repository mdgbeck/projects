# get all season 33 jeopardy
source("jeopardy_test/scrape_functions.R")

get_season_data <- function(season){
  
  season_url <- paste0("http://www.j-archive.com/showseason.php?season=",
                     season)
  season_html <- read_html(season_url)
  
  season_list <- season_html %>% 
    html_nodes("td:nth-child(1) a")
  
  season_data <- data_frame(
    url = html_attr(season_list, "href"),
    id = str_extract(url, "\\d+"),
    date = ymd(str_sub(html_text(season_list), -10))
  )

}

dat <- get_season_data(33)


x <- suppressWarnings(map2_dfr(dat$id, dat$date, get_game_data))
13800 / 60

write_csv(x, "jeopardy_test/data/season33.csv")

cat <- x %>% 
  count(category) %>% 
  arrange(desc(n))
