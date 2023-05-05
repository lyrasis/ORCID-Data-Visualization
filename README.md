# Exploring Publication Collaborations using ORCID and DOI data
## Project Summary
The resources available in this Github repository can be used to create a visualization of publication collaboration activity, based on public data from researchers' ORCID records and Crossref DOI publication metadata. The R script in this repository can be used to retrieve information about publishing collaborations between researchers at a home organization and other organizations across the globe. The resulting CSV file can then be loaded into a [Tableau Public](https://public.tableau.com/app/discover) dashboard to create a collaboration map and additional views to explore the data further. This project was made possible by a 2022 partnership between the [ORCID US Community](https://orcidus.lyrasis.org/) (administered by Lyrasis) and the Drexel University [LEADING program](https://mrc.cci.drexel.edu/leading/). For more information, including full instructions for how to use the tools in this repository, please [see our website](https://orcidus.lyrasis.org/data-visualization/).
## Retrieving the data
We recommend using [R Studio](https://posit.co/) to run the [R script](https://github.com/lyrasis/ORCID-Data-Visualization/blob/main/Rorcid_Crossref_Authors.R), which will result in the data needed to create the visualization. The script is designed to:

* Retrieve ORCID iDs for researchers who have a current, publicly visible employment affiliation for a home institution on their ORCID record
* Unpack the publicly visible works information present on each ORCID record
* Retrieve Crossref DOI metadata for every work that has a Crossref DOI included on the ORCID work citation
* Unpack list of co-authors included in the Crossref DOI metadata for each work
* Retrieve ORCID iD for every co-author, if available
* Check current employment affiliation on the ORCID record of every co-author
* Get location information for the co-authors’ institutions
* Repackage data into CSV file containing home author ORCID iDs, co-author ORCID iDs and institutional affiliations/geographic location, and publication DOIs

You can use the green “code” button above to download a ZIP file, which will contain the R script as well as a folder labeled “data,” which is where the resulting CSV file will be saved. Or, you can download just the R script and create your own “data” folder separately.

Before you get started, you will need to gather the following information for your organization, based on how broad or narrow you want your search to be:

* Organization Name(s)
* Organization Email Domain(s)
* Organization ROR ID (search the [ROR registry](https://ror.org/search))
* Organization GRID ID (often included as an "other identifier" in the [ROR registry](https://ror.org/search))
* Organization Ringgold ID(s) (to find the Ringgold ID(s) for your organization, you can create a guest account at [https://ido.ringgold.com/register](https://ido.ringgold.com/register), or you can email orcidus@lyrasis.org and we can find your Ringgold ID for you)

For help retrieving any of this information, contact orcidus@lyrasis.org.

Open the R script file in RStudio. The script contains a number of comments and instructions. Comments are indicated by the presence of a hashtag (#) proceeding the comment text. Any lines of text with a hashtag in front will not be run as commands. Lines of text with no hashtag will be run as a command when entered in R Studio.

The first time you run the script, there are a few things you will need to do to get set up. Once these things are done, you should not have to do them again:

* Install the packages listed in the script by un-commenting, or removing the hashtags from, the install commands. Once installed, you should not have to install the packages again, so in future sessions you can leave the hashtags in. However, you will still need to load the packages each time you run the script.
* Get your [ORCID Public API keys](https://info.orcid.org/documentation/features/public-api/) (Client ID and Client Secret). You need to have an ORCID iD account in order to get Public API keys. If you don’t have an ORCID iD account, you can register for one, for free, at [https://orcid.org/register](https://orcid.org/register). Follow the instructions in the script.
* Get your ORCID API bearer token in RStudio. Follow the instructions provided in the script.

Next, you will plug in your unique values to perform the search and data retrieval process. You will need to enter the following values (follow the instructions in the script):

* Your working directory = the file path leading to your “data” folder where the final CSV output will be stored. The path needs to look something like this: /Users/rabun/Desktop/ORCID-Data-Visualization-main/data
* The year you want to start searching for publications
* Ringgold ID, GRID ID, ROR ID, Email domain, and Organization name - this allows the script to start by finding all ORCID records that have one or more of these values present in the Employment section of individuals’ ORCID records. For example: 
   * ringgold_id <- "14703" 
   * grid_id <- "grid.253554.0" 
   * ror_id <- "https://ror.org/04v097707"
   * email_domain <- "@csuci.edu"
   * organization_name <- "California State University, Channel Islands"

Note that if you want to search for multiple organization names (and thus have multiple different identifiers) and multiple email domains, there is a section of the script that provides the option to set multiple values for the search (see below).

* Keyword = a word that is unique to your institution, that will serve to narrow the search results for just your organization. For example “Temple” could be the keyword if searching for results from Temple University. If your institution has common words in the name, you may want to use the entire organization name as the keyword. For example the keyword “New” would not be helpful for a search for “The New School” because multiple organizations have the word “New” in the name.
* Geographic information for your organization, including city, state, and country. For example:
   * anchor_org<-"California State University, Channel Islands"
   * anchor_city<-"Camarillo"
   * anchor_region<-"CA"
   * anchor_country<-"US"

At this point, the script provides two options for creating the initial query:
1) Run the search based on the values that you already entered 
2) If you want to search for multiple campuses or specific departments at your organization, you will need to enter those additional values and go from there.

Now you can continue to run the commands and follow the instructions within the script.

Note that the script has various sections, and there are opportunities for you to export the data so far after each section so you can write it back in later without having to run the whole script again. This can be helpful if you get interrupted or if you don’t have time to run the whole script in one sitting. 

Note that there is one more part of the script, in the “get employment data” section, where you will have two options:
1) Accept all of the organization names returned by the initial query
2) View and edit the list of organization names to be included in the search results.

Continue to follow the instructions and run the script commands, until you get to the end, where the final CSV data file will be exported to your data folder.
Once you have the CSV output, you may want to check and clean organization names and city names using [Open Refine](https://openrefine.org/). This can be helpful for collapsing multiple variations of the same organization name (mis-spellings, extra spaces, etc.), and for filling in any city information that may be missing or incorrect.

## Considerations and context for the data
**Data errors:** The data pulled using the R script are imperfect and contain gaps, as well as user and machine errors. The numbers in the data pull are not definitive. The data pulled for your institution are a snapshot for a specific period of time and may change as researchers obtain/update their ORCID profiles and continue to publish.

Some examples of data errors that may exist in the data are: 
* Missing ORCID iDs
* Missing geographic information that leads to missing data points on the collaborations map
* Typos in the institution name or city/country that lead to missing or erroneous ORCID iDs included in the data pulls

It’s important to highlight that this data shouldn’t be used to evaluate or compare researchers against one another because the data are not perfect and do not give a full picture of collaborations and impact. The resources in this repository provide just one angle through which to approach this information.

**Collaboration counting:** In the data pull, collaborations are counted by iterating through each home author and counting the collaborations again. For example, if 2 researchers at Temple (home institution) author a paper with researchers from the University of Texas, this counts as 1 collaboration within Temple and 1 collaboration with UT for each Temple author. In other words, for the home institution as a whole, it’s counted as 2 collaborations within Temple and 2 collaborations with UT. However, in the Tableau dashboard, each DOI is counted as one collaboration for the institution. 

**Current or previous institutions:** The data pulled for each author also looks at their entire careers. The script also pulls the current institution for collaborating authors. This reduces blanks which are greater when trying to pinpoint affiliation at the time of DOI minting because of lack of historical employment entries in ORCID profiles. This also avoids potential discrepancies with date of DOI minting and date of publication, which is sometimes blank. This also treats both authors the same in terms of counting. 

**Dates**: You may see discrepancies in the DOI issuing date and publication date due to different DOI issuing processes. There may be a lag time between when the DOI was issued and the publication date according to the journal. This may also depend on the publisher’s workflow. The date used in this script is the DOI issue date. This allowed for fewer blanks in the data. This is an area of future improvement for this project. 
## Customizing your own Tableau dashboard
Once you have the CSV output for your search, you can load your data into Tableau to create your visualization. Refer to the [Customizing your own Tableau dashboard](https://github.com/lyrasis/ORCID-Data-Visualization/blob/main/tableau-visualization/customizing-dashboard.md) page. Be sure to also review the [dashboard documentation](https://github.com/lyrasis/ORCID-Data-Visualization/blob/main/tableau-visualization/dashboard-documentation.md). 
## Why can't I find my ORCID iD? 
For the “individual search” tab within the Tableau dashboard, if you or other individual are having trouble finding your/their ORCID iD in the data pull or the search, here are a few things you may want to check:
### 1. Do you have an ORCID profile set up?
If you have not yet created an ORCID iD, please visit www.orcid.org to set up your ORCID profile. ORCID sets up a persistent digital identifier (also called an ORCID iD) to distinguish you from other researchers.
### 2. Did you set up your ORCID iD after the data pull?
If you set up your ORCID iD after the data supporting this dashboard were pulled, then your ORCID iD will not show up in the dashboard until the data has been pulled again.
### 3. Is all of the information in your ORCID profile accurate?
Take a moment to verify that your current institution and location are accurately listed in your ORCID profile -- typos happen! If you work remotely for an institution, you will have to list the institution's primary location in order to show up in the data. If you correct any information in your ORCID profile after the data supporting this dashboard were pulled, then your ORCID iD will not show up in the dashboard until the data has been pulled again.
### 4. Still not sure?
Reach out to your campus ORCID administrator or Lyrasis for further troubleshooting. 
## Tableau and accessibility resources
* [Tableau, A Beginner’s Guide to Tableau Public](https://www.tableau.com/blog/beginners-guide-tableau-public)
* [Authoring for Accessibility – Tableau](https://onlinehelp.tableau.com/current/pro/desktop/en-us/accessibility_create_view.htm)
* [Tableau maps: Edit Unknown or Ambiguous Locations](https://help.tableau.com/current/pro/desktop/en-us/maps_editlocation.htm)
* [Tableau Community Forums](https://community.tableau.com/welcome)
* [Tableau Reference Guide](http://www.tableaureferenceguide.com/)
* [Financial Times "Visual Vocabulary: Tableau Edition"](http://www.vizwiz.com/2018/07/visual-vocabulary.html)
* [OneNumber, Tableau for Beginners](https://onenumber.biz/blog-1/2022/5/2/tableau-for-beginners-connect-to-data)
## Questions and support
For any questions or support, or to provide feedback, please contact Lyrasis ORCID US Community support at orcidus@lyrasis.org.
