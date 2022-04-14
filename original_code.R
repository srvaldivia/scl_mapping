
# load libraries ----------------------------------------------------------

library(tidyverse)
library(sf)
library(osmdata)
arcgisbinding::arc.check_product()


# get data ----------------------------------------------------------------

streets <- getbb("Santiago")%>%
  opq(timeout = 25 * 100) %>%
  add_osm_feature(key = "highway", 
                  value = c("motorway", "primary", 
                            "secondary")) %>%
  osmdata_sf()


small_streets <- getbb("Santiago")%>%
  opq(timeout = 25 * 100) %>%
  add_osm_feature(key = "highway", 
                  value = c("residential", "living_street",
                            "tertiary")) %>%  #"footway", "service", "unclassified",
  osmdata_sf()

waterway <- getbb("Santiago")%>%
  opq(timeout = 25 * 100) %>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()

water <- getbb("Santiago")%>%
  opq(timeout = 25 * 100) %>%
  add_osm_feature(key = "natural", value = "water") %>%
  osmdata_sf()



# testing vis -------------------------------------------------------------


# new_xlim <- st_bbox(streets$osm_lines)[c(1, 3)] + c(0.2, -0.2)
# new_xlim <- st_bbox(streets$osm_lines)[c(2, 4)] + c(0.2, -0.2)


ggplot() +
  geom_sf(data = streets$osm_lines,
          inherit.aes = FALSE,
          color = "#7fc0ff",
          size = .4,
          alpha = .8) +
  geom_sf(data = small_streets$osm_lines,
          inherit.aes = FALSE,
          color = "#ffbe7f",
          size = .2,
          alpha = .6) +
  geom_sf(data = river$osm_lines,
          inherit.aes = FALSE,
          color = "#ffbe7f",
          size = .2,
          alpha = .5) +
  coord_sf(xlim = c(-70.610, -70.710),
           ylim = c(-33.410, -33.510),
           expand = FALSE) +
  theme_void() +
  theme(
    plot.background = element_rect(fill = "#282828")
  )


ggsave("temp.tiff", dpi = 300)


arcgisbinding::arc.write(here::here("output_data", "gis_mapping.gdb", "main_streets"),
                         data = streets$osm_lines,
                         overwrite = TRUE)

arcgisbinding::arc.write(here::here("output_data", "gis_mapping.gdb", "small_streets"),
                         data = small_streets$osm_lines,
                         overwrite = TRUE)

# arcgisbinding::arc.write(here::here("output_data", "gis_mapping.gdb", "rivers_polygons"),
#                          data = water$osm_polygons,
#                          overwrite = TRUE)

arcgisbinding::arc.write(here::here("output_data", "gis_mapping.gdb", "rivers_polygons2"),
                         data = water$osm_multipolygons,
                         overwrite = TRUE)
