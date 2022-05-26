# script to extract to webscrape indeed for entry level data scientist

# Author: Peter Boshe
# Version: 2022-05-07

# Packages
library(tidyverse)
library(rvest)
library(profvis)
library(httr)
library(broom)

# Parameters
url <- "https://www.indeed.com/jobs?q=entry%20level%20data%20scientist&l=Remote&from=searchOnHP&vjk=e4dd563aa0c5df59"
domain <- "https://www.indeed.com"
file_out <- "~/Projects/web_scrape/data/table.rds"

# ============================================================================

# Code

profvis({


html <- read_html(url)


job_title <- html |>
  html_nodes("span[title]") |>
  html_text()


company <- html |>
  html_nodes("span.companyName") |>
  html_text()

location <- html |>
  html_nodes("div.companyLocation") |>
  html_text()


links <- html |>
  html_nodes(xpath = "/html/body//tbody//div[1]/h2/a") |>
  html_attr("href")

max_length <- length(job_title)
df <- data.frame(job_title,
                 company,
                 location,
                 domain,
                 links = c(rep("NA", max_length - length(links)), links)) |>
  mutate(url_link = str_c(domain,"",links)) |>
  select(job_title, company, location, url_link)


# second iteration through the links --------------------------------------



# x <- "https://www.indeed.com/rc/clk?jk=655e1551430353b4&fccid=11619ce0d3c2c733&vjs=3"

extract_description <- function(x) {

  Sys.sleep(2) # to pause between requests

  cat(".") # stone age progress bar

  html2 <- read_html(x)

  job_description <- html2 |>
    html_nodes(xpath = '//*[@id="jobDescriptionText"]') |>
    html_text() |>
    str_squish()

  count_r <- job_description |>
    str_count('[./ ,]R{1}[./ ,]')

  r_present <- job_description |>
    str_detect('[./ ,]R{1}[./ ,]')


  data.frame(job_description = job_description,
         r_present = r_present,
         count_r = count_r)    #important to name the variables to avoid script failure

}


# functional programming for the win! -------------------------------------


listed_df <- df |>
  mutate(description = map(url_link, safely(~ extract_description(.x), otherwise = NA_character_)))


# Our new data set --------------------------------------------------------

indeed_df <- listed_df |>
  unnest(description) |>
  unnest(description) |>
  arrange(desc(count_r))

# Write out file

write_rds(indeed_df,file_out)


})
