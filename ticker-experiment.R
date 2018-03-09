# set working directory
path <- "~/quantquote_daily_sp500/daily/"
setwd("~/quantquote_daily_sp500/daily/")

# read file names into vector
f.names <- list.files(path)
f.names <- f.names[grepl(".csv", f.names)]

# loop reading in multiple datasets
data <- lapply(f.names, read.csv, header=F, stringsAsFactors = F)

# loop labeling the list
data <- setNames(data, f.names)

# create new variable using mapply
data <- mapply(`[<-`, data, 'ticker', value = names(data), SIMPLIFY = FALSE)

# create dataframe by binding all rows in list
data <- bind_rows(data)
names(data) <- c("date", "time", "open", "high", "low", "close", "volume", "ticker") 

# clean up ticker variable
data$ticker <- gsub("table_", "", data$ticker)
data$ticker <- gsub(".csv", "", data$ticker)

# add day of the week to dataset
library(lubridate)
data$date <- ymd(data$date)
data$day <- wday(data$date, label = TRUE)

# clean up and write to dataset
data <- data[ , -2] # remove meaningless time variable
write.csv(data, "~/sp500-20yr-ticker.csv")