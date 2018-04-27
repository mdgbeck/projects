# scrape questions from jarchive

library(tidyverse)
library(lubridate)
library(rvest)

get_categories <- function(page){
  
  page %>% 
    html_nodes(".category_name") %>% 
    html_text()
}

get_clue <- function(page, round, row, column){
  
  if (round == 1) round <- "J"
  else if (round == 2) round <- "DJ"
  
  node <- paste("#clue", round, column, row, sep = "_")
  
  out <- page %>% 
    html_nodes(node) %>% 
    html_text
  
  if (length(out) == 0) out <- ""
  
  out
  
}

get_response <- function(page, round, row, column){
  
  if (round == 1) round <- "jeopardy_round"
  else if (round == 2) round <- "double_jeopardy_round"
  
  node <- paste0("#", round, " tr:nth-child(", row + 1, ") .clue:nth-child(",
                 column, ") .correct_response")
  
  out <- page %>% 
    html_nodes(node) %>% 
    html_text
  
  if (length(out) == 0) out <- ""
  
  out
}

make_board <- function(page, round, type){
  
  board <- matrix(nrow = 5, ncol = 6, NA)
  
  if (type == "clue"){
    
    for(i in 1:nrow(board)){
      for(j in 1:ncol(board)){
        board[i, j] <- get_clue(page, round, i, j)
      }
    }
  }
  else if (type == "response"){
    
    for(i in 1:nrow(board)){
      for(j in 1:ncol(board)){
        board[i, j] <- get_response(page, round, i, j)
      }
    }
  }
  as.data.frame(board)
}

get_game_data <- function(id, date = today()){
  
  clue_url <- paste0("http://www.j-archive.com/showgame.php?game_id=", id)
  clue_page <- read_html(clue_url)
  
  response_url <- paste0("http://www.j-archive.com/showgameresponses.php?game_id=", id)
  response_page <- read_html(response_url)
  
  categories <- get_categories(clue_page)
  
  clue1 <- make_board(clue_page, round = 1, type = "clue")
  names(clue1) <- categories[1:6]
  clue1 <- clue1 %>% 
    gather(key = "category", value = "clue") %>% 
    mutate(value = rep(1:5, 6))
  
  resp1 <- make_board(response_page, round = 1, type = "response")
  names(resp1) <- categories[1:6]
  resp1 <- resp1 %>% 
    gather(key = "category", value = "response") %>% 
    mutate(value = rep(1:5, 6))
  
  round1 <- left_join(clue1, resp1, by = c("category", "value")) %>% 
    mutate(round = 1)
  
  clue2 <- make_board(clue_page, round = 2, type = "clue")
  names(clue2) <- categories[7:12]
  clue2 <- clue2 %>% 
    gather(key = "category", value = "clue") %>% 
    mutate(value = rep(1:5, 6))
  
  resp2 <- make_board(response_page, round = 2, type = "response")
  names(resp2) <- categories[7:12]
  resp2 <- resp2 %>% 
    gather(key = "category", value = "response") %>% 
    mutate(value = rep(1:5, 6))
  
  round2 <- left_join(clue2, resp2, by = c("category", "value")) %>% 
    mutate(round = 2)
  
  out <- bind_rows(round1, round2) %>% 
    transmute(
      id = id,
      date = date,
      round,
      value,
      category,
      clue,
      response
    )
  
  out
  
}

