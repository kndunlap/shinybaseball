library(tidyverse)
library(baseballr)
library(ggrepel)
library(shiny)

mlb_teams <- c("Pick a Team", "ANA", "ARI", "ATL", "BAL", "BOS", "CHC", "CHW", "CIN", "CLE", "COL", "DET", "HOU", "KCR", "LAA", "LAD", "MIA", "MIL", "MIN", "NYM", "NYY", "OAK", "PHI", "PIT", "SDP", "SEA", "SFG", "STL", "TBR", "TEX", "TOR")

# Define UI for application that draws a histogram
fluidPage(
  selectInput("mlbteam", "Pick an MLB team", mlb_teams),
  plotOutput("plot1", width = "1300px"),
  plotOutput("plot2", width = "1300px"),
  tableOutput("table")
)