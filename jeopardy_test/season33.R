# get all season 33 jeopardy
source("jeopardy_test/scrape_functions.R")


dat <- get_season_data(1)


start_time = Sys.time()

s1 <- suppressWarnings(map2_dfr(dat$id, dat$date, get_game_data))

end_time = Sys.time()

end_time - start_time

write_csv(s1, "jeopardy_test/data/season1.csv")



cat <- x %>% 
  count(category) %>% 
  arrange(desc(n))
