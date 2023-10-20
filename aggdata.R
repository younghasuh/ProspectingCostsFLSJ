library(data.table)
library(sf)

agg <- read_excel("2019_AggData.xlsx")
#colnames(agg)[8] ="time"
agg2 <- agg %>% 
  dplyr::select(DATE, PointID, X, Y, JayID, Terr, MarTerr) %>% 
  mutate(date = DATE,
         pointid = PointID,
         x = X,
         y = Y,
         jayid = JayID,
         terr = Terr,
         marterr = MarTerr) %>% 
  dplyr::select(date, pointid, x, y, jayid, terr, marterr)



# read terr files again
terrs <- read_sf("abs_fsj_t2019_p.shp")
st_crs(terrs) # missing CRS!

test <- read_sf(dsn=here::here("shpfiles", "abs_fsj_t2021_p.shp"))
st_crs(test) #3857

# give this CRS to the 2019 terrs
terrs <- terrs %>% sf::st_set_crs(3857)
st_crs(terrs)

pts <- st_as_sf(agg2, coords=c("x", "y"), crs=3857)
st_crs(pts)
plot(pts)


# method 1
library(rgeos)
apply(gDistance(pts), terrs, min)

dists <- st_distance(pts, terrs)

