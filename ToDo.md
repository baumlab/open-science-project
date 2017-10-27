## To Do  
#### May 4, 2017    
* email Rhyne asking for range size data or ask how soon we will have this data, also ask about the CITES membership/species list if he already has this  *JPWR*  
* literature search for metrics we can use, how do people measure effectiveness of countries governance and protection measures *JMI*, *EW*
* species data: data exploration, are big species within our data? think about ways to aggregate the data  *JPWR*, *EW*

#### 22nd May 2017

* thinking about standardising fish number + diversity by coastline/reef area/species richness. GIS/UNEP data sources - need GIS skillz to extract national estimates (JMI) (JMI: requested reef area, have coastline, error when trying to request the shannon index)   
* find someone with GIS skillz
* then, examine standardised aquarium trade as function of governance indicators 
* still waiting on range size data... (JR)
* James to append functional group data. Rhyne et al. 2012 examined global trend in TL ~ catch volume per species, found no relationship.

#### UPDATE: 26th May 2017 (JR)

* NOAA trophic group data does not cover every fish in the database, even for Pacific countries. Problematic to compare trophic information between countries when some species are not included. Currently investigating Fishbase.
* Received OBIS distribution data from Andrew Rhyne. Next step is to figure out how to quantify range size/distribution extent. We have lat-lon of occurrences for each species (multiple entries per species). How to turn this into an explanatory variable? Our question - is trade volume linked to range size and, if so, which species are most/least vulnerable to aquarium trade (theme of endemism etc.).


#### October 10, 2017  
* get CITES data (*JMI*-done)
* run trophic groups with FishBase data (*JMI*- done, only two of our species are in the FishBase data so we can't use this)  
* find a global reef fish functional group dataset from David Bellwood/Mouillot/Kulbicki, because this may have more values than FishBase for our species (*does not exist openly*)  
* how to turn OBIS into an explanatory varaiible, because it has lat-lon occurances for each species? (*JMI*-done)
* Think about how to look at governance: over time? averaged?  (maybe look at papers using these values) (*GO*)
* making a google sheets for the literature like we had for the oil spill data   (https://docs.google.com/spreadsheets/d/1w_iIuv7OuyRlaEyuy7ERDdN-RhIYcX-WMomZEagoSF8/edit?usp=sharing)



#### October 25, 2017

* get reef area data for each country (http://data.unep-wcmc.org/) (JR - done)
* get phylogeny/biogeography categories from Kulbicki et al. 2013
* try for trophic data again through fishbase (Rhyne got 1,200 records this way in his 2012 paper) (*JMI* success)
* find trade papers and fill out lit. Review. get ideas for predictors, controlling for confounding factors across countries, governance questions (*all*)
* find IUCN status of all traded species (JR - though I think Rhyne said none were red listed)
* subset to top 100 commonly traded fish species  (*JR - done*)
* email Rhyne about why there is only 1 species per country in 2008-2011 (*JR* -done)



```
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch *.shp' \
--prune-empty --tag-name-filter cat -- --all
```