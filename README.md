
# maboxer

Mapbox from R. This an early effort to build a basic application that supports the full suite of mapbox features including premium tiles. This would allow R users to pipe data.frames containing spatial data directly into interactive maps.

## Installation

```r
devtools::install_github("karthik/mapboxer")
```

## Working example

```r
library(ecoengine)
library(dplyr)
library(mapboxer)
lynx <- ee_observations(genus = "lynx", georeferenced = TRUE) %>%
mapbox(lynx$data)
```

![Imgur](http://i.imgur.com/FmJkpuP.jpg)
