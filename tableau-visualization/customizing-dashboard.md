# Customizing your own Tableau dashboard
Take the steps below to build your own Tableau dashboard. For questions about Tableau, check out the [Tableau Community Forums](https://community.tableau.com/s/topic/0TO4T000000QF9sWAG/tableau-public). If you run into issues with this Tableau dashboard, contact Lyrasis ORCID US Community support for assistance. 
1. Request a data pull from ORCID US Community support, or pull your own data using the R script in this repository. **Do not change any of the variable names.** Doing so will cause Tableau to be unable to recognize the variables. 
2. Save the CSV from Lyrasis or the data pull as an Excel file (.xslx) to a local folder on your device. 
3. [Create a Tableau Public account](https://public.tableau.com/desktop/signup_unification.html) for yourself, your institution, or your department. Be sure to check in with your local IT department to ask about any possible restrictions or rules around creating an account. 
4. While logged in to your Tableau Public account, navigate to the template dashboard featured on the [ORCID US Community Tableau Public profile](https://public.tableau.com/app/profile/orcid.us.community).
5. Using the menu in the top right of the dashboard, click on the icon with two overlapping rectangles (**Make a copy**).
<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/make%20a%20copy.png" alt="Make a copy button in Tableau." width="350"/></p>
6. What you should be seeing at this point... 

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/copied%20dashboard.png" alt="Tableau in browser edit view for collaborations dashboard.." width="950"/></p>

7. In the top right corner, click on the blue **Publish** button.
8. In the bottom left corner, click on **Data Source**.
9. You will see an error message: *Could not find the referenced file: Replace it with another file?*
10. Click **Yes**. 
11. Drag and drop or upload your institution’s data file from its location on your device. Tableau will replace the existing data file with this file. This may take several minutes, depending on the file size. 
12. Once the new data has been added, in the top right corner, click on **Create extract**, then click on **Create extract** again in the pop-up. Depending on the file size, this may take anywhere from several seconds to several minutes. 

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/create%20extract.png" alt="Location of create extract option in Tableau. " width="950"/></p>

13. Click on the **Summary dashboard** tab at the bottom.
14. At the top of the dashboard, double click the title that includes your institution name and **([time period from data pull])**. Replace **[time period from data pull]** with the time period requested from the data pull, then click OK.
15. Scroll down to the **Highest number of collaborations with the following institutions:** visualization. At the bottom of the visualization, double click the caption underneath the bars to fill in the text between the brackets with your own institution’s data.
16. Click anywhere on the **Highest number of collaborations with the following institutions:** visualization. Four small icons will appear on the right of the gray box around the visualization. Click on the small square with the arrow popping out (second icon down, called **Go to Sheet**). You can use this feature to navigate to individual visualizations from the dashboards. 

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/go%20to%20sheet.png" alt="Demonstration of Go to Sheet icon in Tableau, found on right-hand side of visualizations. " width="950"/></p>

17. On the **Marks** card one of the left-hand panes, click on **Color** to change the color of the bars. You can use the other features in the **Marks** card to edit the colors, sizes, and other aesthetic features of the visualizations. 

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/edit%20colors.png" alt="Marks card for Tableau controls color selection, size, and other aesthetics." width="950"/></p>

18. Click on the **Collaborations** tab, then click anywhere on the **Collaborations Map** visualization. Click on the **Go to Sheet** icon that appears on the top right corner of the visualization to go to the visualization. 
19. On the left-hand side, under the **Data pane** that contains a long list of variables, click on the small white triangle to the right of **Org2 (group)**. Then, click on **Edit Group…**

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/edit%20group.png" alt="In Tableau, Edit Group can be found by clicking on a dimension. " width="950"/></p>

20. A list of institutions should pop up. Find your institution and click on it to highlight, then click on **Group**. Label this group as **[Your institution name] Only**.
21. Follow the same steps to select all of the other institutions and group them. Label that group as **Excluding [your institution name]**.

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/groups%20after%20editing.png" alt="In Tableau, groups can be edited by selected and labeling groups of data. " width="950"/></p>

22. Close the pop-up. 
23. At the bottom, click on the **Collaborations** tab.
24.  Immediately below the first gray bar divider, click on the filter. On the right-hand side of the gray box that appears around the filter, click on the small white triangle, then select **Single Value (list)**. 

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/single%20value%20list%20filter.png" alt="Filters can be edited to a single value list by clicking on white arrow in Tableau." width="950"/></p>

25. Click on the **Individual search** tab. Double click on the title to change the **[time period from data pull]** to the time period for your dataset.
26. At the bottom, click on the **Why can't I find my ORCID iD?** tab. Double click on the text to add the appropriate contact information for ORCID support at your institution.
27.  Make any other customizations to the dashboard. For support with using Tableau, refer to the Tableau Resources section. 
28.  In the top right corner, click on **Publish** or **Publish as…** to save the dashboard to your Tableau Public profile. 

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/publish.png" alt="Tableau dashboard in Tableau Public can be published by clicking on Public button." width="950"/></p>

29. The **Full visualization** tab of the dashboard contains all of the dashboard tabs in a neater, guided format. To only display the **Full visualization** tab, navigate to the published version of the dashboard, then click on the **settings** in the top right corner (indicated by the gear icon). Deselect Show Sheets to only show the **Full visualization** tab.

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/show%20sheets%20as%20tabs.png" alt="Tableau settings allow for profile visibility, sheets visibility, and access customization. " width="950"/></p>

30. You can also decide if you want this dashboard to be visible on your profile and if you want to allow others to download or make a copy of your visualization in the **settings**.
31. Scroll down to the **Details** section. Click on the **pencil icon** to the right of **Details** to edit the details for the dashboard, such as the title and description. Click on **Save Changes** when you’re finished with your edits. 

<p align="center"><img src="https://github.com/lyrasis/ORCID-Data-Visualization/blob/fbe5c037e1dad039fb2704fac43a4b30c8cb6ec0/tableau-visualization/tableau-screenshots/details.png" alt="Tableau details allow for title, description, inspiration, and external links to be shared with Tableau Public dashboards." width="950"/></p>

32.Review your visualization for any accessibility issues (resources below).  

If you run into any issues with these steps, refer to the Tableau resources below or reach out to Lyrasis ORCID US Community support for further assistance. 
