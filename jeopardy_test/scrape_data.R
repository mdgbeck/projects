source("jeopardy_test/scrape_functions.R")

for(i in 2:2){
  
  dat <- get_season_data(i)
  out <- suppressWarnings(map2_dfr(dat$id, dat$date, get_game_data))
  
  file_name <- paste0("jeopardy_test/data/season", i, ".csv")
  
  write_csv(file_name, na="")
  
}
