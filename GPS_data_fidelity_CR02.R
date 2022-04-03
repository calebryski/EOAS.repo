library(dplyr)
library(geosphere)

setwd("C:/Work/EOAS21")

# Listing all files that you want to analyse
files <- data.frame(input = list.files("GPSdataCOPY/", full.name = TRUE),
                    output = paste0("Summarised", list.files("GPSdataCOPY/", full.name = TRUE)))
files$ref <- gsub("GPSdataCOPY/EOAS21.", "", files$input)
files$ref <- gsub(".csv", "", files$ref)

ref <- read.csv("032722.EOAS21.CR22.csv") %>%
  filter(gpdn_dat != "-") %>%
  mutate(to_dat = as.Date(to_dat, format = "%m/%d/%Y"),######### must be mdy in American files, must be dmy in Australian files 
         eos_dat = as.Date(eos_dat, format = "%m/%d/%Y"),
         gpdn_dat = as.Date(gpdn_dat, format = "%m/%d/%Y"),
         ref = paste0(gp_id, ".", strftime(gpdn_dat, format = "%m%d%y")))

# Create an empty dataframe to bind final information
data <- data.frame()

# For loop
for(i in 1:nrow(files)){
  tryCatch({
    df <- read.csv(files$input[i], fileEncoding = "UTF-16LE")
  ref1 <- ref %>%
    filter(ref == files$ref[i])
  
  # Subset data based on to_dat and eos_dat
  subset <- df %>%
    mutate(timestamp = as.POSIXct(paste0(Date, Time), format = "%Y/%m/%d %H:%M:%S")) %>%
    arrange(timestamp) %>%
    filter(between(timestamp, as.POSIXct(paste(ref1$to_dat[1], "20:00:00")), as.POSIXct(paste(ref1$eos_dat[1], "08:00:00"))))
  
  # Looking for rows with latitude = 0 and longitude = 0
  latlong0 <- subset %>%
    filter(Latitude == 0, Longitude == 0)
  latlong0 <- nrow(latlong0)
  
  # Clean data
  subset <- subset %>%
    filter(Latitude != 0, Longitude != 0)
  inaccurate <- subset %>%
    mutate(distance = distHaversine(cbind(Longitude, Latitude), cbind(lag(Longitude), lag(Latitude))),
           speed = distance/as.numeric(timestamp - lag(timestamp))) %>%
    filter(speed > 5.39)
  inaccurate <- nrow(inaccurate)
  
  # Expected
  expected <- seq(from = as.POSIXct(paste(ref1$to_dat[1], "20:00:00")), to = as.POSIXct(paste(ref1$eos_dat[1], "08:00:00")), 
                  by = "7 mins")
  expected <- length(expected)
  
  # Accurate
  accurate <- nrow(subset) - latlong0 - inaccurate
  
  # Creating new dataframe to rbind back to empty 'data' dataframe
  clean <- data.frame(ref = ref1$ref[1], expected = expected, accurate = accurate, latlong0 = latlong0, inaccurate = inaccurate)
  
  data <- rbind(data, clean)
  }, error=function(e){})
}

ref <- read.csv("032122.EOAS21.CR20.csv") %>%
  mutate(ref = paste0(gp_id, ".", strftime(as.Date(gpdn_dat, format = "%d/%m/%Y"), format = "%m%d%y")))
ref <- merge(ref, data, by = "ref", all = TRUE)
ref <- ref[,-1]
write.csv(ref, "GPS_data_recovery.csv", row.names = FALSE)




