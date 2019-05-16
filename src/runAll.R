library(dplyr)
library(readr)
library(fields)
library(lme4)
library(ggplot2)
library(here)

# Read in data
# positional data about the RV Kahuna
# kahuna <- read_csv('../../../presentations/2018/2018-12-03_DUML-RepResearch/data/2018-11-26_2017-Cape-Hatteras-BRS-kahuna-CEE.csv') 
kahuna <- read_csv(here::here('data', '2018-11-26_2017-Cape-Hatteras-BRS-kahuna-CEE.csv'))
kStart <- kahuna %>% 
  filter(status == 'start')

# Read in Gm182 Data: 100 estimated positions of Gm182, augmented with focal follow data
gm182UP <- read_csv(here::here('data', '2018-11-27_Gm182-UserPoints-Start-CEE-Locations-Kahuna.csv')) %>% 
  mutate(status = 'userPoints')

# Read in Gm182 Data: 100 estimated positions of Gm182
gm182 <- read_csv(here::here('data', '2018-11-27_Gm182-Start-CEE-Locations-Kahuna.csv')) %>% 
  mutate(status = 'noUserPoints')

# Minimal Wrangling of the data
gmpts <- bind_rows(gm182, gm182UP)
colnames(gmpts) <- c('trackNum', 'time', 'longitude', 'latitude', 'status')

# Plot the points out:
ggplot(gmpts, aes(longitude, latitude, group = status))+
  scale_fill_gradient(low = "grey70", high = "grey30", guide = "none") +
  xlab("Longitude") +
  ylab("Latitude") +
  theme_minimal()+
  facet_grid(~ status, labeller = label_value) +
  stat_density_2d(aes(fill = ..level..), geom = "polygon", color = "black", size = 0.2, alpha = 0.5) +
  geom_point(color = "navy", size = .5, alpha = .4)


# Analysis Section
# Calculate distance to ship at the start of the CEE
gmpts$d2ship <- rdist.earth.vec(cbind(kStart$longitude, kStart$latitude), 
                                cbind(gmpts$longitude, gmpts$latitude))

gmpts %>% 
  group_by(status) %>% 
  summarize(mean = mean(d2ship, na.rm = TRUE))

# Test the distance
gmpts.fit <- with(gmpts, lmer(d2ship ~ status + (1 | trackNum)))
gmpts.fit
summary(gmpts.fit)
