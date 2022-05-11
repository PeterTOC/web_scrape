# script to send myself emails of the list

# Author: Peter Boshe
# Version: 2022-05-07

# Packages
library(tidyverse)
require(mailR)

# Parameters
file_raw <- "data/table.rds"
file_name <- "your_jobs.rds"
host.name = "smtp.gmail.com"
port = 465 # or 587
user.name = "peterboshe@gmail.com"
passwd = ""

# ============================================================================

# Code

send.mail(
  from="peterboshe@gmail.com", to = "peterboshe@gmail.com",
  subject = "The moment of truth",
  body = "Is this thing on?",
  smtp = list(host.name = host.name,
              port = port,
              user.name = user.name,
              passwd = passwd,
              ssl = T),
              #tls = T),
              authenticate = T,  send = T,
  attach.files = file_raw,
  file.names = file_name
  )

## need to find a less secure email service for these tasks
## should not compromise safety of my mail by removing two factor authentication which is required


