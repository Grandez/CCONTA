server <- function(input, output, session) {
   browser()
  output$table <- renderReactable({
   reactable(iris)
 })
}