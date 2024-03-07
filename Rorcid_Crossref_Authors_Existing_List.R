# Script by Olivia Given Castello, based on: https://ciakovx.github.io/rorcid.html 
# and 04-rcrossref_metadata.R at https://github.com/ciakovx/fsci2022/tree/main/code
# Retrieves ORCID profile and Crossref metadata for authors from a given institution, 
# since a given year, paired with that of the co-authors with whom they collaborated.

# Install and load packages -----------------------------------------------

# you will need to install these packages first, using the following
# if you've already installed them, skip this step
#install.packages('dplyr')
#install.packages('tibble')
#install.packages('tidyr')
#install.packages('purrr')
#install.packages('readr')
#install.packages('stringr')
#install.packages('jsonlite')
#install.packages('lubridate')
#install.packages('ggplot2')
#install.packages('httr')
#install.packages('forcats')
#install.packages('rorcid')
#install.packages('usethis')
#install.packages('anytime')
#install.packages('janitor')
#install.packages('glue')
#install.packages('remotes')
#remotes::install_github("ropensci/rcrossref")
#install.packages('roadoi')
#install.packages('inops')

# load the packages
library(dplyr)
library(tibble)
library(tidyr)
library(purrr)
library(readr)
library(stringr)
library(jsonlite)
library(lubridate)
library(ggplot2)
library(httr)
library(forcats)
library(usethis)
library(anytime)
library(janitor)
library(glue)
library(rorcid)
library(rcrossref)
library(roadoi)
library(inops)

# remove all objects from the environment to start with a clean slate
rm(list = ls())

# Set up orcid / crossref in R environment ------------------------------------------------------------

# if you've already done these steps and set up your bearer token in RStudio
# you can skip to the next section: "set some variablees and build the query"

# 1. If you haven’t done so already, create an ORCID account at https://orcid.org/signin. 
# 2. In the upper right corner, click your name, then in the drop-down menu, click Developer Tools. Note: In order to access Developer Tools, you must verify your email address. 
# 3. If you have not already verified your email address, you will be prompted to do so at this point.
# 4. Click the “Register for the free ORCID public API” button
# 5. Review and agree to the terms of service when prompted.
# 6. Add your name in the Name field, https://www.orcid.org in the Your Website URL field, “Getting public API key” in Description field, and https://www.orcid.org in the redirect URI field. Click the diskette button to save.
# 7. A gray box will appear including your Client ID and Client Secret. In the below code chunk, copy and paste the client ID and the client secret respectively. 
# 8. Make sure to leave the quotation marks (e.g. orcid_client_id <- "APP-FDFJKDSLF320SDFF" and orcid_client_secret <- "c8e987sa-0b9c-82ed-91as-1112b24234e"). 

# copy/paste your client ID from https://orcid.org/developer-tools
orcid_client_id <- "PASTE MY CLIENT ID HERE"

# copy/paste your client secret from https://orcid.org/developer-tools
orcid_client_secret <- "PASTE MY CLIENT SECRET HERE"

# This gets a /read-public scope access token
orcid_request <- POST(url  = "https://orcid.org/oauth/token",
                      config = add_headers(`Accept` = "application/json",
                                           `Content-Type` = "application/x-www-form-urlencoded"),
                      body = list(grant_type = "client_credentials",
                                  scope = "/read-public",
                                  client_id = orcid_client_id,
                                  client_secret = orcid_client_secret),
                      encode = "form")

# parse the API request with content
orcid_response <- content(orcid_request)

# run the following code
print(orcid_response$access_token)

#You will see a string of text print out in your R console.
# Copy that string to the clipboard 
# so we can  save the token to our R environment
# Run this code:
usethis::edit_r_environ()

# A new window will open in RStudio.
# In this separate R environment page, type the following (except the pound sign):
# ORCID_TOKEN="my-token"
# replace 'my-token' with the access_token you just copied. 
# Then press enter to create a new line.
# while we are here, we'll add in our rcrossref credentials
# type crossref_email="name@example.com", using your own email address.
# press enter to create a new line, and leave it blank. 
# Press Ctrl + S (Mac: Cmd + S) to save this information to your R environment and close the window. 
# You won't see anything happen here because it is just saving the page.

# Click Session > Restart R. Your token should now be saved to your R environment. 

# You will now need to rerun all the packages ("library()" commands) above, then return to this line.

#You can confirm this worked by calling orcid_auth(), and it will print the token
rorcid::orcid_auth()


# set some variablees and build the query  --------------------------------------------------------

# set the working directory where this script is
# a folder called "data" is also expected to be in this directory
# example: setwd("C:/Users/rabun/OneDrive - LYRASIS/Documents/RsearchResults")
setwd("PASTE WORKING DIRECTORY HERE")

# set the time period of interest: this script will compile collaboration data since Jan 1 of this year.
# replace the YYYY with a 4 digit year.
# the more years of data desired, the longer some portions of this script will take to run
my_year = YYYY;

# set the institution's main location information (for use when precise location info is blank)
# example:
# anchor_org<-"The Gordon and Betty Moore Foundation"
# anchor_city<-"Palo Alto"
# anchor_region<-"CA"
# anchor_country<-"US"
anchor_org<-"Organization Name"
anchor_city<-"City"
anchor_region<-"State"
anchor_country<-"Country"

# read in your list of existing ORCID iDs - it should be a csv file named my_orcids_data and should be formatted with three columns:
# first column should be titled orcid_identifier_uri and should contain a list of the full ORCID ID URL for each person (example: https://orcid.org/0000-0002-0375-8429)
# second column should be titled orcid_identifier_path and should contain a list of just the 16 digit ORCID numbers for each person (example: 0000-0002-0375-8429)
# third column should be titled orcid_identifier_host and should contain a list of just the 16 digit ORCID numbers for each person (example: 0000-0002-0375-8429)
my_orcids_data <- read_csv("./data/my_orcids_data.csv", col_types = cols(.default = "c"))


# get employment data -----------------------------------------------------

# get the employments from the orcid_identifier_path column
##### TIME: be patient, this may take a long time (e.g. for Temple University's data [~3500 IDs], this took ~8 minutes)
my_employment <- rorcid::orcid_employments(my_orcids_data$orcid_identifier_path)

##### WRITE/READ JSON uncomment to work with this data outside of R or read it back in later
#to_write<-toJSON(my_employment, na="null")
#write(to_write,"./data/employment.json")

# read it back in, if necessary
#my_employment <- read_json("./data/processed/employment.json", simplifyVector = TRUE)
##### WRITE/READ JSON

# extract the employment data and mutate the dates
my_employment_data <- my_employment %>%
  purrr::map(., purrr::pluck, "affiliation-group", "summaries") %>% 
  purrr::flatten_dfr() %>%
  janitor::clean_names() %>%
  dplyr::mutate(employment_summary_end_date = anytime::anydate(employment_summary_end_date/1000),
                employment_summary_created_date_value = anytime::anydate(employment_summary_created_date_value/1000),
                employment_summary_last_modified_date_value = anytime::anydate(employment_summary_last_modified_date_value/1000))

# clean up the column names
names(my_employment_data) <- names(my_employment_data) %>%
  stringr::str_replace(., "employment_summary_", "") %>%
  stringr::str_replace(., "source_source_", "") %>%
  stringr::str_replace(., "organization_disambiguated_", "")

# view the unique institutions in the organization names columns
# keep in mind this will include all institutions a person has in their employments section
my_organizations <- my_employment_data %>%
  group_by(organization_name) %>%
  count() %>%
  arrange(desc(n))

# view the variation in organization names by looking at my_organization_filtered (will open a new tab)
# view(my_organizations)

# Note that this will give you employment records only. 
# In other words, each row represents a single employment record for an individual.
# the name_value variable refers specifically to the name of the person or system
# that wrote the record, NOT the name of the individual. 

# To get that, you must first get all the unique ORCID iDs from the dataset:

# There is no distinct value identifying the orcid ID of the person.
# The orcid_path value corresponds to the path of the person who added the employment record (which is usually, but not always the same)
# Therefore you have to strip out the ORCID iD from the 'path' variable first and put it in it's own value and use it
# We do this using str_sub from the stringr package
# While we are at it, we can select and reorder the columns we want to keep
current_employment_all <- my_employment_data %>%
  mutate(orcid_identifier = str_sub(path, 2, 20)) %>%
  select(any_of(c("orcid_identifier",
                  "organization_name",
                  "organization_address_city",
                  "organization_address_region",
                  "organization_address_country",
                  "organization_identifier",
                  "organization_disambiguated_organization_identifier",
                  "organization_disambiguation_source",
                  "department_name",
                  "role_title",
                  "url_value",
                  "display_index",
                  "visibility",
                  "created_date_value",
                  "start_date_year_value",
                  "start_date_month_value",
                  "start_date_day_value",
                  "end_date_year_value",
                  "end_date_month_value",
                  "end_date_day_value")))

# next, create a new vector unique_orcids that includes only unique ORCID iDs from our filtered dataset.     
unique_orcids <- unique(current_employment_all$orcid_identifier) %>%
  na.omit(.) %>%
  as.character()

# then run the following expression to get all biographical information for those iDs.
##### TIME: This may take anywhere from a few seconds to a few minutes (e.g. for Temple University's data [~700 IDs], this took ~1.5 minutes)
my_orcid_person <- rorcid::orcid_person(unique_orcids)

# then we construct a data frame from the response. 
# See more at https://ciakovx.github.io/rorcid.html#Getting_the_data_into_a_data_frame for this.
my_orcid_person_data <- my_orcid_person %>% {
  dplyr::tibble(
    given_name = purrr::map_chr(., purrr::pluck, "name", "given-names", "value", .default=NA_character_),
    created_date = purrr::map_chr(., purrr::pluck, "name", "created-date", "value", .default=NA_integer_),
    last_modified_date = purrr::map_chr(., purrr::pluck, "name", "created-date", "value", .default=NA_character_),
    family_name = purrr::map_chr(., purrr::pluck, "name", "family-name", "value", .default=NA_character_),
    credit_name = purrr::map_chr(., purrr::pluck, "name", "credit-name", "value", .default=NA_character_),
    other_names = purrr::map(., purrr::pluck, "other-names", "other-name", "content", .default=NA_character_),
    orcid_identifier_path = purrr::map_chr(., purrr::pluck, "name", "path", .default = NA_character_),
    biography = purrr::map_chr(., purrr::pluck, "biography", "content", .default=NA_character_),
    researcher_urls = purrr::map(., purrr::pluck, "researcher-urls", "researcher-url", .default=NA_character_),
    emails = purrr::map(., purrr::pluck, "emails", "email", "email", .default=NA_character_),
    keywords = purrr::map(., purrr::pluck, "keywords", "keyword", "content", .default=NA_character_),
    external_ids = purrr::map(., purrr::pluck, "external-identifiers", "external-identifier", .default=NA_character_))
} %>%
  dplyr::mutate(created_date = anytime::anydate(as.double(created_date)/1000),
                last_modified_date = anytime::anydate(as.double(last_modified_date)/1000))

# Join it back with the employment records so that the employment data now includes organization city, region, country
orcid_person_employment_join <- my_orcid_person_data %>%
  left_join(current_employment_all, by = c("orcid_identifier_path" = "orcid_identifier"))

##### WRITE/READ CSV uncomment to save this data and read it back in later
#write_csv(orcid_person_employment_join, "./data/orcid_employment_file.csv")

# read it back in, if necessary
#orcid_person_employment_join <- read_csv("./data/orcid_employment_file.csv", col_types = cols(.default = "c"))
##### WRITE/READ CSV


# get works data -----------------------------------------------------

# create a vector of unique, unduplicated ORCID IDs from that file
my_orcids <- orcid_person_employment_join %>%
  filter(!duplicated(orcid_identifier_path)) %>%
  pull(orcid_identifier_path) %>%
  na.omit() %>%
  as.character()

# Call the orcid_works function to collect all works associated with each ID
##### TIME: This may take anywhere from a few seconds to a few minutes (e.g. for Temple University's data [~700 IDs], this took ~2.5 minutes)
my_works <- rorcid::orcid_works(my_orcids)

##### WRITE/READ JSON uncomment to work with this data outside of R or read it back in later
#to_write<-toJSON(my_works, na="null")
#write(to_write,"./data/my_works.json")

# read it back in, if necessary
#my_works <- read_json("./data/my_works.json", simplifyVector = TRUE)
##### WRITE/READ JSON

# turn the JSON file into a unique data frame by looping through the file,
# extracting ("pluck") the object, bind the rows together with(this is the "_dfr" part of map_dfr)
# then clean column names
# and convert the dates from Unix time to yyyy-mm-dd
my_works_data <- my_works %>%
  purrr::map_dfr(pluck, "works") %>%
  janitor::clean_names() %>%
  dplyr::mutate(created_date_value = anytime::anydate(created_date_value/1000),
                last_modified_date_value = anytime::anydate(last_modified_date_value/1000))

# we only want to keep works that have an external identifier
# (specifically, a DOI), so we first filter to keep only objects that have an external_id value
# then unnest those: in other words expand to include a row for every work + external id value
# (in other words, one work might be linked to a DOI, a PubMed ID, an ISSN, etc.)
my_works_externalIDs <- my_works_data %>% 
  dplyr::filter(!purrr::map_lgl(external_ids_external_id, purrr::is_empty)) %>% 
  tidyr::unnest(external_ids_external_id) %>%
  clean_names()

# From those unnested external IDs, we want to keep only those with a DOI, as that is the 
# value we'll use to look up the items in Crossref.
# We then select a few relevant columns, and finally create a new column DOI that takes the external_id_value column
# and coerces it to lower case, and the orcid_identifier column which strips out the ORCID ID
# from the path variable.
dois <- my_works_externalIDs %>%
  filter(external_id_type == "doi") %>%
  select(type, path, title_title_value, external_id_type, external_id_value, external_id_relationship,
         url_value, publication_date_year_value, publication_date_month_value, publication_date_day_value,
         journal_title_value) %>%
  mutate(doi = tolower(external_id_value),
         orcid_identifier = str_sub(path, 2, 20))

# there are some duplicated values here: we can't just look at duplicate DOIs because some of these
# works were co-authored, and we want to keep that data (i.e. unique orcid + doi combinations)
# This function will let you look at observations where both the orcid ID and the DOI are duplicated in 
# case you want to review them more closely. 
# In our case below, we just keep the first appearance of a unique orcid + doi combination and discard
# all subsequent ones.
dupes <- dois %>%
  get_dupes(orcid_identifier, doi)

# Here we are preparing the orcid dataset for merging to publications. 
# We keep only Orcid ID, first name and last name, remove duplicates, and rename orcid_identifier
orcid_empl_merge <- orcid_person_employment_join %>%
  select(orcid_identifier_path, given_name, family_name) %>%
  filter(!duplicated(orcid_identifier_path)) %>%
  rename(orcid_identifier = orcid_identifier_path)

# Finally, we remove the duplicates by creating a new variable that is a combination of
# the orcid ID and the DOI, and keeping only the first instance. We then join that to our 
# cleaned orcid ID file and write to csv
dois_unduped <- dois %>%
  mutate(orcid_doi = paste0(orcid_identifier, doi)) %>%
  filter(!duplicated(orcid_doi)) %>%
  left_join(orcid_empl_merge, by = "orcid_identifier")

##### WRITE/READ CSV uncomment to save this data and read it back in later
#write_csv(dois_unduped, "./data/orcid_dois.csv")

# read it back in, if necessary
#dois_unduped <- read_csv("./data/orcid_dois.csv")
##### WRITE/READ CSV


# get CrossRef data -----------------------------------------------------

# We start by subsetting our unduped dois to include only since the year that we want
# this is the year of publication according to the ORCID profile works data
dois_since_year <- dois_unduped %>%
  filter(publication_date_year_value >= my_year)

# This will loop through the column of dois and perform a function that
# prints the doi (this allows you to ensure it's progressing)
# there will be warning messages for any DOIs not found at CrossRef
##### TIME This will take a long time for large datasets (e.g. for Temple University's 2022 data [800+ DOIs], this took ~6 minutes)
 metadata_since_year <- map(dois_since_year$doi, function(z) {
   print(z)
   o <- cr_works(dois = z)
   return(o)
 })

##### Code improvement
# Here we could create a similar function that queries DataCite for metadata on the ones that weren't found in CR
# Also rather than DOIs SINCE a given year, it might be desired to retrieve data on DOIs from a discrete year, 
# or from a time period with specific start and end dates.
##### Code improvement


##### WRITE/READ JSON uncomment to work with this data outside of R or read it back in later
#write_file_path = paste0("./data/metadata_",my_year,".json")
#to_write<-toJSON(metadata_since_year, pretty=TRUE, na="null")
#write(to_write,write_file_path)

# read it back in, if necessary
#metadata_since_year <- read_json(write_file_path, simplifyVector = TRUE)
##### WRITE/READ JSON

# This will loop through each result, extract ("pluck") the object called "data"
# bind it together into a dataframe (the "dfr" part of map_dfr)
# clean the names up and filter to remove any duplicates
metadata_since_year_df <- metadata_since_year %>%
  map_dfr(., pluck("data")) %>%
  clean_names() %>%
  filter(!duplicated(doi))

# We next want to prepare our orcid data frame to merge to the crossref data by selecting only the relevant columns.
# Rows with no CrossRef data (like issued from DataCite) are still present here 
# anything published in an earlier time frame will be removed
orcid_merge <- dois_since_year %>%
  select(orcid_identifier, doi, given_name, family_name)

# select relevant columns
cr_merge <- metadata_since_year_df %>%
  select(any_of(c("doi",
                  "title",
                  "published_print", 
                  "published_online", 
                  "issued", 
                  "container_title",
                  "issn",
                  "volume",
                  "issue",
                  "page",
                  "publisher",
                  "language",
                  "isbn",
                  "url",
                  "type",
                  "subject",
                  "reference_count",
                  "is_referenced_by_count",
                  "subject",
                  "alternative_id",
                  "author",
                  "pdf_url")))

# CrossRef metadata was retrieved for Works on the ORCID profile with publication year >= my_year
# however the DOI issued date may earlier than my_year, could be NA, or will have missing month or day info
# if an issued date from CrossRef is NA, we will fill it in as my_year-01-01
# if issued is a partial date, we fill in with January 1, or the 1st of the month 
# so that in Tableau they will render properly as dates
jan1date<-paste0(my_year,"-01-01")
cr_merge$issued<-cr_merge$issued %>% replace_na(jan1date)
cr_merge <- cr_merge %>% add_column(issued2 = "", .after = "issued") 
cr_merge <- cr_merge %>%
  mutate(
    issued2 = if_else(
      condition = nchar(trim(issued)) == 7,
      true      = paste0(issued,"-01"),
      false     = issued
    )
  ) %>% 
  mutate(
    issued2 = if_else(
      condition = nchar(trim(issued)) == 4, 
      true      = paste0(issued,"-01-01"), 
      false     = issued2
    )
  )
cr_merge$issued<-cr_merge$issued2
cr_merge <- cr_merge %>% select(-(issued2))


# build an author ORCID ID reference table -----------------------------------------------------
# it will help us fill in blanks later if we start building a dataframe of full author names with their ORCID

# start with the orcid_person_employment_join dataframe of employment data for home authors
# create a fullname identifier for the home author that is striped of punctuation and whitespace
orcid_person_employment_join$fullname <- with(orcid_person_employment_join, paste(given_name,family_name))
orcid_person_employment_join$fullname <- str_replace_all(orcid_person_employment_join$fullname, "[^[:alnum:]]", " ")
orcid_person_employment_join$fullname<-str_replace_all(orcid_person_employment_join$fullname, fixed(" "), "")

# select relevant columns
master_names <- orcid_person_employment_join %>%
  select(any_of(c("fullname",
                  "orcid_identifier_path",
                  "department_name",
                  "organization_name",
                  "organization_address_city",
                  "organization_address_region",
                  "organization_address_country"
                  )))
master_names <- master_names[!duplicated(master_names$orcid_identifier_path),]

# get the credit_name, an alternate version of their name and make a row for that
credit_names <- orcid_person_employment_join %>%
  filter(!is.na(credit_name)) %>%
  select(any_of(c("credit_name",
                  "orcid_identifier_path",
                  "department_name",
                 "organization_name",
                 "organization_address_city",
                 "organization_address_region",
                 "organization_address_country"
                    ))) %>%
  rename(fullname = credit_name)

# strip the fullname identifier of punctuation and whitespace
credit_names$fullname <- str_replace_all(credit_names$fullname, "[^[:alnum:]]", " ")
credit_names$fullname<-str_replace_all(credit_names$fullname, fixed(" "), "")

# remove duplicate rows
credit_names <- credit_names[!duplicated(credit_names$orcid_identifier_path),]

# concatenate these two data frames to start our author ORCID ID reference table
names_df <- rbind(master_names,credit_names)


# get co-author information -----------------------------------------------------

# The authors for each DOI in the cr_merge dataframe are in a nested list. 
# In order to collect information about them, we must unnest the list,
# Then we will build a list of home author, co-author pairs and try ti fill in any unknown ORCID
# and location info about the co-authors

# unnest the author list for each DOI
what_auths <- cr_merge %>% unnest(author)

# left join this DOI authors list to our list of home authors by DOI
# this gives us a df where there is an individual row for each home author and co-author on a  DOI
authlist_all <- what_auths %>%
  left_join(orcid_merge, by = "doi")

# when multiple home authors have collaborated on a DOI there will be several sets of
# rows for that DOI in the data frame - one set for each home author
# we keep these because we're counting each home author and all their collaborations, including within institution

# we do want to remove rows produced by the join where the home author (orcid_identifier) is 
# the same as the co-author (ORCID) - so where orcid_identifier = str_sub(ORCID , 18, 37)
# AND where the home author / co-author names are exactly the same
# this will miss slight variations in names when there is no ORCID ID on the cross ref record (e.g. Bradley Baker vs. Bradley J. Baker)

# add some columns to authlist_all to help with this deduplicating
authlist_all$orcid_coauth <- with(authlist_all, 
                                  ifelse(is.na(ORCID),'',str_sub(ORCID , 18, 37))
)

# fullname identifier for the home author, striped of punctuation and whitespace
authlist_all$anchorfullname <- with(authlist_all, paste(given_name,family_name))
authlist_all$anchorfullname <- str_replace_all(authlist_all$anchorfullname, "[^[:alnum:]]", " ")
authlist_all$anchorfullname<-str_replace_all(authlist_all$anchorfullname, fixed(" "), "")

# fullname identifier for the co-author, striped of punctuation and whitespace
authlist_all$coauthfullname <- with(authlist_all, paste(given,family))
authlist_all$coauthfullname <- str_replace_all(authlist_all$coauthfullname, "[^[:alnum:]]", " ")
authlist_all$coauthfullname<-str_replace_all(authlist_all$coauthfullname, fixed(" "), "")

## create a new df with the identical entries removed
authlist_nodups <- subset(authlist_all, (orcid_identifier != orcid_coauth))
authlist_nodups <- subset(authlist_nodups, (anchorfullname != coauthfullname))

# next it would be good to fill in ORCID if there is a co-author name variation that 
# we are already aware of and logged in names_df, our author ORCID ID reference table
# when there are author name variations that we are not aware of, and there is no ORCID ID
# there is just no way to resolve them, so the occasional row where home author and co-author are the same will persist 

##### Code improvement
# there are many times when we could try to fill in info from the author ORCID ID reference table
# in order to keep refining the data. so it would be good to take this code out and
# put it in a function that we could just call here instead of re-running similar lines of code
##### Code improvement

#### TIME: These joins hang a bit if the lists are very large (e.g. for Temple University's 2022 data [>2700 names], all these joins took ~10 seconds)
# left join to add ORCIDs from our reference table to the author list
my_join <- left_join(authlist_nodups,names_df,by=c("coauthfullname" = "fullname"))

# fill in the joined ORCID where orcid_coauth is blank
my_join[ my_join$orcid_coauth == "", "orcid_coauth" ] <- my_join[ my_join$orcid_coauth == "", "orcid_identifier_path" ]

# this reintroducies NA values into the data fram, so replace those with blanks again
my_join <- my_join %>% 
  mutate_at('orcid_coauth', ~replace_na(.,""))

# do another pass to eliminate rows with the same anchor author and co-author ORCID from the ones we just filled in
authlist_nodups <- subset(my_join, (orcid_identifier != orcid_coauth))


# now that we tried to fill in co-author ORCID IDs we can also fill in 
# co-author current affiliations and location information that we have in the reference table names_df

# but we have to use a version of the names_df where orcid is unique
orcid_df <- names_df

# remove duplicate orcid rows
orcid_df <- orcid_df[!duplicated(orcid_df$orcid_identifier_path),]

my_join <- left_join(authlist_nodups,orcid_df,by=c("orcid_coauth" = "orcid_identifier_path"))

# fill in the joined location fields where any co-author locations are blank
my_join <- my_join %>% 
  mutate(department_name.x = coalesce(department_name.x,department_name.y),
         organization_name.x = coalesce(organization_name.x,organization_name.y),
         organization_address_city.x = coalesce(organization_address_city.x,organization_address_city.y),
         organization_address_region.x = coalesce(organization_address_region.x,organization_address_region.y),
         organization_address_country.x = coalesce(organization_address_country.x,organization_address_country.y)
  )

# drop some columns we don't need
authlist_nodups <- subset(my_join, select = -c(orcid_identifier_path,department_name.y,organization_name.y, organization_address_city.y, organization_address_region.y, organization_address_country.y))

# now we have authlist_nodups, a dataframe where there is a row for every co-author on a DOI except for the home author duplicate (ideally),
# and each row also includes the home author's name and ORCID ID, and as much info about the co-author as we have so far


# build the output file -----------------------------------------------------

# we eventually want to output a CSV with these columns:
# fname1, lname1, orcid1, affiliation1, org1, city1, region1, country1, fname2, lname2, orcid2, affiliation2, org2, city2, region2, country2, DOI

# create a dataframe with the columns we need
co_authors <- authlist_nodups %>%
  select(any_of(c("doi",
                  "issued",
                  "given_name",
                  "family_name", 
                  "orcid_identifier", 
                  "given", 
                  "family",
                  "orcid_coauth",
                  "affiliation.name",
                  "organization_name.x",
                  "organization_address_city.x",
                  "organization_address_region.x",
                  "organization_address_country.x"
  )))

# rename some columns
co_authors <- co_authors %>% 
  rename(
    fname1 = given_name,
    lname1 = family_name,
    orcid1 = orcid_identifier,
    fname2 = given,
    lname2 = family,
    orcid2 = orcid_coauth,
    affiliation2 = affiliation.name,
    org2 = organization_name.x,
    city2 = organization_address_city.x,
    region2 = organization_address_region.x,
    country2 = organization_address_country.x
  )

# add in columns of home author info affiliation and location info
# join the info in from our orcid_df reference table
co_authors <- left_join(co_authors,orcid_df,by=c("orcid1" = "orcid_identifier_path"))

# rename the joined affiliation and location fields for the home author
co_authors <- co_authors %>% 
  rename(
    affiliation1 = department_name,
    org1 = organization_name,
    city1 = organization_address_city,
    region1 = organization_address_region,
    country1 = organization_address_country
  )

# move the columns around
co_authors <- co_authors %>% relocate(affiliation1, org1, city1, region1, country1, .after = orcid1)

# fill in with static values if there are blanks -- there realy shouldn't be any but just in case
co_authors$org1[co_authors$org1 == "" | co_authors$org1 == " " | is.na(co_authors$org1)]<- anchor_org
co_authors$city1[co_authors$city1 == "" | co_authors$city1 == " " | is.na(co_authors$city1)]<- anchor_city
co_authors$region1[co_authors$region1 == "" | co_authors$region1 == " " | is.na(co_authors$region1)]<- anchor_region
co_authors$country1[co_authors$country1 == "" | co_authors$country1 == " " | is.na(co_authors$country1)]<- anchor_country


# though we might have filled in a few pieces of co-author info for some of the co-authors from the same institution above,
# we stil need city, region, and country for many of the co-authors. we can try to retrive this if we have the co-authors ORCID ID
# we'll make a unique list of co-author's who have ORCID IDs and get their CURRENT affiliation
# we chose to get their current affiliation because this is the same way we treat home authors 
# (they are a home author because of their current affiliation, 
# even though they may have published a DOI in the past when affiliated with a different organization)
co_auth_ids <- co_authors$orcid2
co_auth_ids_unduped <- unique(co_auth_ids[co_auth_ids != ""])

# if a value in co_auth_ids_unduped gives an error when you try to generate my_co_auths_employment below
# (like that it is locked and cannot be edited)
# remove it from the list by filling in the problem ORCID ID (format XXXX-XXXX-XXXX-XXXX), uncommenting, and running this statement
# then try to generate my_co_auths_employment again
#co_auth_ids_unduped <- co_auth_ids_unduped[ co_auth_ids_unduped != "enter problem ORCID ID here in format XXXX-XXXX-XXXX-XXXX"]

# get the co-authors employment data from their ORCID profile
##### TIME: This may take anywhere from a few seconds to a few minutes (e.g. for Temple University's 2022 data [>850 IDs], this took ~2 minutes)
my_co_auths_employment <- rorcid::orcid_employments(co_auth_ids_unduped)

##### JSON
# you can write the file to json if you want to work with it outside of R
#to_write<-toJSON(my_co_auths_employment, na="null")
#write(to_write,"./data/co_auths_employment.json")

# read it back in, if necessary
#my_co_auths_employment <- read_json("./data/co_auths_employment.json", simplifyVector = TRUE)
##### JSON
 
# extract the employment data and mutate the dates
my_co_auths_employment_data <- my_co_auths_employment %>%
  purrr::map(., purrr::pluck, "affiliation-group", "summaries") %>% 
  purrr::flatten_dfr() %>%
  janitor::clean_names() %>%
  dplyr::mutate(employment_summary_end_date = anytime::anydate(employment_summary_end_date/1000),
                employment_summary_created_date_value = anytime::anydate(employment_summary_created_date_value/1000),
                employment_summary_last_modified_date_value = anytime::anydate(employment_summary_last_modified_date_value/1000))

# clean up column names
names(my_co_auths_employment_data) <- names(my_co_auths_employment_data) %>%
  stringr::str_replace(., "employment_summary_", "") %>%
  stringr::str_replace(., "source_source_", "") %>%
  stringr::str_replace(., "organization_disambiguated_", "")

# some rows have orcid_path = NA, for these put the ORCID ID back with substring of path
my_co_auths_employment_data <- my_co_auths_employment_data %>% 
  mutate(orcid_path = coalesce(orcid_path,substring(path,2,20)))

# get the co-authors' current affiliations
# this will miss co-authors who have no current employment line (with no end date) in their ORCID profile
my_co_auths_employment_data_filtered_current <- my_co_auths_employment_data %>%
  dplyr::filter(is.na(end_date_year_value))

# some co-authors may have multiple "current" affiliations
# seperate out those with no start date year value and those that do have start dates
my_co_auths_current_emp_nodate <- subset(my_co_auths_employment_data_filtered_current, is.na(start_date_year_value))
my_co_auths_current_emp_date <- subset(my_co_auths_employment_data_filtered_current, !is.na(start_date_year_value))

# for those with a start date, choose the row with the most recent year
latest_dates <- my_co_auths_current_emp_date %>%
  group_by(orcid_path) %>%
  slice(which.max(start_date_year_value)) %>%
  arrange(start_date_year_value)

co_auths_latest_emp <- rbind(my_co_auths_current_emp_nodate,latest_dates)

# there will STILL be duplicates because of people with a mix of undated and dated ORCID profile employment entries, 
# group again and use the latest entry date
co_auths_very_latest_emp  <- co_auths_latest_emp  %>%
  group_by(orcid_path) %>%
  slice(which.max(created_date_value)) %>%
  arrange(created_date_value)

# be double sure that we removed duplicate orcid rows
co_auths_very_latest_emp <- co_auths_very_latest_emp[!duplicated(co_auths_very_latest_emp$orcid_path),]

# for the co-authors that had ORCID profiles and for whom we now have a current employment data point, join them back to the co_authors dataframe
co_authors_full_info <- left_join(co_authors,co_auths_very_latest_emp,by=c("orcid2" = "orcid_path"))

# If org2, city2, region2, country2 had been NA in the dataframe we are building to output, fill from the joined table fields 
co_authors_full_info <- co_authors_full_info %>% 
  mutate(org2 = coalesce(org2,organization_name),
         city2 = coalesce(city2,organization_address_city),
         region2 = coalesce(region2,organization_address_region),
         country2 = coalesce(country2,organization_address_country)
  )

# drop some columns we don't need
co_authors_full_info <- co_authors_full_info %>% select(doi:country2)

##### Code improvement
# from here you could do yet ANOTHER round of recording co-author fullnames and ORCID IDs to the reference dataframe, 
# then fill in blanks in the full_info df
# when the code that does that is pulled out into its own function, that won't take a lot of space to do
##### Code improvement

# get rid of NA values
co_authors_full_info[is.na(co_authors_full_info)] <- ""


# clean up US state names so they produce single locations on the Tableau map
# set up a dataframe of state names and abbreviations
states_df<- data.frame(state.abb, state.name, paste0(state.name,'US'))
colnames(states_df) <- c('abb','name','id')

# left join the correct state abbreviation for only US states with the full state name spelled out
# starting with the home authors' region1
co_authors_full_info$state1<-with(co_authors_full_info,paste0(region1,country1))
co_authors_full_info <- left_join(co_authors_full_info,states_df,by=c("state1" = "id"))

# overwrite the full state names with the abbreviations where they occur
co_authors_full_info$region1 <- ifelse(is.na(co_authors_full_info$abb), co_authors_full_info$region1, co_authors_full_info$abb )

# drop the joined columns
co_authors_full_info <- co_authors_full_info %>% select(doi:country2)

# do the same for the region2, the co_authors' US state names
co_authors_full_info$state2<-with(co_authors_full_info,paste0(region2,country2))
co_authors_full_info <- left_join(co_authors_full_info,states_df,by=c("state2" = "id"))
co_authors_full_info$region2 <- ifelse(is.na(co_authors_full_info$abb), co_authors_full_info$region2, co_authors_full_info$abb )
co_authors_full_info <- co_authors_full_info %>% select(doi:country2)


# write it to a csv to be visualized
write_csv(co_authors_full_info, "./data/orcid-data.csv")

# Ta da, you should now have a data file to visualize in Tableau

# Before uploading to Tableau, consider cleaning your data file, either manually or using a tool
# like Open Refine (https://openrefine.org/). It will improve the visualization if wordings and spellings
# are standardized, particularly in the organization (org1, org2) and city name (city1, city2) fields.
