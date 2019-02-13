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
  if (round == 3) node <- "#clue_FJ"
  
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
  if (round == 3) node <- "#final_jeopardy_round .correct_response"
  
  out <- page %>% 
    html_nodes(node) %>% 
    html_text
  
  if (length(out) == 0) out <- ""
  
  out
}

get_board <- function(page, round, type){
  
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
  if (length(categories) != 13){
    categories[(length(categories) + 1):13] <- paste(
      "EMPTY", 1:(13 - length(categories)))
  }
  # else if(length(unique(categories)) != 13){
  #   categories[duplicated(categories)] <- paste(
  #     "EMPTY", 1:length(categories[duplicated(categories)]))
  # }
  
  clue1 <- get_board(clue_page, round = 1, type = "clue")
  names(clue1) <- categories[1:6]
  clue1 <- clue1 %>% 
    gather(key = "category", value = "clue") %>% 
    mutate(value = rep(1:5, 6))
  
  resp1 <- get_board(response_page, round = 1, type = "response")
  names(resp1) <- categories[1:6]
  resp1 <- resp1 %>% 
    gather(key = "category", value = "response") %>% 
    mutate(value = rep(1:5, 6))
  
  round1 <- left_join(clue1, resp1, by = c("category", "value")) %>% 
    mutate(round = 1)
  
  clue2 <- get_board(clue_page, round = 2, type = "clue")
  names(clue2) <- categories[7:12]
  clue2 <- clue2 %>% 
    gather(key = "category", value = "clue") %>% 
    mutate(value = rep(1:5, 6))
  
  resp2 <- get_board(response_page, round = 2, type = "response")
  names(resp2) <- categories[7:12]
  resp2 <- resp2 %>% 
    gather(key = "category", value = "response") %>% 
    mutate(value = rep(1:5, 6))
  
  round2 <- left_join(clue2, resp2, by = c("category", "value")) %>% 
    mutate(round = 2)
  
  final <- data_frame(
    id = id, 
    date = date,
    round = 3,
    value = NA,
    category = categories[13],
    clue = get_clue(clue_page, 3, 1, 1),
    response = get_response(response_page, 3, 1, 1)
  )
  
  out <- bind_rows(round1, round2) %>% 
    transmute(
      id = id,
      date = date,
      round,
      value,
      category,
      clue,
      response
    ) %>% 
    bind_rows(final)
  
  print(paste("finished pulling episode", date))
  out
  
}

get_season_data <- function(season){
  
  season_url <- paste0("http://www.j-archive.com/showseason.php?season=",
                       season)
  
  season_html <- read_html(season_url)
  
  season_list <- season_html %>% 
    html_nodes("td:nth-child(1) a")
  
  season_data <- season_html %>% 
    html_node("table") %>% 
    html_table(header = FALSE) %>% 
    transmute(
      number = str_extract(X1, "\\d+"),
      date = ymd(str_sub(X1, -10)),
      player1 = str_split(X2, " vs. ", simplify = TRUE)[, 1],
      player2 = str_split(X2, " vs. ", simplify = TRUE)[, 2],
      player3 = str_split(X2, " vs. ", simplify = TRUE)[, 3],
      note = X3,
      url = html_attr(season_list, "href"),
      id = str_extract(url, "\\d+")
    )

}

