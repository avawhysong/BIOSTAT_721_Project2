clean_aq_data <- function(file_path, units_O3 = "ppm") {
  # Read in data
  aq_data <- read.csv(file_path)
  
  aq_data <- aq_data %>%
    # Rename pollutant concentration columns
    rename(
      co_max8hr = Daily.Max.8.hour.CO.Concentration,
      pm25_mean = Daily.Mean.PM2.5.Concentration,
      o3_max8hr = Daily.Max.8.hour.Ozone.Concentration
    ) %>%
    
    # Convert Date to Date class
    mutate(Date = mdy(Date))
  
  # Identify pollutant concentration variables
  pollutants <- c("co_max8hr", "pm25_mean", "o3_max8hr")
  
  # Replace negative concentrations with zero
  aq_data[pollutants] <- lapply(
    aq_data[pollutants],
    function(x) ifelse(x < 0, 0, x)
  )
  
  # Remove duplicate rows
  aq_data <- aq_data %>% 
    distinct()
  
  # Calculate daily average concentrations
  aq_data <- aq_data %>%
    group_by(Date) %>%
    mutate(
      across(
        all_of(pollutants),
        ~ ifelse(all(is.na(.x)), NA_real_, mean(.x, na.rm = TRUE))
      )
    ) %>%
    distinct(Date, .keep_all = TRUE) %>%
    ungroup()
  
  # Convert O3 units to ppb (if specified over ppm) 
  if (units_O3 == "ppb") {
    aq_data$o3_max8hr <- aq_data$o3_max8hr * 1000
    aq_data$units_O3 <- "ppb"
  }
  
  # Return final dataset
  return(aq_data)

}


