### PLEASE ENSURE TO READ THE README FILE BEFORE RUNNING THIS CODE.

# This code generates several tables to analyze the data. It starts by reading three data frames from Google Sheets (df.final, df.unmatched, df.covid). 
# Then, it combines these data frames, performs data cleaning and transformation, and calculates various statistics.

# The code first creates a table of disease areas and their frequencies (diseasetable). 
# It identifies less frequent disease areas and groups them into an "Other" category. 
# The code also extracts country-related information, such as country names, ISO3 codes, continents, and regions. 
# It calculates the number of publications and patients per country, region, NA region, and continent.

# The code selects the top 25 countries based on publication count and adds their population data. 
# It calculates the productivity (publications per million population) for each country and sorts the table by productivity.

# Next, the code extracts drug-related information and creates a table of drugs and their frequencies (drugtable). 
# It calculates the percentage of occurrences for each drug and filters out drugs with less than 1% occurrence. 
# It merges disease and patient information into the drug table and removes unnecessary columns.

# Finally, the code prints the drug table, which provides insights into the most frequently mentioned drugs, associated diseases, total patients, and publications.

# Note: Please replace PATH_TO_LOAD_INSTALL.R with the appropriate file path to load the required libraries 
# and GOOGLE_SHEET_URL with the actual URL of the Google Sheets file. 
# Additionally, replace PATH_TO_NATIONS_CSV with the file path to the CSV file containing population data.

# Note that you can change several items in this code, for example having ISO2 or ISO3 codes, or having more/less disease areas. 


### This file is meant to check all the numbers.

# Load necessary libraries. 
source("PATH_TO_LOAD_INSTALL.R", encoding = 'utf-8')

# Read data from Google Sheets
df.final <- read_sheet('GOOGLE_SHEET_URL', 'Final')
df.unmatched <- read_sheet('GOOGLE_SHEET_URL', 'Unmatched')
df.covid <- read_sheet('GOOGLE_SHEET_URL', 'COVID')

# Print the dimensions of each data frame
cat('Final = ',dim(df.final)[1], '\n',
    'Unmatched = ',dim(df.unmatched)[1], '\n',
    'Covid = ',dim(df.covid)[1], '\n')

# Combine the keys from all data frames
excelkeys <- c(df.final$key, df.unmatched$key, df.covid$key)


### Create Tables from this information

# Select columns for the final data frame
selectfinal <- df.final %>% select(
  id,
  key,
  title,
  year,
  journal,
  dois,
  labels,
  drugs,
  disease,
  diseasearea = `disease area`,
  patients,
  pediatric,
  method,
  center,
  CO,
  multinational
)

# Select columns for the unmatched data frame
selectunmatched <- df.unmatched %>% select(
  id = ID,
  key,
  title,
  year,
  journal,
  dois,
  labels,
  drugs,
  disease,
  diseasearea = `disease area`,
  patients,
  pediatric,
  method,
  center,
  CO,
  multinational
)

# Select columns for the COVID data frame
selectcovid <- df.covid %>% select(
  id,
  key,
  title,
  year,
  journal,
  dois,
  labels,
  drugs,
  disease,
  diseasearea = `disease area`,
  patients,
  pediatric,
  method,
  center,
  CO,
  multinational
)

# Combine all the selected data frames
selectall <- rbind(selectfinal, selectunmatched, selectcovid)
selectall$casereport = selectall$patients == 1

# Write the combined data frame to a file
write.table(selectall, 'selectall.csv', sep = "\t")
read.table('selectall.csv')

## Diseases

top <- 10

# Update disease names
selectall$disease[which(selectall$disease == 'NSCLC')] <- 'Lung Cancer'
selectall$disease <- stri_trans_totitle(selectall$disease)
selectall$drugs <- stri_trans_tolower(selectall$drugs)
select```



selectall$disease[which(selectall$disease == 'Covid-19')] <- 'COVID-19'

diseasetable <- selectall %>% count(diseasearea, sort=TRUE) 
otherdiseases <- diseasetable$diseasearea[(top+1):length(diseasetable$diseasearea)]
dis <- selectall
dis$diseasearea[which(dis$diseasearea %in% otherdiseases)] <- 'Other'
otherdiseasetable <- dis %>% count(diseasearea, sort=TRUE) 
otherdiseasetable$percent <- round(100 * otherdiseasetable$n/(sum(otherdiseasetable$n)),0)

## Countries

countrynational <- selectall[which(selectall$multinational==FALSE),] 
countrynational$Country <- countryname(countrynational$CO)
countrynational$ISO3C <- countryname(countrynational$Country, destination = 'iso3c')
countrynational$continent <- countryname(countrynational$Country, destination = 'continent')
countrynational$naregion <- countryname(countrynational$Country, destination = 'region')
countrynational$region <- countryname(countrynational$Country, destination = 'un.regionsub.name')
countrytable <- countrynational %>% count(Country, sort=TRUE) 
countrytable <- countrynational %>% group_by(Country) %>% summarize(n = n(), patients = sum(patients, na.rm=T)) %>% arrange(desc(n))
countrytable$ISO3C  <- countryname(countrytable$Country, destination = 'iso3c')

regiontable <- countrynational %>% count(region, sort=TRUE) 
countrynational$patients <- as.numeric(countrynational$patients,na.rm=T)
naregiontable <- countrynational  %>% group_by(naregion) %>% summarize(publications = n(), patients = sum(patients, na.rm=T)) %>% arrange(desc(publications))
regiontable <- countrynational  %>% group_by(region) %>% summarize(publications = n(), patients = sum(patients, na.rm=T)) %>% arrange(desc(publications))
continenttable <- countrynational %>% group_by(continent) %>% summarize(publications = n(), patients = sum(patients, na.rm=T)) %>% arrange(desc(publications))

countrytop <- countrytable[1:25,]
countrytop$ISO3C <- countryname(countrytop$Country, destination = 'iso3c')
countries <- as.data.frame(read.csv2("PATH_TO_NATIONS_CSV", sep = ','))
for(i in 1:length(countrytop$Country)){
  ISO3C <- countrytop$ISO3C[i]
  countrytop$Population[i] <- round(mean(as.numeric(countries$population[intersect(which(countries$iso3c == ISO3C),which(countries$year > 2005))]))/1000000,1)
}
countrytop$Country <- countryname(countrytop$Country)
countrytop$continent <- countryname(countrytop$Country, destination = 'continent')
countrytop$region <- countryname(countrytop$Country, destination = 'region')
countrytop$Productivity <- round(countrytop$n/countrytop$Population,1)

relativecountrytop <- countrytop %>% arrange(desc(Productivity))

drugdis <- as.data.frame(unlist(str_split(selectall$drugs, '; ')))
colnames(drugdis) <- c('drugs')
lengthuniquedrugs<- length(unique(drugdis$drugs))
drugtable <- drugdis %>% count(drugs, sort=TRUE)
drugtable$percent <- round(100 * drugtable$n/(sum(drugtable$n)),0)

# initialize columns
drugtable$diseases <- NULL
drugtable$pats <- NULL
drugtable$patients <- NULL

sel <- grep(drug, selectall$drugs, ignore.case = TRUE)
drugtable$diseases[i] <- paste0(unique(selectall$disease[sel]), collapse = ", ")
drugtable$pats[i] <- sum(selectall$patients[sel], na.rm = TRUE)
drugtable$patients[i] <- length(sel)
}

# Sort the drug table by number of occurrences in descending order
drugtable <- drugtable[order(-drugtable$n),]

# Filter out drugs with less than 1% occurrence
drugtable <- drugtable[drugtable$percent >= 1,]

# Merge disease and patient information into drug table
drugtable <- merge(drugtable, other = otherdiseasetable, by.x = "drugs", by.y = "diseasearea", all.x = TRUE)

# Remove unnecessary columns
drugtable$diseases.y <- NULL
drugtable$percent.y <- NULL

# Rename columns
colnames(drugtable)[3] <- "Diseases"
colnames(drugtable)[4] <- "Total Patients"
colnames(drugtable)[5] <- "Publications"
colnames(drugtable)[6] <- "Other Diseases"
colnames(drugtable)[7] <- "Other Publications"


