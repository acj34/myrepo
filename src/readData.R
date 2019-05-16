#' This script will read in raw data from the Cape Hatteras BRS
#' into a data frame called gm182, which will serve as the intermediate data for
#' subsequent analysis
gm182 <- read.csv(file = '../data/2018-11-27_Gm182-Start-CEE-Locations-Kahuna.csv')
head(gm182)