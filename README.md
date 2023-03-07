# Exploring Publication Collaborations using ORCID and DOI data
## Project Summary
The resources available in this Github repository can be used to create a visualization of publication collaboration activity, based on public data from researchers' ORCID records and Crossref DOI publication metadata. The R script in this repository can be used to retrieve information about publishing collaborations between researchers at a home organization and other organizations across the globe. The resulting CSV file can then be loaded into a [Tableau Public](https://public.tableau.com/app/discover) dashboard to create a collaboration map and additional views to explore the data further. This project was made possible by a 2022 partnership between the [ORCID US Community](https://orcidus.lyrasis.org/) (administered by Lyrasis) and the Drexel University [LEADING program](https://mrc.cci.drexel.edu/leading/). For more information, including full instructions for how to use the tools in this repository, please [see our website](https://orcidus.lyrasis.org/data-visualization/).
## Retrieving the data
We recommend using [R Studio](https://posit.co/) to run the [R script](https://github.com/lyrasis/ORCID-Data-Visualization/blob/main/Rorcid_Crossref_Authors.R), which will result in the data needed to create the visualization. Read the comments and follow the instructions in the script to fill in search values and run the commands. You will need the following information for your organization:
* Organization Name(s)
* Organization Email Domain(s)
* Organization Ringgold ID
* Organization GRID ID (often included as an "other identifier" in the [ROR registry](https://ror.org/search))
* Organization ROR ID (search the [ROR registry](https://ror.org/search))

For help retrieving any of this information, contact orcidus@lyrasis.org.
## Considerations and context for the data
**Data errors:** The data pulled using the R script are imperfect and contain gaps, as well as user and machine errors. The numbers in the data pull are not definitive. The data pulled for your institution are a snapshot for a specific period of time and may change as researchers obtain/update their ORCID profiles and continue to publish.

Some examples of data errors that may exist in the data are: 
* Missing ORCID iDs
* Missing geographic information that leads to missing data points on the collaborations map
* Typos in the institution name or city/country that lead to missing or erroneous ORCID iDs included in the data pulls

It’s important to highlight that this data shouldn’t be used to evaluate or compare researchers against one another because the data are not perfect and do not give a full picture of collaborations and impact. The resources in this repository provide just one angle through which to approach this information.

**Collaboration counting:** In the data pull, collaborations are counted by iterating through each home author and counting the collaborations again. For example, if 2 researchers at Temple (home institution) author a paper with researchers from the University of Texas, this counts as 1 collaboration within Temple and 1 collaboration with UT for each Temple author. In other words, for the home institution as a whole, it’s counted as 2 collaborations within Temple and 2 collaborations with UT. However, in the Tableau dashboard, each DOI is counted as one collaboration for the institution. 

**Current or previous institutions:** The data pulled for each author also looks at their entire careers. The script also pulls the current institution for collaborating authors. This reduces blanks which are greater when trying to pinpoint affiliation at the time of DOI minting because of lack of historical employment entries in ORCID profiles. This also avoids potential discrepancies with date of DOI minting and date of publication, which is sometimes blank. This also treats both authors the same in terms of counting. 

**Dates**: You may see discrepancies in the DOI issueing date and publication date due to different DOI issuing processes. There may be a lag time between when the DOI was issued and the publication date according to the journal. This may also depends on the publisher’s workflow. The date used in this script is the DOI issue date. This allowed for fewer blanks in the data. This is an area of future improvement for this project. 
## Why can't I find my ORCID iD? 
If you're having trouble finding your ORCID iD in the data pull or the search, here are a few things you may want to check:
### 1. Do you have an ORCID profile set up?
If you have not yet created an ORCID iD, please visit www.orcid.org to set up your ORCID profile. ORCID sets up a persistent digital identifier (also called an ORCID iD) to distinguish you from other researchers.
### 2. Did you set up your ORCID iD after the data pull?
If you set up your ORCID iD after the data supporting this dashboard were pulled, then your ORCID iD will not show up in the dashboard until the data has been pulled again.
### 3. Is all of the information in your ORCID profile accurate?
Take a moment to verify that your current institution and location are accurately listed in your ORCID profile -- typos happen! If you work remotely for an institution, you will have to list the institution's primary location in order to show up in the data. If you correct any information in your ORCID profile after the data supporting this dashboard were pulled, then your ORCID iD will not show up in the dashboard until the data has been pulled again.
### 4. Still not sure?
Reach out to your campus ORCID administrator or Lyrasis for further troubleshooting.
## Customizing your own Tableau dashboard
Refer to the [Customizing your own Tableau dashboard](https://github.com/lyrasis/ORCID-Data-Visualization/blob/main/tableau-visualization/customizing-dashboard.md) page. Be sure to also review the [dashboard documentation](https://github.com/lyrasis/ORCID-Data-Visualization/blob/main/tableau-visualization/dashboard-documentation.md).  
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
