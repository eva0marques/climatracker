#' List of all GHCND stations
#' @param destfile The path to store the data
#' @return A data frame with the list of all GHCND stations
#' @author Eva Marques
list_ghcnd_stations <- function(destfile) {
  # Download the AWS metadata
  url <- paste0("https://www.ncei.noaa.gov/data/",
                "global-historical-climatology-network-daily/doc/",
                "ghcnd-stations.txt")
  downloader::download(url = url,
                       destfile = destfile,
                       mode = "wb")
  x <- readr::read_fwf(destfile,
                       readr::fwf_widths(c(12, 9, 10, 7, 3, 31, 8, 5)))
  colnames(x) <- c("site_id",
                   "lat",
                   "lon",
                   "elevation",
                   "state",
                   "name",
                   "flag",
                   "code")
  return(x)
}

#' Download daily climatology of a station from
#' Global Historical Climatology Network - Daily (GHCND)
#' @param site_id The station ID
#' @param storage_path The path to store the data
#' @return A CSV file with the daily climatology
#' @author Eva Marques
download_ghcnd_climato <- function(site_id, storage_path) {
  # Create the URL
  url <- paste0("https://www.ncei.noaa.gov/data/",
                "global-historical-climatology-network-daily/access/",
                site_id,
                ".csv")
  if (RCurl::url.exists(url)){
    # Download the data
    destfile <- paste0(storage_path, "/", site_id, ".csv")
    downloader::download(url = url,
                         destfile = destfile,
                         mode = "wb")
  } else {
    warning("The URL does not exist for station ", site_id, ".")
  }
}

