library(colorout)

ls_env_dfs <- function(){

  objs <- ls(envir = .GlobalEnv)

  d <- tibble(df = objs,
              class = map_chr(df, function(x) class(.GlobalEnv[[x]])[1])) %>% 
    filter(class %in% c('data.frame', 'tbl_df', 'grouped_df', 'spec_tbl_df')) %>% 
    mutate(nrows = map_int(df, function(x) nrow(.GlobalEnv[[x]])),
           ncols = map_int(df, function(x) ncol(.GlobalEnv[[x]])))
   
    return(d)
}

ls_env_global <- function(){

  objs <- ls(envir = .GlobalEnv)

  d <- tibble(df = objs,
              class = map_chr(df, function(x) class(.GlobalEnv[[x]])[1]))
    return(d)
}
