library(tidyverse)
library(lubridate)

dat <- read_csv('clt_traffic/raw_data.csv', col_names = c(
  'event_no', 'event_time', 'added_time', 'type_code', 'type_desc', 'type_subcode',
  'type_subdesc', 'division', 'x_coord', 'y_coord', 'latitude', 'longitude', 'address', 'time_pulled'
))
dat <- dat %>% mutate(time_pulled = as_datetime(time_pulled, tz = "America/New_York"))

first_pull = min(dat$time_pulled)
most_recent = max(dat$time_pulled)

events <- dat %>% 
  group_by(event_no) %>% 
  summarize(
    min_event_time = min(event_time),
    min_time_pulled = min(time_pulled),
    max_time_pulled = max(time_pulled),
  ) %>% 
  mutate(
    time_listed = round(difftime(max_time_pulled, min_time_pulled, units = 'mins')),
    time_listed = ifelse(
      max_time_pulled == most_recent | min_time_pulled == first_pull, 
      NA, time_listed
    )
  )

check <- dat %>% 
  group_by(event_no, event_time, type_desc, type_subcode, division, address, latitude, longitude) %>% 
  summarize(
    n_times = n(),
    min_time_pulled = min(time_pulled),
    max_time_pulled = max(time_pulled)
  ) %>% 
  arrange(event_no, max_time_pulled) %>% 
  ungroup() %>% 
  filter(!duplicated(event_no))

write_csv(check, 'clt_traffic/output.csv')

# dat = fromJSON(content(GET('https://cmpdinfo.charlottenc.gov/api/v2.1/Traffic'), "text"))
               