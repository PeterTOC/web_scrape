# Search path
VPATH = data reports scripts

# Processed data files
DATA = table.rds wordcloud.html

# EDA studies
EDA =

# Reports
REPORTS = job_dashboard.Rmd

# All targets
all : $(DATA) $(EDA) $(REPORTS)

# Data dependencies
table.rds : table.R
wordcloud.html : wordcloud.R


# EDA study and report dependencies


# Pattern rules
%.rds : %.R
	Rscript $<
%.md : %.Rmd
	Rscript -e 'rmarkdown::render(input = "$<", output_options = list(html_preview = FALSE))'
