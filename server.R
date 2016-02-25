library(plotly)
library(dplyr)

# This function dynamically creates a filter input
filterInput <- function(filter_num, input) {
  filter_name <- paste0('filter_', as.character(filter_num))
  
  filter <- list(
    selectInput(
      paste0(filter_name, '_column'),
      label = "Column to filter",
      choices = colnames(iris)
    ),
    selectInput(
      paste0(filter_name, '_comparison'),
      label = "",
      choices = list(">", "<", ">=", "<=", "=")
    ),
    textInput(
      paste0(filter_name, '_value'),
      label = ""
    )
  )
  return(filter)
}

shinyServer(function(input, output) {
  # This creates a list of all the filter inputs needed
  output$filters <- renderUI({
    if(input$num_filters < 1) {
      return()
    }
    
    list_of_filters <- list()
    
    for(i in 1:input$num_filters) {
      list_of_filters[[i]] <- filterInput(i)
    }
    
    return(list_of_filters)
  })
  
  output$scatter <- renderPlotly({
    filtered_data <- iris
    # Use the filters to narrow down data
    for(i in 1:input$num_filters) {
      filter_name <- paste0('filter_', as.character(i))
      filter_value <- input[[paste0(filter_name, '_value')]]
      if(!is.null(filter_value)) {
        after_filter <- data.frame()
        # The filter is filled out
        column_name <- input[[paste0(filter_name, '_column')]]
        comparison <- input[[paste0(filter_name, '_comparison')]]
        if(class(iris[[column_name]]) == "numeric" & !is.na(as.numeric(filter_value))) {
          # This is a numeric filter
          if(!grepl(">", comparison)) {
            # This comparison does not include greater-than
            after_filter <- filtered_data %>% filter_(paste(column_name, "<=", filter_value))
          }
          
          if(!grepl("=", comparison)) {
            # This comparison does not include equals
            after_filter <- filtered_data %>% filter_(paste(column_name, "!=", filter_value))
          }
          
          if(!grepl("<", comparison)) {
            # This comparison does not include less-than
            after_filter <- filtered_data %>% filter_(paste(column_name, ">=", filter_value))
          }
        } else if(class(iris[[column_name]]) == "character" | class(iris[[column_name]]) == "factor") {
          # This is a string filter (only works with "=")
          if(comparison == "=" & nchar(filter_value) > 0) {
            after_filter <- filtered_data %>% filter_(paste0(column_name, " == '", filter_value, "'"))
          }
        }
        # Only actually perform the filter if it leaves some values
        if(nrow(after_filter) > 0) {
          filtered_data <- after_filter
        }
      }
    }
    
    # Workaround. Can't find a way to add a title to a color axis
    # and this was better than having eval AND parse in the auto-title
    color_axis <- parse(text = input$color_variable)
    
    plot_ly(
      data = filtered_data,
      x = eval(parse(text = input$x_variable)),
      y = eval(parse(text = input$y_variable)),
      color = eval(color_axis),
      mode = "markers",
      type = "scatter"
    ) %>% layout(
      xaxis = list(title = input$x_variable),
      yaxis = list(title = input$y_variable)
    )
  })
})