############################################
#Title: "World population density map using Leaflet"
############################################


#Load libraries
library(leaflet)
library(htmlwidgets)


#Load data set
dataset <- read.csv("C:/Users/Sakshi/Desktop/Projects/Population_Density_Data.csv", skip = 4)
dataset[, c("Indicator.Name", "Indicator.Code", "X1960", "X2016", "X")] <- NULL
dataset <- dataset[complete.cases(dataset), ]
dataset["avgPopulationDensity"] <- rowSums(dataset[,3:57])
head(dataset)

#Load in the world shape file and merge the two files.
shapes <- st_read("C:/Users/Sakshi/Desktop/Projects/countries.shp")
shapes <- merge(shapes, dataset, by.x = 'ISO3', by.y = 'Country.Code')


#Plot data
#Create a color palette where the countries with high average population density are depicted in Dark green.
colors <- c("#98FB98","#00A86B","#1A2421")
bins <- c(100000, 20000, 5000, 0)
c_pal <- leaflet::colorBin(colors, 
                          domain = shapes$avgPopulationDensity, 
                          bins = bins)

map = leaflet(shapes) %>% 
  addTiles() %>%
  setView(lat = 10, lng = 0, zoom = 1) %>%
  addPolygons(fillColor = ~c_pal(shapes$avgPopulationDensity),
              fillOpacity = 0.7,
              label = shapes$Country.Name,
              stroke = TRUE,
              color = 'black',
              weight = 1,
              opacity = 1)

#To save the map in html file
saveWidget(map, file="C:/Users/Sakshi/Desktop/Projects/PopulationDensityMap.html")

#Countries in Asia like Bangladesh, Korea, China, India, Japan and others have high population densities than other countries.

