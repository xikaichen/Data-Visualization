shinyUI(dashboardPage(
 dashboardHeader(title = "SIGNAL MAP"),
 dashboardSidebar(
    tags$head(
       tags$style(HTML('.shiny-server-account { display: none; }'))
      ),
    
    sidebarMenu(
      menuItem("Introduction", tabName = "Intro", icon = icon("database")),
      menuItem("Russian", tabName = "map", icon = icon("map")),
      menuItem("MidEast", tabName = "map1", icon = icon("map")),
      menuItem("Data", tabName = "data", icon = icon("database")),
      menuItem("Statistics", icon = icon("bar-chart-o"), tabName = "Checkin",
               menuSubItem("Accuracy in Mideast", tabName = "AME", icon = icon("database")),
               menuSubItem("Accuracy in Russian", tabName = "ARU", icon = icon("database")),
               menuSubItem("Number of Records in Mideast", tabName = "NRM", icon = icon("database")),
               menuSubItem("Number of Records in Russian", tabName = "NRR", icon = icon("database")))
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
                  fluidRow(column(12,
                      HTML("<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
            <ul class='imageContainer'>
                          <li></li>
                           <li></li>
                           <li></li>
                           <li></li>
                           <li></li>
                           </ul>"))
                  ),
                  fluidRow(column(12,h1('Introduction'),
                                  h4(strong('MobileSignal is an online mobile signal tracking site, with main focus on Middle East and Russia. It lists mobile usage records across time for three days in a row both in Middle East and Russia as well as tools and information needed to be able to have a comprehensive understanding of the variations across countries or 
                                             areas respectively.')),
                                  h4('Map (Middle East): the change of the total number of mobile requests clustered in different countries on a hourly basis in Middle East.'),
                                  h4('Map (Russia): the hourly change in mobile siganls in differnt areas across Russia as well as the moving pattern of certain groups across Russian landmarks'),
                                  h4('Data: obtained from one group member\'s intern project, and is accessible from',a("here",href="https://drive.google.com/open?id=0Bxhza798zLVYU0dETV9wYTNVbTQ"),
                                     'Also used data from', a("World Population",href="http://www.worldometers.info/world-population/population-by-country"),
                                     'and GDP data from', a("World Bank",href="http://api.worldbank.org/v2/en/indicator/NY.GDP.MKTP.CD?downloadformat=csv")),
                                  h4('Statistics: analysis of original records using histograms.')
                                  )))),
#=========================Statistics==========================           
    
    tabItem(tabName = "AME",
            fluidRow(box(plotlyOutput('ME_accuracy1'),width = 12)),
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
            ),
            fluidRow(box(plotlyOutput('ME_accuracy2'),width = 12)),
            fluidRow(box(plotlyOutput('ME_accuracy3'),width = 12))
            
    ),    
    
#===========================Accuracy in RU ===========================
    tabItem(tabName = "ARU",
            fluidRow(column(2,tableOutput('table')),width=12),
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
              
              # Show a plot of the generated distribution
              mainPanel(
                plotOutput("preImage"),
                width=12
              )
            )
            
    ),
#===============Number of Records in Mideast========================  
    tabItem(tabName = "NRM",
            fluidRow(box(plotlyOutput('plothour1'),width = 12)),
            fluidRow(box(verbatimTextOutput('text'),width = 12)),
            fluidRow(box(plotlyOutput('plothour2'),width = 12)),
            fluidRow(box(plotlyOutput('plothour3'),width = 12)),
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
    ),
    
#===============Number of Records in Russia========================
 
 tabItem(tabName = "NRR",
    fluidRow(box(plotlyOutput('russia_records'),width = 12))        
  )
    ))))