shinyServer(function(input,output,session){

###############################Russia Map#########################  
  output$map <- renderLeaflet({
    customIcon <- icons(
      iconUrl = "https://camo.githubusercontent.com/afa9cd3e3fde5e3768f0061f4a1d330d0cb25383/68747470733a2f2f7261772e6769746875622e636f6d2f706f696e7468692f6c6561666c65742d636f6c6f722d6d61726b6572732f6d61737465722f696d672f6d61726b65722d69636f6e2d626c75652e706e673f7261773d74727565",
      iconWidth = 20, iconHeight = 30,
      iconAnchorX = 20, iconAnchorY = 20
    )
    landmarkIcons <- icons(
      iconUrl = "https://camo.githubusercontent.com/70c53b19fb9ec32c09ff59b4aebe6bb8058dfb8b/68747470733a2f2f7261772e6769746875622e636f6d2f706f696e7468692f6c6561666c65742d636f6c6f722d6d61726b6572732f6d61737465722f696d672f6d61726b65722d69636f6e2d7265642e706e673f7261773d74727565",
      iconWidth = 20, iconHeight = 30,
      iconAnchorX = 20, iconAnchorY = 20
    )
    
    lands[[input$landmark]] %>%  
      filter(hour==input$bins) %>% 
      leaflet() %>% 
      setView(37.619, 55.750, 10) %>% 
      addTiles(urlTemplate = mapbox,
               attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
      addMarkers(~Longitude, ~Lattitude,
                 clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15,animate = TRUE),
                 icon = customIcon,
                 popup = ~ paste( sep = "<br/>",
                                  "<b>Description</b>",
                                  paste('<b>User ID : </b>', `User ID`,sep = ' '  ),
                                  paste('<b>Time Stamp :</b>', `Time Stamp`, sep = ' ')
                 )) %>% 
      addMarkers(~single[[input$landmark]][2],~single[[input$landmark]][1],
                 icon = landmarkIcons,
                 popup=~paste( sep = "<br/>",
                               "<b>Description</b>",
                               paste('<b>Landmark </b>', input$landmark ,sep = ' '  )))
  })
  
  output$IDs <- renderText({
    paste("The number of unique tourists is:",lands[[input$landmark]] %>%  
      filter(hour==input$bins) %>%
      .$`User ID` %>% as.vector %>% unique %>% length)
  })
  
###############################Mid East Map#########################    
  output$map1 <- renderLeaflet({ 
    pal <- colorBin("YlOrRd", domain = countries@data[paste0('count',input$bins1)] %>% as.matrix %>% as.vector, bins = bins)
    labels <- sprintf(
      "<strong>%s</strong><br/>%g people",
      countries$sovereignt, countries@data[paste0('count',input$bins1)] %>% as.matrix %>% as.vector
    ) %>% lapply(htmltools::HTML)
    m %>%
      addPolygons(
        fillColor = ~pal(countries@data[paste0('count',input$bins1)] %>% as.matrix %>% as.vector),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")
  })
######################### Data #############################  
  output$ex1 = DT::renderDataTable({
    datatable( 
      mideast_12_11,  rownames=FALSE) %>%
      formatStyle(input$selected,
                  background="skyblue", fontWeight='bold')
    
  })
  
  output$ex2 = DT::renderDataTable({
    datatable( 
      mideast_12_12,  rownames=FALSE) %>%
      formatStyle(input$selected,
                  background="skyblue", fontWeight='bold')
    
  })
  
  output$ex3 = DT::renderDataTable({
    datatable( 
      mideast_12_13,  rownames=FALSE) %>%
      formatStyle(input$selected,
                  background="skyblue", fontWeight='bold')
    
  })
  
  output$ex4 = DT::renderDataTable({
    datatable( 
      russia_12_10,  rownames=FALSE) %>%
      formatStyle(input$selected,
                  background="skyblue", fontWeight='bold')
    
  })
  
  output$ex5 = DT::renderDataTable({
    datatable( 
      russia_12_11,  rownames=FALSE) %>%
      formatStyle(input$selected,
                  background="skyblue", fontWeight='bold')})
  
  output$ex6 = DT::renderDataTable({
    datatable( 
      russia_12_12,  rownames=FALSE) %>%
      formatStyle(input$selected,
                  background="skyblue", fontWeight='bold')})
  

  ##########################Bar Charts ######################## 
  #===============Number of Records in Mideast========================  
  output$distPlot <- renderPlotly({
    # generate bins based on input$bins from ui.R
    (x_group_count_hour %>% 
       filter(Hour==input$bins2) %>% 
       ggplot(aes(y=count,x=ordered(COUNTRY,ord)))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Number of Records')+
       xlab('Country Name')+
       ylim(0,200000)+
       ggtitle(paste('Number of Records by Country at Hour',input$bins2))) %>% 
      ggplotly
  })
    #===========================Accuracy in RU ===========================  
  output$preImage <- renderImage({
    # When input$n is 3, filename is ./images/image3.jpeg
    filename <- normalizePath(file.path('./11',
                                        paste(input$bins3, '.jpg', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         alt = paste("Image number", input$bins3))
  }, deleteFile = FALSE)
  
  
    #=========================Accuracy in Mideast==========================  

  output$Plot2 <- renderPlotly({
    (x_group_accuracy_mean %>% 
       filter(Hour==input$bins4) %>% 
       ggplot(aes(y=mean_Accuracy,x=ordered(COUNTRY,ord2)))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Mean Accuracy')+
       xlab('Country Name')+
       ylim(0,5000)+
       ggtitle(paste('Mean Accuracy by Country at Hour',input$bins4))) %>% 
      ggplotly
  })

})