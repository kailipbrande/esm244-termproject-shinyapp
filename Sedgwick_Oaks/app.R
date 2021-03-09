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
                          sidebarPanel(
                            radioButtons(inputId = "select_species", label = "Select Species:", choices = list( "QULO", "QUDO", "QUAG"), selected = "QULO")),
                          mainPanel("2020 Distribution",
                                    plotOutput(outputId = "species_plot"))
                        )
               ),
               tabPanel("Widget 2",
                        sidebarLayout(
                          sidebarPanel("Select Year",
                                       checkboxGroupInput(inputId = "pick_year",
                                                          label = "Select study year:",
                                                          choices = unique(tree_melt$year),
                                       )),
                          mainPanel("Species Distribution",
                                    plotOutput("widget2plot")),
                        )
               ),
               tabPanel("Widget 3",
                        sidebarLayout(
                          sidebarPanel(
                            selectInput(inputId = "select_year", label = "Select Year:", choices = list("1938" = 1938, "1943" = 1943, "1954" = 1954, "1967" = 1967, "1980" = 1980, "1994" = 1994, "2004" = 2004, "2012" = 2012, "2014" = 2014, "2016" = 2016, "2018" = 2018, "2020" = 2020), selected = 1)),
                          mainPanel("Number of live individuals",plotOutput(outputId = "widget3_plot")))
               ),

                tabPanel("Widget 4",
                         sidebarLayout(
                             sidebarPanel("Select Time Period",
                                                   sliderInput("slider2", label = h3("Slider Range"),
                                                               min = 1938, max = 2020,
                                                               value = c(1954, 2014),
                                                               sep = "", ticks = TRUE
                                                               )),
                                          mainPanel("Number of Live Individuals in Time Range",
                                            plotOutput(outputId = "widget4plot"))
 )
))
)



# Define server
server <- function(input, output) {

  widget1reactive <- reactive({
    trees_2020 %>%
      filter(species == input$select_species)

  })

  output$species_plot <- renderPlot({
    ggplot(data = widget1reactive())+
      geom_sf()

  })

  widget2reactive <- reactive({
    tree_melt %>%
      filter(year %in% input$pick_year)

  })

  output$widget2plot <- renderPlot({
    ggplot() +
      geom_sf(data = widget2reactive(), aes(fill = species, color = species)) +
      theme_minimal()
  })


    widget3_reactive <- reactive({
      widget_3 %>%
        filter(year == input$select_year)
    })


    output$widget3_plot <- renderPlot({
      ggplot(data = widget3_reactive(), aes(x = year, y = n, fill = species)) +
        geom_bar(stat="identity", width=.5, position = "dodge")
    })



     widget4_reactive <- reactive({

     widget_4 %>%
        filter(between(year, input$slider2[1], input$slider2[2]))

       })


      output$widget4plot <- renderPlot({
        ggplot(data = widget4_reactive(), aes(x = year, y = count, color = species, group = species)) +
          geom_point() +
          geom_line()
      })


    }


# Run the application
shinyApp(ui = ui, server = server)

