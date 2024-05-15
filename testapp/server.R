library(tidyverse)
library(baseballr)
library(ggrepel)
library(shiny)

function(input, output, session) {
  fgteam <- reactive({ 
    fg <- fg_batter_leaders(startseason = "2024", endseason = "2024")
    fg |>
      rename(team = team_name) |>
      filter(team == input$mlbteam) |>
      filter(PA > 5)
  })
  
  fgall <- fg_batter_leaders(startseason = "2024", endseason = "2024")
  fgall <- fgall |>
    filter(PA > 20)
  
  output$table <- renderTable({
    fg <- fgteam()
    fgtable <- fg |>
      select(PlayerName, AVG, SLG, xSLG, OPS, G, AB, PA, H, HR, R, BABIP, WAR, BB, SO, SB) |>
      mutate(SLGDiff = xSLG - SLG) |>
      arrange(desc(SLGDiff))
    
    fgtable$SLG <- sprintf("%.3f", fgtable$SLG)
    fgtable$xSLG <- sprintf("%.3f", fgtable$xSLG)
    fgtable$SLGDiff <- sprintf("%.3f", fgtable$SLGDiff)
    
    fgtable
  })
  
  output$plot1 <- renderPlot({
    fg <- fgteam()
    text <- "In general, the farther above the dashed line a player is, the unluckier they are." |>
      str_wrap(width = 35)
    min_SLG <- min(fg$SLG) * .80
    max_SLG <- max(fg$SLG) * 1.15
    min_xSLG <- min(fg$xSLG) * .80
    max_xSLG <- max(fg$xSLG) * 1.15
    gg <- ggplot(fg, aes(x = SLG, y = xSLG, label = PlayerName)) + 
      geom_point(aes(color = PA)) +
      scale_color_gradient(low = "#67c9ff", high = "orange") +
      geom_text_repel(vjust = 1.5) +
      geom_abline(slope = 1, intercept = 0, color = "black", linetype = "dashed") +
      coord_cartesian(xlim = c(min_SLG, max_SLG), ylim = c(min_xSLG, max_xSLG)) +
      theme_light()
    gg <- gg + ggtitle(paste0(input$mlbteam, " SLG Diff"))
    gg
  }, res = 96)
  
  output$plot2 <- renderPlot({
    fgteam <- fgteam()
    min_SLG <- min(fgall$SLG) * .80
    max_SLG <- max(fgall$SLG) * 1.15 
    min_xSLG <- min(fgall$xSLG) * .80
    max_xSLG <- max(fgall$xSLG) * 1.15
    gg <- ggplot(fgall, aes(x = SLG, y = xSLG, label = PlayerName)) + 
      geom_point(aes(color = PA)) +
      scale_color_gradient(low = "#67c9ff", high = "orange") +
      geom_text_repel(vjust = 1.5, data = fgteam) +
      geom_abline(slope = 1, intercept = 0, color = "black", linetype = "dashed") +
      coord_cartesian(xlim = c(min_SLG, max_SLG), ylim = c(min_xSLG, max_xSLG)) +
      theme_light()
    gg <- gg + ggtitle(paste0("All Players PA > 20 (", input$mlbteam, " players highlighted)"))
    gg
  }, res = 96)
  
}



