# Title: 
# Description: 
# Author: 
# Date: 


# =======================================================
# Packages (you can use other packages if you want)
# =======================================================
library(shiny)
library(bslib)     # for creating nice shiny dashboards
library(tidyverse) # for data manipulation and graphics
library(plotly)    # for web-interactive graphics
library(DT)        # to work with HTML table widgets


# ======================================================
# Auxiliary objects/functions 
# (that don't depend on input widgets)
# ======================================================
# You may want to add one or more auxiliary objects for your analysis
# (by "auxiliary" we mean anything that doesn't depend on input widgets)





# =======================================================
# Define UI for application
# =======================================================
ui <- page_sidebar(
  title = "Retirement Contribution Calculator",
  fillable = FALSE,
  
  # -------------------------------------------------------
  # Bootstrap theme
  # (feel free to comment-out the theme commands)
  # -------------------------------------------------------
  theme = bs_theme(
    version = 5,
    bootswatch = "lumen",
    base_font = font_google("Inter")
  ),

  # -------------------------------------------------------
  # Sidebar with input widgets 
  # -------------------------------------------------------
  sidebar = sidebar(
    title = "Inputs",
    numericInput(inputId = "initial",
                 label = "Initial Salary",
                 value = 80000),
    numericInput(inputId = "growth_rate",
                 label = "Rate of Growth",
                 value = 0.02),
    numericInput(inputId = "contribution",
                 label = "Contribution Percentage",
                 value = 0.15),
    numericInput(inputId = "periods",
                 label = "# of Periods",
                 value = 12),
    numericInput(inputId = "years",
                 label = "Years",
                 value = 5),
    numericInput(inputId = "return_rate",
                 label = "Rate of Return",
                 value = 0.08),
    numericInput(inputId = "target",
                 label = "Target Amount",
                 value = 35000),
    checkboxInput(inputId = "target_show",
                 label = "Show Target?",
                 value = FALSE)
  ), # closes sidebar (of inputs)
  
  # -------------------------------------------------------
  # Main content area with outputs: plots and table
  # Note: outputs are wrapped inside cards() 
  # -------------------------------------------------------
  card(
    card_header("Plot 1"),
    height = 500,
    plotlyOutput(outputId = "plot1")
  ),
  card(
    card_header("Plot 2"),
    plotlyOutput(outputId = "plot2")
  ),
  card(
    card_header("Table"),
    height = 600,
    style = "resize:vertical;",
    card_body(
      min_height = 500,
      div(dataTableOutput(outputId = "table"))
    )
  )
  
) # closes page_sidebar (UI)


# ======================================================
# Define server logic
# ======================================================
server <- function(input, output) {
  
  # ------------------------------------------------------------
  # Reactive Balance table
  # (adapt code to get the appropriate Balance data table)
  # ------------------------------------------------------------
  tbl = reactive({
    # the following code is for demo purposes only; adapt it!!!
    initial = input$initial
    contribution_total = input$initial * input$contribution
    periodic_contribution = contribution_total / input$periods
    balance = 0
    balances = c()
    salaries = 1:input$years
    contributions = 1:input$years
    
    count = 1 
    for (year in 1:input$years){
      salaries[year] = initial
      contribution_total = initial * input$contribution
      contributions[year] = contribution_total
      periodic_contribution = contribution_total / input$periods
      
      for (period in 1:input$periods) {
        new_balance = balance * (1 + input$return_rate / input$periods) + periodic_contribution
        balances = append(balances, new_balance)
        balance = new_balance 
        count = count + 1
      }
      
      increase = initial * input$growth_rate
      initial = initial + increase
    }
    
    
    balance_tbl = data.frame(
      year = 1:input$years,
      salary = salaries, 
      contribution = contributions,
      balance = balances[seq(0, length(balances), by = input$periods)]) |>
      mutate(
        own = cumsum(contribution),
        growth = balance - own,
        own_pct = (own / balance) * 100,
        growth_pct = (growth / balance) * 100,
        hit_target = case_when(
          balance >= input$target ~ 'yes', 
          balance < input$target ~ 'no') ) 
    
    balance_tbl
  })
  
  
  # ------------------------------------------------------------
  # Plot of balance timeline
  # (adapt code to make a timeline according to your analysis)
  # ------------------------------------------------------------
  output$plot1 <- renderPlotly({
    # the following code is for demo purposes only; adapt it!!!
    p1 = ggplot(data = tbl(), aes(x = year, y = balance)) +
      geom_line() +
      geom_point() +
      geom_area(alpha = 0.2, fill = 'pink') + 
      scale_y_continuous(label = scales::comma) + 
      labs(title = 'Balance Timeline') + 
      theme_minimal()
    
    if (input$target_show == TRUE){
      p1 +
        geom_hline(aes(yintercept = input$target), color = 'darkgreen') +
        annotate(geom = 'text', x = 1.5, y = input$target, label = paste0('Target:', input$target), color = 'darkgreen')}
    else {
      p1}
  })
  
  
  # ------------------------------------------------------------
  # Plot of balance decomposition
  # (adapt code to make a graphic according to your analysis)
  # ------------------------------------------------------------
  output$plot2 <- renderPlotly({
    # the following code is for demo purposes only; adapt it!!!
    long = tbl() |>
      select(year, own, growth) |>
      pivot_longer(cols = own:growth, 
                   names_to = 'type')
    ggplot(dat = long, aes(x = year, y = value)) +
      geom_col(aes(group = type, fill = type)) +
      scale_y_continuous(label = scales::comma) + 
      labs(title = 'Composition of Retirement Balance') + 
      theme_minimal()
      
  })
  
  
  # ------------------------------------------------------------
  # Table with Retirement Balance data
  # (adapt code to display appropriate table)
  # ------------------------------------------------------------
  output$table <- renderDataTable({
    # to limit the number of decimal digits in the rendered table
    # you can convert it into a "DataTable" object, and then use
    # formatRound() to limit the displayed decimals.
    tbl() |>
      datatable() |> # convert into "DataTable" object
      formatRound(columns = 2:8, 
                  digits = 2) # round to 2-digits
  })

} # closes server


# Run the application 
shinyApp(ui = ui, server = server)
