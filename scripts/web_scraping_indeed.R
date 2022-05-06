# script to extract to webscrape indeed for entry level data scientist

# Author: Peter Boshe
# Version: 2022-05-07

# Packages
library(tidyverse)
library(rvest)

# Parameters
url <- "https://www.indeed.com/jobs?q=entry%20level%20data%20scientist&l=Remote&from=searchOnHP&vjk=e4dd563aa0c5df59"


# ============================================================================

# Code

html <- read_html(url)

html |>
  html_nodes("span") |>
  html_text() # to be continued
