
library(ggplot2)
plot_temperature <- function(site_id, year) {
  url <- paste0("https://www.ncei.noaa.gov/data/",
                "global-historical-climatology-network-daily/access/",
                site_id,
                ".csv")
  f <- read.csv(url)
  if ("TAVG" %in% colnames(f)) {
    f$TAVG <- 0.1*f$TAVG  # default unit is tenths of degree C
  }
  f$TMAX <- 0.1*f$TMAX  # default unit is tenths of degree C
  f$TMIN <- 0.1*f$TMIN  # default unit is tenths of degree C
  f$DATE <- as.Date(f$DATE, format = "%Y-%m-%d")
  # select observations of the year
  f <- f[which(lubridate::year(f$DATE) == year), ]
  f$yday <- lubridate::yday(f$DATE)

  if ("TAVG" %in% colnames(f)) {
    p_avg <- ggplot(f,
                    aes(x = DATE, y = TAVG)) +
      geom_line() +
      scale_x_date(date_labels = "%b", date_breaks = "1 month") +
      labs(title = paste0("TAVG for ", site_id, " in ", year),
           x = "",
           y = "Temperature (°C)") +
      theme_minimal() +
      theme(legend.position = "none") 
  }
  
  p_min <- ggplot(f,
                  aes(x = DATE, y = TMIN)) +
    geom_line() +
    geom_hline(yintercept = 20, linetype = "dashed", color = "red") +
    geom_hline(yintercept = -10, linetype = "dashed", color = "blue") +
    scale_x_date(date_labels = "%b", date_breaks = "1 month") +
    labs(title = paste0("TMIN for ", site_id, " in ", year),
         x = "",
         y = "Temperature (°C)") +
    theme_minimal() +
    theme(legend.position = "none") 
  

  p_max <- ggplot(f,
                  aes(x = DATE, y = TMAX)) +
    geom_line() +
    geom_hline(yintercept = 35, linetype = "dashed", color = "red") +
    geom_hline(yintercept = 0, linetype = "dashed", color = "blue") +
    scale_x_date(date_labels = "%b", date_breaks = "1 month") +
    labs(title = paste0("TMAX for ", site_id, " in ", year),
         x = "",
         y = "Temperature (°C)") +
    theme_minimal() +
    theme(legend.position = "none") 
  
  if ("TAVG" %in% colnames(f)) {
    p <- ggpubr::ggarrange(p_avg, p_min, p_max, nrow = 3)
  } else {
    p <- ggpubr::ggarrange(p_min, p_max, nrow = 2)
  }
  p
  return(p)
}
