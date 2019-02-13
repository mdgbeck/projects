library(tidyverse)
library(lubridate)
library(stringr)

add_newline <- function(string, n) {
  spaces <- str_locate_all(string, " ")[[1]][,1]
  chars  <- nchar(string)
  for(i in 1:floor(chars/n)) {
    s <- spaces[which.min(abs(spaces - n*i))]
    substring(string, s, s) <- "\n "
  }
  return(string)
}

data <- easy

get_question <- function(data){
  
  data <- data %>% 
    filter(!is.na(clue)) %>% 
    slice(sample(nrow(.), 1))
  data$new_clue = add_newline(data$clue, 40)
  
  
  clue_plot <- ggplot(data, aes(x = 1, y = 1)) +                       
    geom_point(color = "#1A1DCC") +
    geom_text(aes(y = 2, label = category), color = "white", size = 12) + 
    geom_text(aes(y = 1.5, label = new_clue), color = "white", size = 9) +
    theme_minimal() +
    theme(plot.background = element_rect(fill = "#1A1DCC"),
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.grid = element_blank())
  
  plot(clue_plot)
  
  cat("Category:", data$category, 
      "\nRound:   ", data$round, 
      "\nValue:   ", data$value,
      "\nYear:    ", year(data$date), 
      "\nClue:    ", data$clue)
  
  readline("Press Enter for answer")
  
  response_plot <- ggplot(data, aes(x = 1, y = 1)) +
    geom_point(color = "#1A1DCC") +
    geom_text(aes(y = 2, label = category), color = "white", size = 12) + 
    geom_text(aes(y = 1.5, label = response), color = "white", size = 10) +
    theme_minimal() +
    theme(plot.background = element_rect(fill = "#1A1DCC"),
          axis.text = element_blank(),
          axis.title = element_blank(),
          panel.grid = element_blank())
  
  plot(response_plot)
  
  cat("Correct Response:", data$response)

}

all_clues <- read_csv("~/Documents/data/jeopardy_complete.csv")

x <- all_clues %>% filter(!is.na(clue))

tv <- all_clues %>% filter(str_detect(category, "\\bTV|\\bTELEV") & date >= '2014-01-01')
easy <- all_clues %>% filter(value == 1 & date >= "2014-01-01")


get_question(x)
get_question(easy)




