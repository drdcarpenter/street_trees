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
library(readr)

street_trees <- read_csv("street_trees.csv")

# Define UI for application that draws a histogram
ui <- fui <- dashboardPage(
    dashboardHeader(title = "Street trees"),
    
    dashboardSidebar(
        radioButtons("centre", "Distance between trees (m)",
                     choices = list("7" = 1,
                                    "14" = 2,
                                    "28" = 3))
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
            setView(-0.94680369, 51.456922, zoom = 16) %>% 
            addCircleMarkers(lat = ~y, lng = ~x, data = street_trees, radius = 1, color = "green")
    })
}

shinyApp(ui, server)
