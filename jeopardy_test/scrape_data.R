source("jeopardy_test/scrape_functions.R")

for(i in 9:9){
  
  dat <- get_season_data(i)
  out <- suppressWarnings(map2_dfr(dat$id, dat$date, get_game_data))
  
  file_name <- paste0("jeopardy_test/data/season", i, ".csv")
  
  write_csv(out, file_name, na = "")
  print(paste("finished writing", file_name))
  
}

for(i in 1:34){
  
  dat <- get_season_data(i)
  
  file_name <- paste0("jeopardy_test/data/season", i, "_info.csv")
  
  write_csv(dat, file_name, na = "")
}
