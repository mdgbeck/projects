
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
x <- full_data %>% 
  filter(str_detect(category, "EMPTY")) %>% 
  count(id) %>% 
  left_join(full_info) %>% 
  filter(n == 5)

look <- full_data %>% 
  filter(id == 13)

str_extract(info_files, '\\d+')

get_game_data(13, '2006-07-14')
