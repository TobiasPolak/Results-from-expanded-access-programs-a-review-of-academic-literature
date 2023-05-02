# The R code processes a dataset of academic articles from RAYYAN, used in a scoping review.
# It classifies articles based on various criteria and extracts relevant information.
# The script identifies potential labels for investigations, reviews, opinions, devices, case reports, case series, and COVID-related articles, but all labels are manually checked afterward.
# The code detects inconsistencies in DOIs, errors in labeling, and missing data.
# It also provides summary statistics for a comprehensive understanding of the dataset.


# 1. Installing and loading packages
# List all required packages
packages <-
  list(
    'installr',
    'gsheet',
    'pdftools',
    'tidyr',
    'glue',
    'readr',
    'rvest',
    'stringr',
    'urltools',
    'RCurl',
    'stringr',
    'readxl',
    'stringr',
    'dplyr',
    'bibliometrix',
    'RefManageR',
    'bib2df',
    'rcrossref',
    'DiagrammeR',
    'gridExtra',
    'grid',
    'rsvg',
    'gtsummary',
    'DiagrammeRsvg',
    'ggplot2',
    'rscopus',
    'rcrossref',
    'bibtex',
    'bibliometrix',
    'tidyverse',
    'googlesheets4',
    'ggsci',
    'easyPubMed',
    'sjmisc',
    'RColorBrewer',
    'english',
    'countrycode',
    'wppExplorer',
    'stringi',
    "cowplot", "googleway", "ggplot2", "ggrepel", 
    "ggspatial", "sf", "rnaturalearth", "rnaturalearthdata"
  )

# Load packages and install missing ones
lapply(packages, require, character.only = TRUE)
new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {install.packages(unlist(new.packages))}

# Define a utility function to check if an element is not in a set
`%!in%` = Negate(`%in%`)

# Authenticate with Google Sheets (replace with your email)
gs4_auth("your-email@gmail.com")

# Define paths for BibTeX, EndNote, RIS, and CSV files (replace with your file paths)
bibtex_path <- "path/to/BibTeX/myCollection.bib"
endnote_path <-  "path/to/EndNote/articles.enw"
ris_path <- "path/to/RIS/myCollection.ris"
csv_inc_path <- "path/to/CSV_inclusions/articles.csv"
csv_all_path <- "path/to/CSV/articles.csv"

# Load and process data
df.all <- read.csv(csv_all_path)
df.all <- df.all[which(df.all$year != '2022'),]

# Create a flowchart 
cat('Total number of articles: ', length(df.all$key), "\n")

# Clean and process decisions
df.all$decision <- sub(".*RAYYAN-INCLUSION: ", "", df.all$notes) 
df.all$decision <- sub("\\|.*", "", df.all$decision)
df.all$decisionnum <- lengths(strsplit(df.all$decision, ","))
decisiontable <- df.all %>% count(decisionnum, sort = T)
df.all$method <- 'Unknown'

# Assign the reviewers
david <- sum(grepl('David', df.all$decision))
tobias <- sum(grepl('Tobias', df.all$decision))
naima <- sum(grepl('naima', df.all$decision))
syed <- sum(grepl('syed', df.all$decision))

# Process POTENTIAL retrospective and prospective information
retro <- grep('retrospective', df.all$abstract, ignore.case = TRUE)
retro <- which(rowSums( as.data.frame(Vectorize(grepl)(pattern = 'retrospective', x = df.all[,c('abstract', 'title')], ignore.case = TRUE)))>0)


# Identifying POTENTIAL retrospective and prospective studies
retro <- grep('retrospective', df.all$abstract, ignore.case = TRUE)
retro <- which(rowSums( as.data.frame(Vectorize(grepl)(pattern = 'retrospective', x = df.all[,c('abstract', 'title')], ignore.case = TRUE)))>0)
df.all$method[retro] <- 'Retrospective'
prosp <- which(rowSums( as.data.frame(Vectorize(grepl)(pattern = 'prospective', x = df.all[,c('abstract', 'title')], ignore.case = TRUE)))>0)
df.all$method[prosp] <- 'Prospective'
df.all$method[intersect(retro, prosp)] <- 'Retrospective/Prospective'

# Counting the number of each type of study
cat('Retrospective: ', length(which(df.all$method == 'Retrospective')), '\n',
    'Prospective: ', length(which(df.all$method == 'Prospective')),'\n',
    'Retrospective/Prospective: ', length(which(df.all$method == 'Retrospective/Prospective')), '\n',
    'Unknown: ', length(which(df.all$method == 'Unknown')), '\n')

# Identifying POTENTIAL single-center and multi-center studies
df.all$center <- 'Unknown'
singlecenter <- which(rowSums( as.data.frame(Vectorize(grepl)(pattern = 'single-center|single center|single-centre|single centre|single hospital|single institution', x = df.all[,c('abstract', 'title')], ignore.case = TRUE)))>0)
cat('single center: ', length(singlecenter), '\n')
df.all$center[singlecenter] <- 'Single-center'
multicenter <- which(rowSums( as.data.frame(Vectorize(grepl)(pattern = 'multi-center|multiple center|multicenter|multicentre|multi-centre|multiple centre|multiple hospital|multiple institution', x = df.all[,c('abstract', 'title')], ignore.case = TRUE)))>0)
cat('multiple center: ', length(multicenter), '\n')
df.all$center[multicenter] <- 'Multi-center'
bothcenters <- intersect(multicenter, singlecenter)
cat('both multiple and single center: ', length(bothcenters), '\n')
df.all$center[bothcenters] <- 'Single/Multi-center'

# Counting the number of included and excluded articles
excl <- grep('Excluded', df.all$decision)
incl <- grep('Included', df.all$decision)
df.all$incl <- grepl('Included', df.all$decision)

cat('Total excluded: ', length(excl), "\n")
cat('Total included: ', length(incl), "\n")
cat('Unique decision per article check: ', is.empty(intersect(incl,excl)), "\n")
table(df.all$decisionnum)

# Checking the article information for DOIs
dois <- grep('doi:', df.all$notes, ignore.case = TRUE)
df.all$dois <- 'N/A'
df.all$doi <- grepl('doi:', df.all$notes, ignore.case = TRUE)
df.all$dois[dois] <- sub(".*doi: ", "", df.all$notes[dois]) 
df.all$dois[dois] <- sub("\\|.*", "", df.all$dois[dois])
df.all$dois[dois] <- sub(" .*", "", df.all$dois[dois])

# Removing trailing periods from DOIs
df.all$dois[dois] <- substr(df.all$dois[dois] , 1, nchar(df.all$dois[dois] )-1)

# Checking for inconsistencies in DOI calculations
check_doi <- grepl("10.\\d{4,9}[-._;()//:A-Z0-9]",  df.all$notes, ignore.case = TRUE)
if (sum(check_doi) != length(dois)){
  cat('The advanced doi check', sum(check_doi),' leads to different results than the simple check', length(dois), 'Please revise.', "\n")
}else{
  cat('There are no inconsistencies in DOI calculations.', "\n")
}

# Extracting labels from the notes
df.all$labels <- sub(".*RAYYAN-LABELS: ", "", df.all$notes) 
df.all$labels <- sub("\\|.*", "", df.all$labels)
df.all$labelnum <- lengths(strsplit(df.all$labels, ","))

df.all$label <- grepl('RAYYAN-LABELS', df.all$notes)

# Handling exclusion reasons
df.excl <- df.all

df.excl$reasonYN <- grepl('RAYYAN-EXCLUSION-REASONS:', df.excl$notes)
cat('Exclusions without reason: ', length(df.excl$key) - sum(df.excl$reasonYN == FALSE), "\n")

df.excl$exclreas <- sub(".*RAYYAN-EXCLUSION-REASONS: ", "", df.excl$notes) 
df.excl$exclreas <- sub("\\|.*", "", df.excl$exclreas)
df.excl$exclreasnum <- lengths(strsplit(df.excl$exclreas, ","))

# Removing articles without full text
nofulltext <- grep('lacking', df.excl$exclreas)
df.excl1 <- df.excl[-nofulltext, ]

# Removing foreign language articles
foreignlanguage <- grep('foreign language', df.excl1$exclreas)

read <- grep('read', df.excl1$labels)
abstract <- length(df.excl1$key) - length(read)
df.excl2 <- df.excl1[-foreignlanguage, ]
df.excl2 <- df.excl2[which(df.excl2$incl == FALSE),] # Only include the excluded

# Removing articles with no compassionate use or reason
nocompassionateuselabel <- grep('no compassionate', df.excl2$exclreas)
noreason <- which(df.excl2$reasonYN == FALSE & df.excl2$incl == FALSE)
HIV <- grep('HIV', df.excl2$exclreas)
softdrugs <- grep('soft drugs', df.excl2$exclreas)
nocompassionateuse <- unique(c(nocompassionateuselabel, noreason, HIV, softdrugs))

df.excl3 <- df.excl2[-nocompassionateuse, ]
erratum <- grep('errat', df.excl3$exclreas)
editor <- grep('editor', df.excl3$exclreas)
erratareplies <- unique(c(editor, erratum))
df.excl4 <- df.excl3[-erratareplies, ]
news <- grep('news', df.excl4$exclreas)

df.excl5 <- df.excl4[-news, ]
table(df.excl5$exclreas)
cat('Background article (meta-analysis, guideline, systematic review): ', length(df.excl5$exclreas), "\n")

# Continuing the analysis
df.incl <- df.all[incl,]

# Identifying different types of articles
inv <- grep('investigation', df.incl$labels)
df.incl$investigation <- grepl('investigation',df.incl$labels)
rev <- grep('review',  df.incl$labels)
opi <- grep('opinion', df.incl$labels)
device <- grep('device', df.incl$labels)
df.incl$device <- grepl('device', df.incl$labels)
casereport <- grep('case report', df.incl$labels)
df.incl$casereport <- grepl('case report', df.incl$labels)
caseseries <- grep('case series', df.incl$labels)
df.incl$caseseries <- grepl('case series', df.incl$labels)
covid <- grep('COVID', df.incl$labels)
df.incl$covid <- grepl('COVID', df.incl$labels)

# Checking for overlaps between article types
cat('Articles investigation AND review: ', length(intersect(inv, rev)), "\n")
cat('Articles investigation AND opinion: ', length(intersect(inv, opi)), "\n")
cat('Articles investigation AND opinion AND review : ',length(intersect(inv, intersect(rev, opi))), "\n")
cat('Case reports: ', sum(df.incl$casereport), 'Case series :', sum(df.incl$caseseries), '\n',
    'Overlap case report/series : ', length(intersect(casereport, caseseries)), "\n")

# Detecting errors in labeling and DOIs
double_label <- unique(c(intersect(inv, rev), intersect(inv, opi)))
if (!is.empty(double_label)){
  write.csv(df.incl[double_label, ],"placeholder_directory/DoubleLabels.csv", row.names = FALSE)
}else{
  cat('There is nothing labelled investigation and review/or opinion', "\n")
}

if (sum(df.incl$doi == FALSE) > 0){
  write.csv(df.incl[which(df.incl$doi == FALSE),],"placeholder_directory/DOIs.csv", row.names = FALSE)
  cat('Articles without DOI: ', length(df.incl$doi) - sum(df.incl$doi) , ' => ', length(df.incl$doi) - sum(df.incl$doi) , '/', length(df.incl$doi), '= ', round((length(df.incl$doi) - sum(df.incl$doi))/length(df.incl$doi)*100, 2), '%' , "\n")
  cat('Investigations without DOI: ', length(df.incl$doi[inv]) - sum(df.incl$doi[inv]), ' => ', length(df.incl$doi[inv]) - sum(df.incl$doi[inv]) , '/', length(df.incl$doi[inv]), '= ', round((length(df.incl$doi[inv]) - sum(df.incl$doi[inv]))/length(df.incl$doi[inv])*100, 2), '%' , "\n")
}else{
  cat('There are no articles without DOI', "\n")
}

# Analyzing investigations
df.inv <- df.incl[inv, ]
cat('Number of investigations: ', length(df.inv$key), "\n")
cat('Number of device/procedures: ', sum(df.inv$device), "\n")
cat('Number of case reports: ', sum(df.inv$casereport), "\n")
cat('Number of COVID-related articles: ', sum(df.inv$covid), "\n")
cat('Number of missing DOIs in investigations: ', length(df.inv$doi) - sum(df.inv$doi), "\n")                                                                             