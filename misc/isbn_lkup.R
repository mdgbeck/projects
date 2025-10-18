library(tidyverse)
library(janitor)
library(httr2)
library(stringdist)

orig_book_list <- read_csv('book_list.csv') %>% 
  mutate(clean_title = str_remove_all(Title, '\\(.*?\\)'))

orig_book_list <- orig_book_list %>% 
  distinct(clean_title, .keep_all = TRUE)

api_code <- '64743_36572894f9023a398bde0bc02a335df1'

isbn_url <- 'https://api.isbndb.com/books'


isbn_lkup <- function(book_title){
  
  req <- request(isbn_url) %>% 
    req_headers("Authorization" = api_code) %>% 
    req_url_path_append(book_title) %>% 
    req_url_query(
      "pageSize" = 5
    ) %>% 
    req_perform()
  
  if (resp_is_error(req) == TRUE){
    out <- 'error'
  } else {
    books <- resp_body_json(req)$books
    if (is.null(books)){
      out <- 'book not found'
    } else {
      match_df <- tibble()
      for(i in 1:length(books)){
        if (length(books[[i]]$authors) == 0){
          author_c <- 'no author'
        } else {
          author_c <- books[[i]]$authors[[1]]
        }
        match_df <- match_df %>% 
          bind_rows(
            tibble(
              title = book_title,
              isbn = books[[i]]$isbn,
              author = author_c,
              result_num = i
            )
          )
      }
      out <- match_df
    }
  }
  out
}

book_list <- list()

for(i in 1:nrow(orig_book_list)){
# for(i in 1:10){
  new_dat <- isbn_lkup(orig_book_list$clean_title[i])
  book_list[[length(book_list) + 1]] <- new_dat
  Sys.sleep(1)
  
}

check_book <- function(x){
  if(is_tibble(x)){
    x
  }
  else{
    tibble()
  }
}

api_output_df <- map_dfr(book_list, check_book)

out <- orig_book_list %>%
  left_join(api_output_df, by = join_by(clean_title == title))

out <- out %>% 
  mutate(
    author_sim_score = stringdist(author.x, author.y, method = 'lv')
  ) %>% 
  arrange(clean_title, author_sim_score) %>% 
  distinct(clean_title, .keep_all = TRUE) %>% 
  transmute(
    title = Title,
    author = author.x,
    found_author = author.y,
    author_sim_score,
    isbn
  )

write_csv(out, 'final_book_list_raw.csv', na= '')
