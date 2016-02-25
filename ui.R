library(plotly)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("Filters"),
      numericInput('num_filters', label = "Number of Filters", value = 0),
      uiOutput('filters'),
      h3("Variables"),
      selectInput("x_variable", label = "X Variable", choices = colnames(iris)),
      selectInput("y_variable", label = "Y Variable", choices = colnames(iris)),
      selectInput("color_variable", label = "Color Variable", choices = colnames(iris))
    ),
    mainPanel(
      plotlyOutput('scatter')
    )
  )
))