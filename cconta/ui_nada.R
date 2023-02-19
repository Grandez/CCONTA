library(shiny)
library(reactable)

ui <- fluidPage(
 titlePanel("reactable example"),
 reactableOutput("table")
)