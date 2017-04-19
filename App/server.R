shinyServer(function(input,output,session){
  
  output$map <- renderLeaflet({
    palColor = colorFactor(c("blue", "red"),
                           domain = c("Above Average", "Below Average"))
    lands[[input$landmark]] %>%  
      filter(hour==input$bins) %>% 
      leaflet() %>% 
      setView(37.619, 55.750, 10) %>% 
      addTiles(urlTemplate = mapbox,
               attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>') %>%
      addMarkers(~Longitude, ~Lattitude,
                 clusterOptions = markerClusterOptions(disableClusteringAtZoom = 15,animate = TRUE))
    
  })
  
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

  #====================     Number of Records ===========================
  output$plothour1 = renderPlotly({
    (x_group_count %>% 
       ggplot(aes(y=count,x=as_factor(COUNTRY)))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Number of Records')+
       xlab('Country Name')+
       ggtitle('Number of Records by Country')) %>% 
      ggplotly
  })
  
  output$plothour2 = renderPlotly({
    (x_group_count %>% 
       mutate(percentage=100*count/Population) %>% 
       ggplot(aes(y=percentage,x=as_factor(COUNTRY)))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Number of Records/Population')+
       xlab('Country Name')+
       ggtitle('Proportion of Number of Records in Population by Country')) %>% 
      ggplotly
  })
  
  output$plothour3 = renderPlotly({
    (x_group_count %>% 
       mutate(percentage=count/gdp) %>% 
       ggplot(aes(y=percentage,x=as_factor(COUNTRY)))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Number of Records/Total GDP')+
       xlab('Country Name')+
       ggtitle('Number of Records to Total GDP by Country')) %>% 
      ggplotly
  })
  output$text = renderText({"aaaaaaaaaaaaaa"})
  
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

    output$russia_records <- renderPlotly({
    # generate bins based on input$bins from ui.R
    (russia_count %>% 
       ggplot(aes(y=count,x=Hour %>% as.character))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Number of Records')+
       xlab('Hour')+
       ggtitle('Number of Records across Time')) %>% 
      ggplotly
  })
  
  output$preImage <- renderImage({
    # When input$n is 3, filename is ./images/image3.jpeg
    filename <- normalizePath(file.path('./11',
                                        paste(input$bins3, '.png', sep='')))
    
    # Return a list containing the filename and alt text
    list(src = filename,
         alt = paste("Image number", input$bins3))
  }, deleteFile = FALSE)
  
  #=======================Accuracy plot in ME==========================
  output$ME_accuracy1 <- renderPlotly({
    (x_group_accuracy %>% 
       arrange(mean_Accuracy) %>% 
       ggplot(aes(y=mean_Accuracy,x=as_factor(COUNTRY)))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Mean Accuracy')+
       xlab('Country Name')+
       ggtitle('Mean Accuracy by Country')) %>% 
      ggplotly
  })
  
  output$ME_accuracy2 <- renderPlotly({
    (x_group_accuracy %>% 
       arrange(st_accuracy) %>% 
       ggplot(aes(y=st_accuracy,x=as_factor(COUNTRY)))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Standard Deviation of Accuracy')+
       xlab('Country Name')+
       ggtitle('Standard Deviation of Accuracy by Country')) %>% 
      ggplotly
  })
  
  output$ME_accuracy3 <- renderPlotly({
    (x_group_accuracy_sd %>% 
       ggplot(aes(y=st_accuracy,x=hour %>% as_factor))+
       geom_bar(stat="identity",fill='skyblue2')+
       coord_flip()+
       ylab('Standard Deviation of Accuracy')+
       xlab('Hour')+
       ggtitle('Standard Deviation of Accuracy across Time')) %>% 
      ggplotly
  })
  
#========================x_grounp_accuray with time====================================

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
#=========================Table=====================================
  output$table <- renderTable({
    reg %>% coeftest %>% as.table %>% as.data.frame %>% 
      spread(Var2,Freq)
    })
})