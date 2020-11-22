#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(leaflet)

# Define UI for application that draws a histogram
ui <- fui <- dashboardPage(
    dashboardHeader(title = "Street trees"),
    
    dashboardSidebar(
        radioButtons("trees", "Number of trees",
                     choices = list("18" = 1,
                                    "35" = 2,
                                    "79" = 3))
    ),
    
    dashboardBody(
        fluidRow(
            
            valueBoxOutput("treesBox"),
            
            valueBoxOutput("parkingspacesBox")
        ),
        
        fluidRow(
            
            leafletOutput("map")
        )
    )
)

server <- function(input, output) {
    
    #output$treesBox <- renderValueBox()
    
    #output$parkingspacesBox <- renderValueBox()
    
    output$map <- renderLeaflet({
        leaflet() %>% 
            addTiles() %>% 
            setView(-0.94680369, 51.456922, zoom = 16)
    })
}

shinyApp(ui, server)
