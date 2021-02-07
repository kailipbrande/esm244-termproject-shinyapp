

library(shiny)
library(tidyverse)

# Define UI for our application
ui <- fluidPage(

    navbarPage("Sedgwick Oaks",
               tabPanel("Overview"),
               tabPanel("Widget 1",
                        sidebarLayout(
                            sidebarPanel("Species"),
                            mainPanel("2020 Distribution")
                        )
                        ),
               tabPanel("Widget 2",
                        sidebarLayout(
                            sidebarPanel("Select Year"),
                            mainPanel("Species Distribution")
                        )
                        ),
               tabPanel("Widget 3",
                        sidebarLayout(
                            sidebarPanel("Select Year"),
                            mainPanel("Number of live individuals")
                        )
                        ),
               tabPanel("Widget 4",
                        sidebarLayout(
                            sidebarPanel("Select time period"),
                            mainPanel("Number of live individuals")
                        )
                        )

    )
)

# Define server
server <- function(input, output) {}


# Run the application
shinyApp(ui = ui, server = server)
