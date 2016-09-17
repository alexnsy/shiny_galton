#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(HistData)
library(ggplot2)

# Create the regression fit using the Galton dataset
model <- lm(child ~ parent, data = Galton)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  # parentAvg calculates the average height of the parents from the input heights (father, mother)
  parentAvg <- reactive(
    {(input$fHeight + input$mHeight) / 2})

  # predictChild uses the fitted regression line to calculate the child's height using the average height of the parents
  predictChild <- reactive( {
    coef(model)[1] + coef(model)[2] * parentAvg()
  })

  
  # Output the average height of the parents
  output$parents <- renderText({round(parentAvg(), digits = 1)})
  
  # Output the predicted child height
  output$childHeight <- renderText({round(predictChild(), digits=1)})

  
  # RegressionPlot plots the fitted regression line and the data points from the Galton dataset. 
  # The predicted value on the line is also plotted in red.
  output$RegressionPlot <- renderPlot({
    plot(Galton$child, Galton$parent, pch = 16, cex = 1.3, col = "blue",
      main = "Child Height vs Parent Height",
      xlab = "Parent Height (inches)",
      ylab = "Child Height (inches)",
      xlim = c(40,80),
      ylim = c(40,80))

    abline(model)
    points(x=parentAvg(), y= predictChild(), pch = 19, col="red")
  })
 
  
  # ComparisonPlot is a bar chart comparing the input heights (Father, Mother, Parent Average)
  # and the Predicted Child's height
  output$ComparisonPlot <- renderPlot({
    dataCompare <- data.frame(id = c("Father", "Mother", "Parent Average", "Child"), 
                              height = c(input$fHeight,input$mHeight,parentAvg(),round(predictChild(), digits=1)))
    
    dataCompare$id2 <- factor(dataCompare$id, as.character(dataCompare$id))
    
    ggplot(data=dataCompare, aes(x=id2, y=height)) +
      geom_bar(stat="identity", fill= c("#778899", "#8B8682", "#87CEEB", "#A020F0")) +
      geom_text(aes(label=height), vjust=-0.3, size=4) + 
      ggtitle("Input and Predicted Heights") +
      labs(x="Person", y="Height (inches)") +
      theme(legend.position = "right")
    })
})
