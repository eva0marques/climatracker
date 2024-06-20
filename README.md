# Climatracker

This repository provide R functions to quickly plot the temperature anomaly of any valid weather station of the [Global Historical Climatology Network daily (GHCNd)](https://www.ncei.noaa.gov/products/land-based-station/global-historical-climatology-network-daily) for a given year.

**Reference for GHCNd data:**  
Menne, M.J., I. Durre, B. Korzeniewski, S. McNeill, K. Thomas, X. Yin, S. Anthony, R. Ray, 
R.S. Vose, B.E.Gleason, and T.G. Houston, 2012: Global Historical Climatology Network - 
Daily (GHCN-Daily), Version 3. [indicate subset used following decimal, 
e.g. Version 3.12]. 
NOAA National Climatic Data Center. http://doi.org/10.7289/V5D21VHZ [access date]


#### Download and source functions

-   load_ghcnd_station.R

-   plot_anomaly.R

```{r}
source("load_ghcnd_station.R")
source("plot_anomaly.R")
```

#### Find nearest station of a given location

```{r}
mystation <- find_nearest_valid_ghcnd(lat = 35.8840, lon = -78.8778)
site_id <- mystation$nearest_tmax$site_id
```

#### Select a year

```{r}
year <- 2023
```

#### Plot anomaly

```{r}
p <- plot_anomaly(site_id, year)
p
```

#### Save in graphs/ folder

```{r, eval = FALSE}
ggsave(filename = paste0("graphs/anomaly_", site_id, "_", year, ".png"),
       plot = p,
       width = 10,
       height = 5,
       dpi = 300)
```
