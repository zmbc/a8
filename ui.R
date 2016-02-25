library(plotly)

shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      h3("Filters"),
      numericInput('num_filters', label = "Number of Filters", value = 0),
      uiOutput('filters'),
      h3("Variables"),
      selectInput("x_variable", label = "X Variable", choices = colnames(iris), selected = colnames(iris)[1]),
      selectInput("y_variable", label = "Y Variable", choices = colnames(iris), selected = colnames(iris)[2]),
      selectInput("color_variable", label = "Color Variable", choices = colnames(iris), selected = colnames(iris)[5])
    ),
    mainPanel(
      plotlyOutput('scatter')
    )
  )
))