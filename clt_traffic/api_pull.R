library(httr)
library(jsonlite)


for (i in 1:5){
  cat(i, file = '~/Documents/projects/clt_traffic/log', append = TRUE)
  raw_json <- try(GET('https://cmpdinfo.charlottenc.gov/api/v2.1/Traffic', timeout(20)))
  
  if (is.list(raw_json)){
    cat(' | ', format(Sys.time(), usetz = TRUE), 
        'returned status code:', raw_json$status_code,
        file = '~/Documents/projects/clt_traffic/log',
        append = TRUE)
    dat = try(fromJSON(content(raw_json, "text")))
    dat$fetchtime = Sys.time()
    cat(' fetched:', nrow(dat), 'rows ',
        file = '~/Documents/projects/clt_traffic/log',
        append = TRUE)
  }
  if (is.data.frame(dat)) break
  Sys.sleep(10)
}


if (is.data.frame(dat)){
  readr::write_csv(dat, '~/Documents/projects/clt_traffic/raw_data.csv', append = TRUE)
  cat('wrote:', nrow(dat), 'rows\n',
    file = '~/Documents/projects/clt_traffic/log',
    append = TRUE)
} else {
cat('wrote: 0 rows\n',
    file = '~/Documents/projects/clt_traffic/log',
    append = TRUE)
}

# while (TRUE) {
#   new_dat <- get_data()
#   dat = bind_rows(dat, new_dat)
#   print('fetched')
#   Sys.sleep(5)
# }

