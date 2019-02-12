
library(tidyverse)
library(lubridate)
library(babynames)
library(mdgr)
library(scales)

names <- babynames %>% 
  filter(year >= 1950 &
           sex == "F" &
           n > 15) %>% 
  group_by(name) %>% 
  mutate(n_years = n_distinct(year),
         prev = lag(prop),
         change = prop - prev,
         perc_chg = 100 * change / prop) %>% 
  filter(n_years == max(n_years))

name_var <- names %>% 
  group_by(name) %>% 
  summarize(n = sum(n),
            yrs = n_distinct(year),
            avg = mean(perc_chg, na.rm = TRUE),
            med = median(perc_chg, na.rm = TRUE),
            sd_perc = sd(perc_chg, na.rm = TRUE)) %>% 
  mutate(abs_avg = abs(avg),
         abs_med = abs(med)) %>% 
  filter(yrs == n_distinct(names$year)) %>% 
  #arrange(desc(n)) %>% 
  #arrange(abs(sd_perc))
  arrange(sd_perc)

names %>% 
  filter(name %in% name_var$name) %>% 
  ggplot(aes(x=year, y = prop)) +
  geom_line(aes(group = name), color = "gray75", size = .5) +
  geom_line(data = filter(names, 
                          #name %in% c("abc")),
                          name %in% name_var$name[name_var$abs_avg < 2][1:5]), 
            aes(color = name), size = 1.25) +
  #coord_cartesian(ylim = c(0, .02)) +
  theme_mdgr()


# boy girl names
boys <- babynames %>% 
  filter(year >= 1980 & sex == 'M' & n > 50) %>% 
  group_by(name) %>% 
  filter(n_distinct(year) == max(n_distinct(year))) %>% 
  select(year, name, n_boys = n, prop_boys = prop)


girls <- babynames %>% 
  filter(year >= 1980 & sex == 'F' & n > 50) %>% 
  group_by(name) %>% 
  filter(n_distinct(year) == max(n_distinct(year))) %>% 
  select(year, name, n_girls = n, prop_girls = prop)


bg <- boys %>% 
  inner_join(girls, by = c('year', 'name')) %>% 
  mutate(
      perc_girl = n_girls / (n_boys + n_girls),
      mid = abs(.5 - perc_girl)
  )

bg_names <- bg %>% 
  group_by(name) %>% 
  summarize(
    n_boys = sum(n_boys),
    n_girls = sum(n_girls),
    n = n_boys + n_girls,
    perc_girl_total = n_girls / n,
    mid_total = abs(.5 - perc_girl_total),
    var_girl = var(perc_girl)
  ) %>% 
  arrange(desc(n))

var_names <- bg_names %>% 
  arrange(desc(var_girl))

# plot of highest variance names (boy / girl change)
bg %>% 
  filter(name %in% bg_names$name[1:1000]) %>% 
  ggplot(aes(year, perc_girl)) +
  geom_line(aes(group = name), color = "gray75", size = .5, show.legend = NA) +
  geom_line(data = filter(bg, name %in% var_names$name[1:10]), 
            aes(color = name), size = 1.25) +
  scale_y_continuous(label = percent) +
  theme_mdgr()

# overall popularity of name
plot_data <- babynames %>% 
  filter(name %in% var_names$name[1:5] & year > 1980)

ggplot(plot_data, aes(year, prop)) +
  geom_line(data = filter(plot_data, sex == 'F'),
            aes(group = name), color = 'pink') +
  geom_line(data = filter(plot_data, sex == 'M'),
            aes(group = name), color = 'skyblue') +
  geom_point(data = filter(plot_data, sex == 'F'),
            aes(color = name)) +
  geom_point(data = filter(plot_data, sex == 'M'),
            aes(color = name)) +
  scale_y_continuous(label = percent) +
  theme_mdgr()

write_csv(arrange(filter(bg_names, perc_girl_total > .05), mid_total), 'personal/names_bg1.csv', na="")

girl2017 <-  babynames %>% 
  filter(year == 2017 & sex == 'F') %>% 
  arrange(desc(n)) %>% 
  slice(1:1000) %>% 
  write_csv(., 'personal/names_2017.csv')
          