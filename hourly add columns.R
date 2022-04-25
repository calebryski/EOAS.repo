library(dplyr)
library(lubridate)
library("stringr")

setwd("C:/Users/rykaczewski.2/OneDrive - The Ohio State University/Caleb Rykaczewski/Projects/EOAS 2021/data sheet versions")

df2 <- read.csv("042222.EOAS21.CR29.csv")

df1 <- read.csv("041222.datasummary_GPS_AX3.AC01.csv")

df1$hours <- str_sub(df1$hour,-8,-7)

head(df1)

dfx <- merge(x = df1, y = df2[ , c("u_id", "c_type", 
                                   "bs_days", "age", "age_cat", 
                                   "n_female", "n_open0", "n_bull", 
                                   "gpcln_bin", "axcln_bin", "lame")], 
             
             by = "u_id", all.x = TRUE)








