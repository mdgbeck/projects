
library(tidyverse)

data_files <- list.files('jeopardy_test/data/season_data/', full.names = TRUE)
info_files <- list.files('jeopardy_test/data/season_info/', full.names = TRUE)
info_seasons <- str_extract(info_files, '\\d+')

full_data <- lapply(data_files, read_csv) %>% bind_rows()

full_info <- map2_dfr(info_files, info_seasons, 
                      ~read_csv(.x) %>% mutate(season = .y))


# DQ checks

# all episodes have info
nrow(full_data %>% anti_join(full_info, by = "id"))

# all info episodes have data
nrow(full_info %>% anti_join(full_data, by = 'id'))

# which episodes are missing categories due to stupid duplicate coding
need_fixing <- full_data %>% 
  filter(str_detect(category, "EMPTY")) %>% 
  count(id) %>% 
  left_join(full_info) %>% 
  filter(n == 5)

source("jeopardy_test/scrape_functions.R")
fixed_episodes <- suppressWarnings(
  map2_dfr(need_fixing$id, need_fixing$date, get_game_data)
)

full_data2 <- full_data %>% 
  filter(!id %in% need_fixing$id) %>% 
  bind_rows(fixed_episodes)

need_fixing2 <- full_data2 %>% 
  filter(str_detect(category, "EMPTY")) %>% 
  count(id) %>% 
  left_join(full_info)

# majority of these look like website dq issues
# there are ones with tie breakers that I fixed manually.
ties <- full_data2 %>% 
  count(id) %>% 
  filter(n != 61)

#write_csv(full_data2, "~/Documents/data/jeopardy_clues.csv", na = "")
#write_csv(full_info, "~/Documents/data/jeopardy_info.csv", na = "")


complete_data <- read_csv("~/Documents/data/jeopardy_clues.csv") %>% 
  left_join(full_info, by = 'id') %>% 
  transmute(
    id,
    season,
    number,
    date = date.x,
    note,
    player1,
    player2,
    player3,
    round,
    value,
    category,
    clue,
    response
  ) %>% 
  arrange(date)

write_csv(complete_data, "~/Documents/data/jeopardy_complete.csv", na = "")
