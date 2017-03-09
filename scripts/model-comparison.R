
# Created by Easton White
# Created on 7-Mar-2017


# Run series of models to determine the best option
# Test with geoduck data to start

source('scripts/functions/residual_plots.R')
# Pull in cleaned geoduck with oil spill data from 2000 onwards
geoduck = geoduck

gam_geoduck_w_coord<-gam(sum~pdo+year+spill+lat+lon, data=geoduck, family=Gamma(link=log)) 
glm_geoduck_w_coord<-lm(sum~pdo+year+spill+lat+lon, data=geoduck, family=Gamma(link=log)) 

gam_geoduck_wo_coord<-gam(sum~pdo+year+spill, data=geoduck, family=Gamma(link=log)) 
glm_geoduck_wo_coord<-lm(sum~pdo+year+spill, data=geoduck, family=Gamma(link=log)) 

residual_plots(gam_geoduck_w_coord,geoduck)
residual_plots(glm_geoduck_w_coord,geoduck)
residual_plots(gam_geoduck_wo_coord,geoduck)
residual_plots(glm_geoduck_wo_coord,geoduck)
# Of these four it appears the glm with coordinates included does best

# Make each lat-lon combo a different study site. Then we can use random effects to account for this like we did at Cocos (this would account for temporal autocorrelation)
source('scripts/functions/create_site_code.R')
geoduck = create_site_code(geoduck)

require(MASS)
require(glmmADMB)

geoduck$site_code=as.factor(geoduck$site_code)
glmm_geoduck_wo_coord = glmmadmb(formula=sum~pdo+year+spill+(1|site_code),data=geoduck,family='Gamma',extra.args="-ndi 30000",zeroInflation=FALSE)
glmm_geoduck_w_coord = glmmadmb(formula=sum~pdo+year+spill+lat+lon+(1|site_code),data=geoduck,family='Gamma',extra.args="-ndi 30000",zeroInflation=FALSE)

residual_plots(glmm_geoduck_w_coord,geoduck) # no major difference when including lat/long if we have random effects included
residual_plots(glmm_geoduck_wo_coord,geoduck)

require(ggplot2)
geoduck$residuals = as.numeric(glmm_geoduck_w_coord$residuals)
ggplot() + geom_point(data=geoduck,aes(x=lon,y=lat,col=log(abs(residuals))),size=4) + facet_wrap(~year)
ggplot(data=geoduck,aes(x=year,y=residuals,col=as.factor(abs(lat*lon)))) + geom_point(size=2) + geom_smooth(method = 'loess',se = F) 
