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
library(dplyr)
library(DT)

street_trees <- read_csv("street_trees.csv")

# Define UI for application that draws a histogram
ui <- fui <- dashboardPage(
    dashboardHeader(title = "Street trees"),
    
    dashboardSidebar(
        selectInput("centre", "Distance between trees (m)",
                     choices = list(7, 14, 28),
                    multiple = FALSE)
    ),
    
    dashboardBody(
        fluidRow(
            
            valueBoxOutput("treesBox"),
            
            valueBoxOutput("parkingspacesBox")
        ),
        
        fluidRow(
            
            leafletOutput("map")
        ),
        
        fluidRow(
            
            DTOutput("table")
        )
    )
)

server <- function(input, output, session) {
    
    st <- eventReactive(input$centre, {
        dplyr::filter(street_trees, centres == input$centre)
    })
    
    # output$treesBox <- renderValueBox(
    #     valueBox(
    #     "Number of trees",
    #     count(st()),
    #     icon = icon("tree"))
    # )
    
    #output$parkingspacesBox <- renderValueBox()
    
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(-0.94680369, 51.456922, zoom = 16) %>%
            addCircleMarkers(lat = ~y, lng = ~x, data = st(), radius = 1, color = "green")
    })
    
    output$table <- renderDT({st()})
}

shinyApp(ui, server)
