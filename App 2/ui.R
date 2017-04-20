shinyUI(dashboardPage(
 dashboardHeader(title = "SIGNAL MAP"),
 dashboardSidebar(
    tags$head(
       tags$style(HTML('.shiny-server-account { display: none; }'))
      ),
    
    sidebarMenu(
      menuItem("Introduction", tabName = "Intro", icon = icon("database")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Russian", tabName = "map", icon = icon("map")),
      menuItem("MidEast", tabName = "map1", icon = icon("map")),
      menuItem("Statistics", icon = icon("bar-chart-o"), tabName = "Checkin",
               menuSubItem("Accuracy in Mideast(ME)", tabName = "AME", icon = icon("database")),
               menuSubItem("Accuracy in Russian", tabName = "ARU", icon = icon("database")),
               menuSubItem("Number of Records in ME", tabName = "NRM", icon = icon("database"))
               )
      )
    ),
  
  ####################################Body#########################################################
  
  dashboardBody(
     tags$head(
       tags$link(rel = "stylesheet", type = "text/css", href = "CSS/style.css")),

###############################Russia #########################
    tabItems( 
    tabItem(tabName = "map",
      div(#class = "outer",
          leafletOutput("map", width = "100%", height = "100%"),  height = "500" , width = "100%"),
        absolutePanel(
          id = "hover_box",
          top = 60, right = 10,
          sliderInput(
                      "bins",
                      "Hour:",
                      min = 13,
                      max = 22,
                      value = 13,
                      animate = animationOptions(interval = 2000, loop = TRUE, playButton = "PLAY",
                                                 pauseButton = "PAUSE")

        ),
        textOutput(paste("IDs")),
        selectInput('landmark', 'landmarks', c('St. Basil\'s Cathedral
','Glavny Universalny Magazin','Moscow Metro
','Patriarch\'s Pond','Bolshoi Theatre
'))
      )),
    
###############################Mid East#########################      
      tabItem(tabName = "map1",
        div(#class = "outer",
            leafletOutput("map1", width = "100%", height = "100%"),  height = "500" , width = "100%"),
        absolutePanel(id = "hover_box",top = 60, right = 10,
                      sliderInput(
                                  "bins1",
                                  "Hour:",
                                  min = 0,
                                  max = 23,
                                  value = 0, 
                                  animate = animationOptions(interval = 500, loop = TRUE, playButton = "PLAY",
                                                             pauseButton = "PAUSE")
                      )
        )
      ),
    
######################### Table #############################
    
    tabItem(tabName = "data",
            navbarPage(id="nav-bar",
              title = 'DataTable Options',
              tabPanel('mideast_12_11',     DT::dataTableOutput('ex1')),
              tabPanel('mideast_12_12',        DT::dataTableOutput('ex2')),
              tabPanel('mideast_12_13',      DT::dataTableOutput('ex3')),
              tabPanel('russia_12_10',       DT::dataTableOutput('ex4')),
              tabPanel('russia_12_11',  DT::dataTableOutput('ex5'))
            )),

    
##########################Introduction ########################
      
      tabItem(tabName = "Intro",
              div(id = 'intro',
                  fluidRow(column(
                    12,
                    div(class = "imageContainer1",
                        img(src="img/shouji.jpg", height = 400, width = '100%')
                    )
                  )
                  ),
                  fluidRow(column(12,h1('Introduction'),
                                  h4(strong('Map (Russia):'), 'the moving pattern of the tourists in Moscow who went to one of the five landmarks.'),
                                  h4(strong('Map (Middle East):'), 'the change of the total number of mobile requests clustered in different countries on a hourly basis in Middle East.'),
                                  h4(strong('Map (Russia):'), 'the hourly change in mobile siganls in differnt areas across Russia as well as the moving pattern of certain groups across Russian landmarks'),
                                  h4(strong('Data:'), 'obtained from one group member\'s intern project, and is accessible from',a("here",href="https://drive.google.com/open?id=0Bxhza798zLVYU0dETV9wYTNVbTQ"),
                                     'Also used data from', a("World Population",href="http://www.worldometers.info/world-population/population-by-country"),
                                     'and GDP data from', a("World Bank",href="http://api.worldbank.org/v2/en/indicator/NY.GDP.MKTP.CD?downloadformat=csv")),
                                  h4(strong('Statistics:'), 'visulization of accuracy and the number of records using barcharts or map.')
                                  )))),
#=========================Statistics==========================           
    
    tabItem(tabName = "AME",
            sidebarLayout(
              sidebarPanel(
                sliderInput("bins4",
                            "Hour:",
                            min = 0,
                            max = 23,
                            value = 0, 
                            animate = animationOptions(interval = 300, loop = TRUE, playButton = "PLAY",
                                                       pauseButton = "PAUSE")
                ),width=12
              ),
              
              mainPanel(
                plotlyOutput("Plot2"),width=12
              )
            )

    ),    
    
#===========================Accuracy in RU ===========================
    tabItem(tabName = "ARU",
            sidebarLayout(
              sidebarPanel(
                sliderInput("bins3",
                            "Hour:",
                            min = 13,
                            max = 22,
                            value = 13, 
                            animate = animationOptions(interval = 800, loop = TRUE, playButton = "PLAY",
                                                       pauseButton = "PAUSE")
                ),width=12,tags$script("$(document).ready(function(){
                        setTimeout(function() {$('.slider-animate-button').click()},10);
                                       });")
                
              ),
              
              mainPanel(
                plotOutput("preImage"),
                width=12
              )
            )

    ),
#===============Number of Records in Mideast========================  
    tabItem(tabName = "NRM",
            sidebarLayout(
              sidebarPanel(
                sliderInput("bins2",
                            "Hour:",
                            min = 0,
                            max = 23,
                            value = 0, 
                            animate = animationOptions(interval = 300, loop = TRUE, playButton = "PLAY",
                                                       pauseButton = "PAUSE")
                ),width=12
              ),
              mainPanel(
                plotlyOutput("distPlot"),width=12
              )
            )
    )
    
#===============Number of Records in Russia========================

    ))))