#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application
shinyUI(fluidPage(

  # Application title
  titlePanel("Glaton: Predicting Child's Height from Parent's Height"),
  
  
  tags$p("This web app will predict the height of children using the average height of the parents. 
         It performs the prediction based on linear regression fitted on the Galton dataset."),
  tags$hr(),

  # Sidebar with sliders to input parent's heights
  sidebarLayout(
    sidebarPanel(
      
       tags$p("Drag the sliders to specify the heights of both parents."),
      
       # Slider to input Father's height; specified in inches with 1 decimal place
       sliderInput("fHeight",
                   "Input Father's Height (inches)",
                   min = 48,
                   max = 90,
                   value = 60,
                   step=0.1
                   ),
       
       # Slide to input Mother's height; specified in inches with 1 decimal place
       sliderInput("mHeight",
                   "Input Mother's Height (inches)",
                   min = 48,
                   max = 90,
                   value = 60,
                   step=0.1)
    ),

    # Show the results in the main panel
    mainPanel(
      
      fluidRow(
        
        column(6,
          # Show the Parents Average Height 
          h4('Parent Average Height (inches)'),
          verbatimTextOutput("parents")),
      
        column(6,
          # Show the Predicted Child Height
          h4('Predicted Child Height (inches)'),
          verbatimTextOutput("childHeight")),
          tags$head(tags$style("#childHeight{color: purple}"))
      ),
      
      fluidRow(
          # Plot the ComparisonPlot
          column(6,
          tags$br(),
          tags$p("The bar chart below compares the input heights against the predicted Child's height."),
          plotOutput("ComparisonPlot")),
      
          # Plot the RegressionPlot
          column(6,
          tags$br(),
          tags$p("The scatterplot below shows the data points (blue) from Galton. 
                 The fitted regression line is drawn and the predicted data point is shown in red."),
          plotOutput("RegressionPlot"))
      )
      
    )
  )
))
