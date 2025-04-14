app_version <- "0.0.0.0009"
library(shiny)
library(plotly)
library(gridlayout)
library(bslib)
library(shinyWidgets)

source("R/load_data.R")
source("R/modules.R")


ipf_df <- load_data()

weight_class_choices_M <- c(
  "all",
  "53",
  "59",
  "66",
  "74",
  "83",
  "93",
  "105",
  "120",
  "120+"
)

weight_class_choices_F <- c(
  "all",
  "43",
  "47",
  "52",
  "57",
  "63",
  "69",
  "76",
  "84",
  "84+"
)
