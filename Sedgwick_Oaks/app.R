
# =======
library(shiny)
library(tidyverse)
library(bslib)
library(here)

source(here("treedatawrangling.R"))



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
                            sidebarPanel("Species",
                                         radioButtons(inputId = "select_species", label = "Select Species:",
                                                      choices = list( "QULO", "QUDO", "QUAG"),
                                                      selected = 1)),
                            mainPanel("2020 Distribution",
                                      plotOutput(outputId = "species_plot")),
                        )
                        ),
                tabPanel("Widget 2",
                        sidebarLayout(
                            sidebarPanel("Select Year",
                                         checkboxGroupInput(inputId = "pick_year",
                                                            label = "Select study year:",
                                                            choices = unique(tree_pivot$year))
                                         ),
                            mainPanel("Species Distribution",
                                      plotOutput("widget2plot"))
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
                                                  sliderInput(inputId = "slider2", label = h3("Slider Range"),
                                                              min = 1938, max = 2020,
                                                              value = c(1938, 2020),
                                                              sep = "", ticks = TRUE,
                                                              # step = c(1938, 1943,
                                                              #   1954, 1967, 1980, 1994, 2004, 2012, 2014, 2016, 2018, 2020),
                                                              format = "####"),

                                                      hr(),

                        fluidRow(
                          column(12, verbatimTextOutput("value")),
                          column(12, verbatimTextOutput("range"))
                        )
                            ),
                            mainPanel("Number of live individuals"))
)))


# Define server
server <- function(input, output) {

  widget1reactive <- reactive({
    trees_2020 %>%
      species == input$select_species

  })

  output$species_plot <- renderPlot(
    ggplot(data = widget1reactive)+
      geom_sf(color = "species")

  )

  widget2reactive <- reactive({
    tree_pivot %>%
      filter(year %in% input$pick_year)

  })

    output$widget2plot <- renderPlot(
      ggplot() +
        geom_sf(data = sb_county) +
        geom_sf(data = widget2reactive(), aes(fill = species, color = species)) +
        theme_minimal()
      )


    widget3_reactive <- reactive({
      output$value <- renderPrint({ input$select })
    })

    output$widget3_plot <- renderPlot(
      ggplot(data = widget3_reactive, aes(x = output$value)) +
        geom_col(fill = "blue")
    )



     widget4_reactive <- reactive({
        tree_pivot$range <- renderPrint({ input$slider2 })
      })

      output$widget4_plot <- renderPlot(
        ggplot() +
          geom_sf(data = sb_county) +
          geom_sf(data = widget4reactive(), aes(fill = species, color = species)) +
          theme_minimal()
      )


    }


# Run the application
shinyApp(ui = ui, server = server)

