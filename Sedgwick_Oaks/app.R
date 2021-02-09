<<<<<<< HEAD


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
                            sidebarPanel("Select Year",
                                         selectInput("select", label = h3("Select Year"),
                                                     choices = list("1938" = 1938, "1943" = 1943, "1954" = 1954,
                                                                    "1967" = 1967, "1980" = 1980, "1994" = 1994,
                                                                    "2004" = 2004, "2012" = 2012, "2014" = 2014,
                                                                    "2016" = 2016, "2018" = 2018, "2020" = 2020),
                                                     selected = 1),

                                         hr(),
                                         fluidRow(column(12, verbatimTextOutput("value")))

                            ),
                            mainPanel("Number of live individuals")
                        )
                        ),
               tabPanel("Widget 4",
                        sidebarLayout(
                            sidebarPanel("Select Time Period",
                                                  sliderInput("slider2", label = h3("Slider Range"), min = 1938,
                                                     max = 2020, value = c(1938, 2020), # sep = c(1938, 1943,
                                                        # 1954, 1967, 1980, 1994, 2004, 2012, 2014, 2016, 2018, 2020)),
                                                        format = "####"),

                                                      hr(),

                        fluidRow(
                          column(12, verbatimTextOutput("value")),
                          column(12, verbatimTextOutput("range"))
                        )
                            ),
                            mainPanel("Number of live individuals"))
)
)
)

# Define server
server <- function(input, output) {}


# Run the application
shinyApp(ui = ui, server = server)
=======


library(shiny)
library(tidyverse)
library(bslib)
library(here)

sedgwick <- read_csv(here("treedat_1220.csv"))

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
                            sidebarPanel("Select Year",
                                         checkboxGroupInput(inputId = "pick_year",
                                                            label = "Select study year:",
                                                            choices = unique(sedgwick$jan38))
                                         ),
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
>>>>>>> origin
