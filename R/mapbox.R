#' Mapbox Maps from R
#'
#' This function takes an input data.frame and writes out a html file containing a Mapbox map and all javascript dependencies.
#' @param df Input data.frame. Must contain fields called latitude and longitude
#' @param htmlfile Destination file name. Default is \code{index.html}
#' @importFrom dplyr count select filter mutate arrange left_join
#' @importFrom RColorBrewer brewer.pal
#' @export
#' @examples \dontrun{
#' library(ecoengine)
#' library(dplyr)
#' ee_observations(genus = 'lynx', georeferenced = TRUE) %>%
#' mapbox(.$data)
#' }
mapbox <- function(df, htmlfile = "index.html") {

if(!inherits(iris, "data.frame")) stop("Input must be a data.frame", .call = FALSE)
unique_species <- df %>%
count(scientific_name) %>%
arrange(desc(n))
scientific_name <- desc <- n <- begin_date <- marker_color <- latitude <- longitude <- description <- NULL
cols <- colorRampPalette(RColorBrewer::brewer.pal(11, "Spectral"))
colors <- cols(nrow(unique_species))
unique_species$marker_color <- colors
# Remove all the extra fields and only keep what goes in the geoJSON
filtered_df <- left_join(df, unique_species, by = "scientific_name")
filtered_df <- filtered_df %>%
  select("title" = scientific_name,
  	"description" = begin_date,
  	"marker-color" = marker_color,  # THis is for mapbox
  	 "url" = url,
  	 latitude,
  	 longitude)
# Soon I should add other mapbox options here
filtered_df$`marker-size` <- "small"

filtered_df <- filtered_df %>% mutate(description = sprintf("Collected on %s", description))
pos <- c(which(names(filtered_df) == "latitude"), which(names(filtered_df) == "longitude"))
leafletR::toGeoJSON(filtered_df, lat.lon = pos, name = "points", overwrite = TRUE)

file.create(htmlfile)
file1 <- system.file("index0.html", package = "mapboxer")
points <- "points.geojson"
file2 <- system.file("index1.html", package = "mapboxer")
fileConn <- file(htmlfile)
writeLines(c(readLines(file1), readLines(points), readLines(file2)), fileConn)
close(fileConn)
browseURL(htmlfile)
}
