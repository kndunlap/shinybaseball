library(tidyverse)
library(baseballr)
library(ggrepel)
library(shiny)
library(viridis)

mlb_teams <- c("Pick a Team", "ANA", "ARI", "ATL", "BAL", "BOS", "CHC", "CHW", "CIN", "CLE", "COL", "DET", "HOU", "KCR", "LAA", "LAD", "MIA", "MIL", "MIN", "NYM", "NYY", "OAK", "PHI", "PIT", "SDP", "SEA", "SFG", "STL", "TBR", "TEX", "TOR")
stats <- c("Pick a Stat", "AVG", "SLG", "wOBA")

fluidPage(
  selectInput("mlbteam", "Pick an MLB team", mlb_teams),
  selectInput("stat", "Pick a stat", stats),
  numericInput("min_PA", "Minimum PA:", value = 20, min = 0),
  plotOutput("plot1", width = "1300px"),
  tableOutput("table")
)