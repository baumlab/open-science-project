


setwd("~/Desktop/Research/open-science-project")
setwd("~/Documents/git-jpwrobinson/open-science-project")

theme_set(theme_bw()); library(scales)

# fish<-read.table('data/sea-around-us/Jamie_Shellfish_NA.csv',sep=',',header=T)

# ## create unique ID
# fish$ID<-with(fish,paste(lat, lon, fishing_entity, sep='.'))


# ## trying different aggregations 
# sum.fam<-aggregate(sum ~  common_name + eez, fish, sum)



# ### adding extra variables for better exploration

# ## high price taxa = total landings over time > 100,000 per EEZ
# high.price<-sum.fam$common_name[sum.fam$sum>100000]
# fish$high.price<-ifelse(fish$common_name %in% high.price, 'High', "Low")

# ## taxonomic groups
# bivalves<-c('Marine crabs', 'Dungeness crab', 'Crabs, lobsters, shrimps', 'Lobsters, crabs, shrimps, krill', 
# 			'Northern shrimps', 'Red king crab', 'Tanner, snow crabs' ,'Stone/king crabs', 
# 	'Marine crabs, shrimps, lobsters nei', 'Ocean shrimp', 'Pacific rock crab', 'Commercial shrimps and prawns', 
# 				'Ridgeback rock shrimp', 'Seabed shrimps', 'Blue mud shrimp')
# bivalves<-c('Clams', 'Pacific cupped oyster', 'Abalones', 'True oysters', 'Butter clam', 'Pacific geoduck', 
# 			'Gaper clams', 'Nuttall cockle', 'Pacific razor clam', 'Venus clams', 'Flat oysters', 
# 			'Weathervane scallop', 'Abalones, ear shells', 'Edible sea mussels', 'Pacific gaper clam', 'Bean clams', 
# 			'Pacific littleneck clam', 'Sand gaper')
# other<-c('Aquatic invertebrates', 'Sickle-arched sea urchins', 'Sea snails', '')

# fish$taxa_broad[fish$common_name%in%crustaceans]<-'crustacean'
# fish$taxa_broad[fish$common_name%in%bivalves]<-'bivalve'
# fish$taxa_broad[fish$common_name%in%other]<-'other'


# ### save fish as Rdata
# save(fish, file='data/SaU_landings_clean.Rdata')

load('data/SaU_landings_clean.Rdata')

## Figures for landings data over years, by different taxa groupings.

pdf(file='figures/fish_yearly_landing_trends.pdf', height=7, width=11)
## by common name
sum.fam.year<-aggregate(sum ~  common_name + eez + year + high.price, fish, sum)
ggplot(sum.fam.year, aes(year, sum, col=common_name)) + geom_line() + facet_wrap(high.price~eez, scales='free') + 
		labs(y='Landings + discards (tonnes)') + scale_y_continuous(labels=comma)

## by major taxa group
sum.tax.year<-aggregate(sum ~  taxa_broad + eez + year + high.price, fish, sum)
ggplot(sum.tax.year, aes(year, sum, col=taxa_broad)) + geom_line() + facet_wrap(high.price~eez, scales='free') + 
		labs(y='Landings + discards (tonnes)') + scale_y_continuous(labels=comma)

## crustaceans only
sum.crustacean.year<-aggregate(sum ~  common_name + eez + year + high.price, fish[fish$taxa_broad=='crustacean',], sum)
ggplot(sum.crustacean.year, aes(year, sum, col=common_name)) + geom_line() + facet_wrap(high.price~eez, scales='free') + 
		labs(y='Landings + discards (tonnes)', title='Crustaceans by year + EEZ') + scale_y_continuous(labels=comma)

## bivalves only
sum.bivalve.year<-aggregate(sum ~  common_name + eez + year + high.price, fish[fish$taxa_broad=='bivalve',], sum)
ggplot(sum.bivalve.year, aes(year, sum, col=common_name)) + geom_line() + facet_wrap(high.price~eez, scales='free') + 
		labs(y='Landings + discards (tonnes)', title='Bivalves by year + EEZ') + scale_y_continuous(labels=comma)

## other only
sum.other.year<-aggregate(sum ~  common_name + eez + year + high.price, fish[fish$taxa_broad=='other',], sum)
ggplot(sum.other.year, aes(year, sum, col=common_name)) + geom_line() + facet_wrap(high.price~eez, scales='free') + 
		labs(y='Landings + discards (tonnes)', title='Other sp. by year + EEZ') + scale_y_continuous(labels=comma)

dev.off()




