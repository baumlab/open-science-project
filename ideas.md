# Ideas


Brainstorm ideas here guys. Like I said, we won't start until January, but if you have any problems you think could be analysed with open data just chuck them in.

### 1. Large MPA effectiveness

Question: How effective are large MPAs in excluding boat traffic?

Dataset: [Automatic Identification System] (http://www.marinetraffic.com/en/ais/home/centerx:-179/centery:32/zoom:7) 

Study area: [10 largest MPAs] (http://www.protectplanetocean.org/collections/introduction/introbox/globalmpas/introduction-item.html)

Relevant links: [Global Fishing Watch] (http://globalfishingwatch.org/faq)  
[Article about big data and tracking fishing vessels] (http://e360.yale.edu/feature/how_satellites_and_big_data_can_help_to_save_the_oceans/2982/)  
[PEW's Eyes on the Seas] (http://www.pewtrusts.org/en/multimedia/video/2015/project-eyes-on-the-seas)  
  
Relevant papers: [McCauley et al. 2016 Science] (https://www.researchgate.net/profile/Kristina_Boerder/publication/297743086_Ending_hide_and_seek_at_sea/links/56e4839108aedb4cc8ac2605.pdf) 
[Brodeur et al. PLoS ONE; Improving Fishing Pattern Detection from Satellite AIS Using Data Mining and Machine Learning] (http://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0158248). I think the author K Brodeur is pretty much doing her PhD on this stuff. Tim White (Hopkins Marine lab) should have a paper soon on using AIS for the Palmyra Atoll

Here is a recent short note on what looks like a [working group on AIS] (https://arxiv.org/ftp/arxiv/papers/1609/1609.08756.pdf)
  
Relevant data:  
Are countries with higher GDPs better at enforcing MPA protection? [GDP Data]
(http://data.oecd.org/gdp/gross-domestic-product-gdp.htm)  

**I think it would be interesting to build a mobile app that would notifiy people if a boat was currently in a MPA (and potentially shouldn't be) that they cared about**

*Pros:*

* Huge relevance given recent creation of new 'super' MPAs
* High resolution, reliable data is available
* Either way (MPAs work or MPAs don't work), result is interesting + useful

*Cons:*

* When is a fishing boat actually fishing?
* How do MPA restrictions vary between MPAs?
* Seems like something that may have been done already - lit search


### 2. Evaluating past predictions

Question: How well do we make predictions in ecology?

Dataset: We would have to compile a dataset of papers depending on the specific question.

Easton's thoughts: We could evalulate how predictions from fishery models or the effects of climate change on particular species were either correct or way off. We would look at older papers (say pre 2000) and see if there predictions actually held up. Hope that makes some sense


[Our figure colour palette] (https://github.com/karthik/wesanderson)


### 3. Living Planet Index

This website has census data for 18,000 populations around the globe. They have already done some work assessing population trends (e.g. how do aquatic organisms fare compared to terrestrial species?). I think there is ample room to dig futher into the data though. Perhaps we could connect this to other abiotic or human activity databases as well?

 

[Living planet index] (http://livingplanetindex.org/projects?main_page_project=LivingPlanetReport&home_flag=1)


### 4. Oil spill impact on fisheries catch

Large oil spills linked to fisheries collapses - Exxon Valdez, Deep Horizon, Prestige. But what about medium and small spills? And what about effect sizes?

[NOAA largest oil spills] (http://response.restoration.noaa.gov/oil-and-chemical-spills/oil-spills/largest-oil-spills-affecting-us-waters-1969.html)

[NMFS historical landings by species + state] (https://www.st.nmfs.noaa.gov/commercial-fisheries/commercial-landings/annual-landings-with-group-subtotals/index)

Pros - link between spills and environment only really apparent for crazy large spills, but not across scales (e.g. USA), fisheries types (fish, shellfish).

Cons - VERY reliant on inference. No association between spill and catch might be misleading because we can't measure catch very well.

Method - quantify long-term trend in shellfish fisheries landings + value in states with a history of oil spills (Texas, Louisiana, Washington). Identify momentary loss of landings in year after oil spill occurred.

Oil data - need lat-lon, spill size, and spill duration. NOAA has this information.

Catch data - we have state-level data. Are there higher spatial resolution data available? Fisheries divided into subregions - data must exist!

OR

Fishery-independent data - intertidal monitoring data to examine community-level impacts?



### 5. Ideas from group meeting in Victoria on Tues (6-Dec-2016)

* Soil microbiome data and forests worldwide
* Oil spills and coastal ecosystems
* Fisheries/conservation during war in particular places
* using data from [NCEAS list] (https://www.nceas.ucsb.edu/scicomp/data)
* AIS data as described above

### 6. Data from Jill

[KNB info] (https://knb.ecoinformatics.org/)

### 7. Sushi project

This is a project originally put forth by Nick Fabina on facebook. Danielle and I chatted with him a bit on the project. For now another collaborator is going to look at the data Nick has assembled. We might help on the project later.
