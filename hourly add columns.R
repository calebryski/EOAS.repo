library(dplyr)
library(lubridate)
library("stringr")
library("reshape2")

setwd("C:/Users/rykaczewski.2/OneDrive - The Ohio State University/Caleb Rykaczewski/Projects/EOAS 2021/data sheet versions")

df2 <- read.csv("042422.EOAS21.CR30.csv")

df1 <- read.csv("041222.datasummary_GPS_AX3.AC01.csv")

df1$hours <- str_sub(df1$hour,-8,-7)
df1$date <- str_sub(df1$hour,1,10)

head(df1)

dfx <- merge(x = df1, y = df2[ , c("u_id", "c_type", 
                                   "bs_days", "age", "age_cat", 
                                   "n_female", "n_open0", "n_bull", 
                                   "gpcln_bin", "axcln_bin", "lame")], 
             
             by = "u_id", all.x = TRUE)

df3 <- read.csv("042422.to_dat.CR04.csv")
df3m <- melt(df3, id.vars="date", variable.name = "u_id", value.name = "to_day_value")
df3m$u_id <- gsub("X","", df3m$u_id)
df3m$date <- gsub("/","-", df3m$date)  ### this line does not work, date matching only works when CSV date is in the right format

dfx2 <- merge(x = dfx, y = df3m, by = c("u_id", "date"), all.x = TRUE)


df4 <- read.csv("042422.lame_dat.CR04.csv")
df4m <- melt(df4, id.vars="date", variable.name = "u_id", value.name = "lame_day_value")
df4m$u_id <- gsub("X","", df4m$u_id)
df4m$date <- gsub("/","-", df4m$date) ### this line does not work, date matching only works when CSV date is in the right format

dfx3 <- merge(x = dfx2, y = df4m, by = c("u_id", "date"), all.x = TRUE)

write.csv(dfx3, "042422.datasummary_GPS_AX3.CR02.csv")
