# Air Quality data processing and cleaning function
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


# Min/Max pollutant concentraition table function
create_aq_table <- function(data, year, subtitle = NULL) {
  
  # Create data frame
  summary_data <- data.frame(
    # Create first column that stores pollutant and units
    Pollutant = c("CO (ppm)", "PM2.5 (µg/m³ LC)", paste0("O3 (", unique(na.omit(data$units_O3)), ")")),
    
    # Create column for minimum values
    Min = c(
      min(data$co_max8hr, na.rm = TRUE),
      min(data$pm25_mean, na.rm = TRUE),
      min(data$o3_max8hr, na.rm = TRUE)
    ),
    
    # Create column for maximum values
    Max = c(
      max(data$co_max8hr, na.rm = TRUE),
      max(data$pm25_mean, na.rm = TRUE),
      max(data$o3_max8hr, na.rm = TRUE)
    )
  )
  
  # Format the table
  summary_data %>%
    gt() %>%
    tab_header(
      # Add table title 
      title = paste(
        "Minimum and Maximum Daily Air Pollutant Concentrations,",
        year
      ),
      # Add optional subtitle if specified by function input
      subtitle = subtitle
    ) %>%
    # Round min/max values to three decimal places
    fmt_number(
      columns = c(Min, Max),
      decimals = 3
    )
}





