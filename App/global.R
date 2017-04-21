library(tidyverse)
library(leaflet)
library(htmltools)
library(shinydashboard)
library(shiny)
library(RColorBrewer)
library(ggvis)
library(googleVis)
library(plotly)
library(forcats)
library(knitr)
library(DT)
#===============================Load Data===================
mapbox <- 'https://api.mapbox.com/styles/v1/mapbox/streets-v10/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiemhpcnVpIiwiYSI6ImNqMTZ6c3oxZzAzbmYyeW82bzZxb3ZsdXYifQ.PvdwBdaB6Lk7447AJwZs9w'
load('motion.RData')
load('data.RData')
load('x_group_count.RData')
load('x_group_accuracy.RData')

#======================Data Processing=====================
lands <- new.env()
ids <- list(cathedral,GUM,metro,pond,theatre)
name <- c('St. Basil\'s Cathedral
','Glavny Universalny Magazin','Moscow Metro
','Patriarch\'s Pond','Bolshoi Theatre
')
for(i in 1:5){
  lands[[name[i]]] <- motion %>% 
    filter(`User ID` %in% ids[[i]])
}
single <- list('St. Basil\'s Cathedral
'=c(55.752500,37.623084),
               'Glavny Universalny Magazin'=c(55.754691,37.621490),
               'Moscow Metro
'=c(55.756497,37.621610),
               'Patriarch\'s Pond'=c(55.763920,37.592028),
               'Bolshoi Theatre
'=c(55.760209,37.618606))

countries <- geojsonio::geojson_read("countries.geojson", what = "sp")
for(i in 0:23){
  load('x.RData')
  x <- x %>% 
    filter(Hour==i) %>% 
    as.data.frame() %>% 
    select(-Hour) %>% 
    setNames(c('COUNTRY',paste0('count',i)))
  countries@data <- countries@data %>% 
    left_join(x,by=c("iso_a2"='COUNTRY'))
}

bins <- c(0, 50, 100, 500, 1000, 5000, 10000, 50000, 100000, Inf)

m <- leaflet(countries) %>%
  setView(42.17041, 20, 4) %>%
  addProviderTiles("Esri.WorldTopoMap")

ord <- x_group_count$COUNTRY
ord1 <- x_group_count$COUNTRY
ord2 <- x_group_accuracy$COUNTRY

