

library(shiny)
library(tidyverse)
library(bslib)

sedgwick_theme <- bs_theme(
  bg = "white",
  fg = "#1E8449",
  primary = "#F39C12",
  base_font = font_google("Noto Sans")
)

# Define UI for our application
ui <- fluidPage(theme = sedgwick_theme,

    navbarPage("Sedgwick Oaks",
               tabPanel("Overview",
                        sidebarLayout(
                          sidebarPanel("This dataset is sourced from UCSB's Sedgwick Reserve,
                                       accessed with permission from professor Frank Davis at
                                       the La Kretz Research Center. This is a long-term dataset
                                       spanning over 80 years, containing demographic information
                                       about Sedgwick's resident oak population from 1938-2020."),
                          mainPanel(
                        img(src = "sedgwickmap1.jpg", height = '500px', width = '800px')
                          )
                        )
                        ),
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
