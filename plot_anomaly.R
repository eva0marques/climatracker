
library(ggplot2)
plot_anomaly <- function(site_id, year) {
  url <- paste0("https://www.ncei.noaa.gov/data/",
                "global-historical-climatology-network-daily/access/",
                site_id,
                ".csv")
  f <- read.csv(url)
  f$TAVG <- 0.1*f$TAVG  # default unit is tenths of degree C
  f$TMAX <- 0.1*f$TMAX  # default unit is tenths of degree C
  f$TMIN <- 0.1*f$TMIN  # default unit is tenths of degree C
  f$DATE <- as.Date(f$DATE, format = "%Y-%m-%d")
  f$yday <- lubridate::yday(f$DATE)
  
  # compute yday normals on 1991-2020 
  norm <- c(as.Date("1991-01-01"), as.Date("2020-12-31"))
  yday_norm <- f[which(dplyr::between(f$DATE, norm[1], norm[2])),
                 c("yday", "TMAX", "TMIN", "TAVG")] |>
    dplyr::group_by(yday) |>
    dplyr::summarise(TMAX_norm = mean(TMAX, na.rm = TRUE),
                     TMIN_norm = mean(TMIN, na.rm = TRUE),
                     TAVG_norm = mean(TAVG, na.rm = TRUE)) |>
    dplyr::ungroup() |>
    as.data.frame()
  
  # compute yday anomalies on year passed in argument
  yday_year <- f[which(lubridate::year(f$DATE) == year), ]
  yday_year$yday <- lubridate::yday(yday_year$DATE)
  yday_year <- merge(yday_year, yday_norm, by = "yday")
  yday_year$TMAX_anom <- yday_year$TMAX - yday_year$TMAX_norm
  yday_year$TMIN_anom <- yday_year$TMIN - yday_year$TMIN_norm
  yday_year$TAVG_anom <- yday_year$TAVG - yday_year$TAVG_norm
  
  yday_year$col <- ifelse(yday_year$TMIN_anom > 0,
                          "TMIN > TMIN_norm",
                          "TMIN <= TMIN_norm")
  p_min <- ggplot(yday_year,
                  aes(x = DATE, y = TMIN_anom, fill = col)) +
    geom_bar(stat = "identity", width = 1) +
    scale_x_date(date_labels = "%b", date_breaks = "1 month") +
    scale_fill_manual(values = c("TMIN > TMIN_norm" = "red",
                                  "TMIN <= TMIN_norm" = "navy")) +
    labs(title = paste0("TMIN anomaly for ", site_id, " in ", year),
         x = "",
         y = "Temperature anomaly (°C)",
         caption = expression(italic('Reference period: 1991-2020.'))) +
    theme_minimal() +
    theme(legend.position = "none") 
  
  yday_year$col <- ifelse(yday_year$TMAX_anom > 0,
                          "TMAX > TMAX_norm",
                          "TMAX <= TMAX_norm")
  p_max <- ggplot(yday_year,
                   aes(x = DATE, y = TMAX_anom, fill = col)) +
    geom_bar(stat = "identity", width = 1) +
    scale_x_date(date_labels = "%b", date_breaks = "1 month") +
    scale_fill_manual(values = c("TMAX > TMAX_norm" = "red",
                                  "TMAX <= TMAX_norm" = "navy")) +
    labs(title = paste0("TMAX anomaly for ", site_id, " in ", year),
         x = "",
         y = "Temperature anomaly (°C)",
         caption = expression(italic('Reference period: 1991-2020.'))) +
    theme_minimal() +
    theme(legend.position = "none") 
  
  p <- ggpubr::ggarrange(p_min, p_max, nrow = 2)
  p
  return(p)
}
