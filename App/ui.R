shinyUI(dashboardPage(
 dashboardHeader(title = "Mobile Signal Quest"),
 dashboardSidebar(
    tags$head(
       tags$style(HTML('.shiny-server-account { display: none; }'))
      ),
    
    sidebarMenu(
      menuItem("Introduction", tabName = "Intro", icon = icon("database")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Number of Records in Mideast", tabName = "map1", icon = icon("map")),
      menuItem("Number of Records in Mideast", tabName = "NRM", icon = icon("bar-chart-o")),
      menuItem("Mean Accuracy in Mideast", tabName = "AME", icon = icon("bar-chart-o")),
      menuItem("Accuracy in Russian", tabName = "ARU", icon = icon("map")),
      menuItem("Internet Request in Moscow", tabName = "map", icon = icon("map"))
      )
    ),
  
  ####################################Body#########################################################
  
  dashboardBody(
     tags$head(
       tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css")),

###############################Russia Map#########################
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
    
###############################Mid East Map#########################      
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
    
######################### Data #############################
    
    tabItem(tabName = "data",
            navbarPage(id="nav-bar",
              title = 'DataTable Options',
              tabPanel('mideast_12_11',     DT::dataTableOutput('ex1')),
              tabPanel('mideast_12_12',        DT::dataTableOutput('ex2')),
              tabPanel('mideast_12_13',      DT::dataTableOutput('ex3')),
              tabPanel('russia_12_10',       DT::dataTableOutput('ex4')),
              tabPanel('russia_12_11',  DT::dataTableOutput('ex5')),
              tabPanel('russia_12_12',  DT::dataTableOutput('ex6'))
            )),

    
##########################Introduction ########################
      
      tabItem(tabName = "Intro",
              div(id = 'intro',
                  fluidRow(column(
                    12,
                    div(class = "imageContainer1",
                        img(src="img/shouji.jpg", height = 450)
                    )
                  )
                  ),
                  fluidRow(column(9,h1('Introduction'),
                                  h4('Mobile Signal Quest is an online mobile signal tracking site, with main focus on Middle East and Russia. It lists mobile usage records across time for three days in a row both in Middle East and Russia as well as tools and information needed to be able to have a comprehensive understanding of the variations across countries or areas respectively.'),
                                  h4(strong('Data:'), 'This is a data set of mobile signal data. It contains two parts, the first is from 22 countries in the Middle East during Dec 10-13 2016, and the second is from Russia during Dec 10-12. It is obtained from one group member\'s intern project, and is accessible from',a("here",href="https://drive.google.com/open?id=0Bxhza798zLVYU0dETV9wYTNVbTQ"),
                                     '. Also used data from', a("World Population",href="http://www.worldometers.info/world-population/population-by-country"),
                                     'and GDP data from', a("World Bank",href="http://api.worldbank.org/v2/en/indicator/NY.GDP.MKTP.CD?downloadformat=csv")),
                                  h4(strong('Barchart (Number of Records in Mideast):'), 'the change of the total number of mobile requests group by different countries on a hourly basis in Middle East.'),
                                  h4(strong('Map (Number of Records in Mideast):'), 'the change of the total number of mobile requests clustered in different countries on a hourly basis in Middle East.'),
                                  h4(strong('Barchart (Mean Accuarcy in Mideast):'), 'the change of the mean accuracy of mobile requests group by different countries on a hourly basis in Middle East.'),
                                  h4(strong('Map (Accuracy in Russia):'), 'the hourly change in mobile siganls in differnt areas across Russia'),
                                  h4(strong('Map (Internet Request Motion in Moscow):'), 'the moving pattern of the tourists in Moscow who went to one of the five landmarks.')
                                  )))),
##########################Bar Charts ########################

#=========================Accuracy in Mideast==========================           
    
    tabItem(tabName = "AME",
            sidebarLayout(
              sidebarPanel(
                sliderInput("bins4",
                            "Hour:",
                            min = 0,
                            max = 23,
                            value = 0, 
                            animate = animationOptions(interval = 800, loop = TRUE, playButton = "PLAY",
                                                       pauseButton = "PAUSE")
                ),width=12,tags$script("$(document).ready(function(){
                        setTimeout(function() {$('#shiny-tab-AME .slider-animate-button').click()},10);
                                       });")
              ),
              
              mainPanel(
                plotlyOutput("Plot2",width = "100%", height = "100%")
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
                        setTimeout(function() {$('#shiny-tab-ARU .slider-animate-button').click()},10);
                                       });")
                
              ),
              
              mainPanel(
                plotOutput("preImage",width = "100%", height = "100%")
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
                            animate = animationOptions(interval = 800, loop = TRUE, playButton = "PLAY",
                                                       pauseButton = "PAUSE")
                ),width=12,tags$script("$(document).ready(function(){
                        setTimeout(function() {$('#shiny-tab-NRM .slider-animate-button').click()},10);
                                       });")
              ),
              mainPanel(
                plotlyOutput("distPlot",width = "100%", height = "100%")
              )
            )
    )

    ))))