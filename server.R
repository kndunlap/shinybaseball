library(tidyverse)
library(baseballr)
library(ggrepel)
library(shiny)
library(viridis)

fg <- fg_batter_leaders(startseason = "2024", endseason = "2024")

server <- function(input, output, session) {
  
  fgteam <- reactive({ 
    fg %>%
      rename(team = team_name) %>%
      filter(team == input$mlbteam, PA > input$min_PA)
  })
  
  output$table <- renderTable({
    fg <- fgteam()
    stat <- input$stat
    xstat <- paste0("x", stat)
    
    fgtable <- fg |>
      rename(Player = PlayerName) |>
      select(Player, !!sym(stat), !!sym(xstat)) %>%
      mutate(Difference = !!sym(xstat) - !!sym(stat)) %>%
      arrange(desc(Difference))
    
    fgtable <- fgtable %>%
      mutate(across(c(!!sym(stat), !!sym(xstat), Difference), ~ sprintf("%.3f", .)))
    
    fgtable
  })
  
  output$plot1 <- renderPlot({
    fg <- fgteam()
    stat <- input$stat
    xstat <- paste0("x", stat)
    min_stat <- min(fg[[stat]], na.rm = TRUE) * 0.80
    max_stat <- max(fg[[stat]], na.rm = TRUE) * 1.15
    min_xstat <- min(fg[[xstat]], na.rm = TRUE) * 0.80
    max_xstat <- max(fg[[xstat]], na.rm = TRUE) * 1.15
    gg <- ggplot(fg, aes(x = !!sym(stat), y = !!sym(xstat), label = PlayerName)) + 
      geom_point(aes(color = PA)) +
      scale_color_viridis() +
      geom_text_repel(vjust = 1.5) +
      geom_abline(slope = 1, intercept = 0, color = "black", linetype = "dashed") +
      coord_cartesian(xlim = c(min_stat, max_stat), ylim = c(min_xstat, max_xstat)) +
      theme_light()
    gg <- gg + ggtitle(paste0(input$mlbteam, " ", input$stat, " Diff"))
    gg
  }, res = 96)
  
}




