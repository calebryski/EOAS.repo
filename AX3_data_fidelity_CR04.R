library(dplyr)

setwd("F:")

# Listing all files that you want to analyse
files <- data.frame(input = list.files("AX3_copy/", full.name = TRUE),
                    output = paste0("Summarised", list.files("AX3_copy/", full.name = TRUE)))
files$ref <- gsub("AX3_copy/", "", files$input)
files$ref <- gsub(".csv", "", files$ref)

ref <- read.csv("032722.EOAS21.CR22.csv") %>%
  filter(axdn_dat != "-") %>%
  mutate(to_dat = as.Date(to_dat, format = "%m/%d/%Y"),######### must be %m/%d/%Y in American files, must be %d/%m/%Y in Australian files 
         eos_dat = as.Date(eos_dat, format = "%m/%d/%Y"),
         ref = paste0(ax_id, "_",bg ))

# Create an empty dataframe to bind final information
data <- data.frame()

# new for loop 

for(i in 1:nrow(files)){
  df <- read.csv(files$input[i],header = FALSE, row.names = NULL, col.names = c("datetime", "X", "Y", "Z"), nrows=10000) 

  # Subset data based on to_dat and eos_dat
  subset <- df %>%
      mutate(timestamp = as.POSIXct(strptime(df$datetime, format = "%Y-%m-%d %H:%M:%S", tz = "America/New_York")))%>%
      arrange(timestamp) %>%
      filter(between(timestamp, as.POSIXct(paste(ref$to_dat[i], "20:00:00")), as.POSIXct(paste(ref$eos_dat[i], "08:00:00"))))
  # Expected
  expected <- seq(from = as.POSIXct(paste(ref$to_dat[i], "20:00:00")), to = as.POSIXct(paste(ref$eos_dat[i], "08:00:00")), 
                      by = "8 sec") ##### needs to be 0.08 sec but cant figure that one out, based on my reading of seq, the lowest unit of time that it can use  
  expected <- length(expected)*100 #### fix for the above line problem
  
  # Accurate
  accurate <- nrow(subset)
  
  # Creating new dataframe to rbind back to empty 'data' dataframe
  clean <- data.frame(ref = ref[1], expected = expected, accurate = accurate)
  #    
  data <- rbind(data, clean)
}


# For loop
#for(i in 1:nrow(files)){
#  tryCatch({
#    df <- read.csv(files$input[i], fileEncoding = "UTF-16LE")
#    ref1 <- ref %>%
#      filter(ref == files$ref[i])
#    
#    # Subset data based on to_dat and eos_dat
#    subset <- df %>%
#      mutate(timestamp = as.POSIXct(paste0(Date, Time), format = "%Y/%m/%d %H:%M:%S")) %>%
#      arrange(timestamp) %>%
#      filter(between(timestamp, as.POSIXct(paste(ref1$to_dat[1], "20:00:00")), as.POSIXct(paste(ref1$eos_dat[1], "08:00:00"))))
#    
#    # Expected
#    expected <- seq(from = as.POSIXct(paste(ref1$to_dat[1], "20:00:00")), to = as.POSIXct(paste(ref1$eos_dat[1], "08:00:00")), 
#                    by = "0.08 sec")
#    expected <- length(expected)
#    
#    # Accurate
#    accurate <- nrow(subset)
#    
#    # Creating new dataframe to rbind back to empty 'data' dataframe
#    clean <- data.frame(ref = ref1$ref[1], expected = expected, accurate = accurate)
#    
#    data <- rbind(data, clean)
#  }, error=function(e){})
#}


################################################################################

df <- read.csv(files$input[1],header = FALSE, row.names = NULL, col.names = c("datetime", "X", "Y", "Z"), skip=20000000, nrows=10000)

#subset <- df %>%
#mutate(datetime = as.POSIXct(strptime(df$datetime, format = "%Y-%m-%d %H:%M:%S", tz = "America/New_York")))%>%
#arrange(datetime) %>%
#filter(between(timestamp, as.POSIXct(paste(ref$to_dat[39], "20:00:00")), as.POSIXct(paste(ref$eos_dat[39], "08:00:00"))))

x <- nrow(between(datetime, as.POSIXct(paste(ref$to_dat[39], "20:00:00")), as.POSIXct(paste(ref$eos_dat[39], "08:00:00"))))  


df <- read.csv(files$input[1],header = FALSE, row.names = NULL, col.names = c("datetime", "X", "Y", "Z"), skip=40000000, nrows=10000)


###########################################################################3

setwd("c:/work/EOAS21/ax3_sample")


file.pipe <- pipe("awk 'BEGIN{i=0}{i++;if (i%4==0) print $1}' < 72292_WCH.csv ")
res <- read.csv(file.pipe)
res

###############################################################################

library(bigmemory)
library(biganalytics)
library(lubridate)
library(dplyr)


setwd("C:/Work/EOAS21/ax3_sample")

df <- read.big.matrix("72292_WCH.csv", header = FALSE, 
                      row.names = NULL,
                      col.names = c("datetime", "X", "Y", "Z"))

df$timestamp = as.POSIXct(strptime(df$datetime, format = "%Y-%m-%d %H:%M:%S", tz = "America/New_York"))

mutate(df,timestamp = as.POSIXct(datetime), format = "%Y/%m/%d %H:%M:%S")

nrow(df)

head(df)


##################################################################################

##data.table
library(data.table)
input <- "https://raw.githubusercontent.com/Rdatatable/data.table/master/vignettes/flights14.csv"
flights<- fread(input)
head(flights)
?fread

DT = data.table(
  ID = c("b","b","b","a","a","c"),
  a = 1:6,
  b = 7:12,
  c = 13:18
)
DT

class(DT$ID)

class(DT$a)

ans <- flights[origin == "JFK" & month == 6L]
ans



#########################################################################
# data.table for my data
library(data.table)
setwd("c:/work/EOAS21/ax3_sample")
axd <- fread("72292_WCH.csv", header = FALSE, col.names = c("datetime", "X", "Y", "Z"))
axd  
class(axd$datetime)  
cut <- axd[datetime>as.POSIXct("2021-08-20 00:00:00")]
cut2 <- axd[datetime>as.POSIXct("2021-07-24 20:00:00") & datetime<as.POSIXct("2021-09-17 08:00:00")]  
cut2
cut3 <- axd[datetime>as.POSIXct("2021-07-23 20:00:00") & datetime<as.POSIXct("2021-07-24 20:00:01")]
cut3 ### this is a problem, this code cuts at 2021-07-25 00:00:00
###### IT WORKS ... ish #######



####FOR LOOP w/ data.table #########################################
library(dplyr)
library(data.table)

setwd("F:")

# Listing all files that you want to analyse
files <- data.frame(input = list.files("AX3_copy/", full.name = TRUE),
                    output = paste0("Summarised", list.files("AX3_copy/", full.name = TRUE)))
files$ref <- gsub("AX3_copy/", "", files$input)
files$ref <- gsub(".csv", "", files$ref)

ref <- read.csv("033022.EOAS21.CR26.csv") %>%
  filter(axdn_dat != "-") %>%
  filter(axdn_dat != "") %>%
  mutate(to_dat = as.Date(to_dat, format = "%m/%d/%Y"),######### must be %m/%d/%Y in American files, must be %d/%m/%Y in Australian files 
         eos_dat = as.Date(eos_dat, format = "%m/%d/%Y"),
         ref = paste0(ax_id, "_",bg ))

# Create an empty dataframe to bind final information
data <- data.frame()



for(i in 1:nrow(files)){
  df <- fread(files$input[1],header = FALSE, col.names = c("datetime", "X", "Y", "Z")) 
  
  # Subset data based on to_dat and eos_dat
  subset <- df[datetime>as.POSIXct(paste(ref$to_dat[1], "20:00:00")) & datetime<as.POSIXct(paste(ref$eos_dat[i], "08:00:00"))]
}
  # Expected
  expected <- seq(from = as.POSIXct(paste(ref$to_dat[1], "20:00:00")), to = as.POSIXct(paste(ref$eos_dat[i], "08:00:00")), 
                  by = "8 sec") ##### needs to be 0.08 sec but cant figure that one out, based on my reading of seq, the lowest unit of time that it can use  
  expected <- length(expected)*100 #### fix for the above line problem
  
  # Accurate
  accurate <- nrow(subset)
  
  # Creating new dataframe to rbind back to empty 'data' dataframe
  clean <- data.frame(ref = ref$ref[1], expected = expected, accurate = accurate)
  #    
  data <- rbind(data, clean)
}

i
#for(i in 1:nrow(files)){
#  df <- fread(files$input[i],header = FALSE, col.names = c("datetime", "X", "Y", "Z")) 
  
  # Subset data based on to_dat and eos_dat
#  subset <- df[datetime>as.POSIXct(paste(ref$to_dat[i], "20:00:00")) & datetime<as.POSIXct(paste(ref$eos_dat[i], "08:00:00"))]
  
  # Expected
#  expected <- seq(from = as.POSIXct(paste(ref$to_dat[i], "20:00:00")), to = as.POSIXct(paste(ref$eos_dat[i], "08:00:00")), 
#                  by = "8 sec") ##### needs to be 0.08 sec but cant figure that one out, based on my reading of seq, the lowest unit of time that it can use  
#  expected <- length(expected)*100 #### fix for the above line problem
  
  # Accurate
#  accurate <- nrow(subset)
  
  # Creating new dataframe to rbind back to empty 'data' dataframe
#  clean <- data.frame(ref = ref$ref[i], expected = expected, accurate = accurate)
  #    
#  data <- rbind(data, clean)
#}
  
  
  
  
  
  
