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
        
        h2("Instructions"),
        p("Use the drop down menu below to select the distance between street trees to be planted."),
        
        selectInput("centre", "Distance between trees (m)",
                     choices = list(7, 14, 28),
                    multiple = FALSE),
        
        p("The recommended minimum distance between trees is 7 metres.  You can also plant fewer trees further apart."),
        p("The map, boxes and table to the right will update as you change the number of street trees.")
    ),
    
    dashboardBody(
        fluidRow(
            
            h1("Planting street trees in Liverpool Road, Reading, UK"),
            p("Trees provide people with multiple benefits, from storing and absorbing carbon, to removing pollution from the air.  Liverpool Road, Reading, has two existing street trees, but it is possible to plant more to help improve the local environment."),
            p("This app shows where those trees could be planted and the benefits they would provide to residents by sequestering and storing carbon and removing air pollution."),
            
            h2("Trees and parking"),
            p("Planting trees in the street will use up some parking spaces.  The boxes below show how many trees and parking spaces would result from different planting distances."),
            valueBoxOutput("treesBox"),
            
            valueBoxOutput("parkingspacesBox")
        ),
        
        fluidRow(
            
            h2("Indicative positions of street trees"),
            p("The map shows indicative positions for street trees.  In reality some of these locations would not be appropriate, but the map gives an idea of the density of tree planting using the different distances between trees."),
            
            leafletOutput("map")
        ),
        
        fluidRow(
            
            h2("Benefits of street trees"),
            p("The boxes below shows how much carbon would be stored and sequestered, and how much pollution would be removed, by the number of trees shown in the 'tree' box above."),
            
            # tableOutput("table"),
            
            valueBoxOutput("carbonstore"),
            
            valueBoxOutput("carbonsequestered"),
            
            valueBoxOutput("pollution")
            
        ),
        
        fluidRow(
            
            p("Further information on this app and the calculations behind it can be found on my website.")
        )
    )
)

server <- function(input, output, session) {
    
    st <- eventReactive(input$centre, {
        dplyr::filter(street_trees, centres == input$centre)
    })
    

    sts <- eventReactive(input$centre, {
        filter(street_trees, centres == input$centre) %>%
            summarise(`Carbon stored (kg)` = sum(Carbon_Storage_kg),
                      `Carbon Sequestered (kg/yr)` = sum(Carbon_Sequestration_kg_yr),
                      `Pollution Removed (g/yr)` = sum(Pollution_Removal_g_yr))
    })
    
    output$treesBox <- renderValueBox(
        valueBox(
        "Number of trees",
        count(st()),
        icon = icon("tree"),
        color = "green")
    )
    
    #output$parkingspacesBox <- renderValueBox()
    
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles() %>%
            setView(-0.94680369, 51.456922, zoom = 16) %>%
            addCircleMarkers(lat = ~y, lng = ~x, data = st(), radius = 1, color = "green")
    })
    
    # output$table <- renderTable({sts()}, bordered = TRUE,  
    #                             spacing = 'm',  
    #                             width = '75%', align = 'l',  
    #                             digits = 2)
    
    output$carbonstore <- renderValueBox(
        valueBox(
            "Carbon stored (kg)",
            sts()$`Carbon stored (kg)`,
            icon = icon("leaf"),
            color = "blue")
    )
    
    output$carbonsequestered <- renderValueBox(
        valueBox(
            "Carbon sequestered (kg/yr)",
            sts()$`Carbon Sequestered (kg/yr)`,
            icon = icon("sun"),
            color = "light-blue")
    )
    
    output$pollution <- renderValueBox(
        valueBox(
            "Pollution removed (g/yr)",
            sts()$`Pollution Removed (g/yr)`,
            icon = icon("industry"),
            color = "red")
    )
    
    
}

shinyApp(ui, server)
