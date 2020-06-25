library(tidyverse)
library(lubridate)
library(mdgr)
library(zoo)

nba_base <- read_csv("nba_cities.csv")

base_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/"

dates <- seq.Date(ymd('20200401'), today() - 1, by = 'day') %>% 
  format('%m-%d-%Y')


urls <- paste0(base_url, dates, ".csv")

dat <- map_dfr(urls, read_csv, col_types = "cccccddddddcdd", .id = "source", )

# remove spaces since some cities don't have proper space alignment
covid_data <- dat %>% 
  janitor::clean_names() %>% 
  mutate(
    pop = confirmed / (incidence_rate / 100000),
    perc = confirmed / pop,
    death_rate = deaths / pop,
    combined_key2 = str_replace_all(combined_key, " ", ""),
    source = as.numeric(source),
    date = today() - -1*(source - length(urls))
  ) %>% 
  group_by(combined_key2) %>% 
  mutate(pop = min(pop, na.rm = TRUE),
         perc = confirmed / pop)


nba <- nba_base %>% 
  mutate(
    combined_key2 = str_replace_all(
      paste(county, state, country, sep=","), " ", "")
  ) %>% 
  left_join(covid_data)

# test to see data for each date each team
y <- nba %>% 
  count(city)
n_distinct(y$n)

# add rolling means
nba <- nba %>% 
  arrange(city, desc(source)) %>% 
  group_by(city) %>% 
  mutate(
    case_lead = lead(confirmed),
    new_cases = confirmed - case_lead,
    new_cases_cap = new_cases / pop,
    new_cases_roll7 = rollmean(new_cases, 7, align = "left", fill = "NA"),
    new_cases_cap_roll7 = new_cases_roll7 / pop,
    rate_change = new_cases - lead(new_cases),
    rate_change_roll7 = rollmean(rate_change, 7, algin = "left", fill = "NA"),
    death_lead = lead(deaths),
    new_deaths = deaths - death_lead,
    new_deaths_roll7 = rollmean(new_deaths, 7, align = "left", fill = 'NA'),
    new_deaths_cap_roll7 = new_deaths_roll7 / pop,
    orange_county = case_when(city == "Orlando" ~ "Orange County")
  )

nba %>% 
  #filter(city != 'New York City') %>% 
  ggplot(aes(date, new_cases_roll7)) +
  geom_line(aes(color = city), size = .5) +
  theme_mdgr()


nba %>% 
  filter(city != 'New York City') %>% 
  ggplot(aes(date, new_deaths_cap_roll7)) +
  geom_line(aes(group = city), size = .5, color = "gray65") +
  geom_line(data = filter(nba, city == "Orlando"), color = "orange") +
  geom_line(data = filter(nba, city == "Charlotte"), color = "blue") +
  geom_line(data = filter(nba, city == "Phoenix"), color = "red") +
  theme_mdgr()


nba %>% 
  ggplot(aes(x = date)) +
  geom_line(aes(y = new_deaths_roll7), color = 'red') +
  geom_line(aes(y = new_cases_roll7 / 100), color = 'blue') + 
  theme_mdgr() +
  facet_wrap(~city, scales = 'free') +
  labs(y = "Deaths Per Day")

nba %>% 
  filter(city != 'New York City') %>% 
  ggplot(aes(x = date)) +
  geom_line(aes(y = new_deaths_roll7), color = 'red') +
  geom_line(aes(y = new_cases_roll7 / 50), color = 'blue') + 
  theme_mdgr() +
  facet_wrap(~city)

nba %>% 
  filter(city != 'New York City') %>% 
  ggplot(aes(x = date)) +
  geom_line(aes(y = new_deaths_cap_roll7), color = 'red') +
  geom_line(aes(y = new_cases_cap_roll7 / 100), color = 'blue') + 
  theme_mdgr() +
  facet_wrap(~city) +
  theme(axis.text.y = element_blank())
