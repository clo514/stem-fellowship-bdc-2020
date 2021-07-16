########## Hopkins data #######################################################
# Set working directory
setwd("D:/BDC2020/bdc2020/Hopkinsdata/Datafiles")


# Hopkins data
# Read in data
hopkins <- read.delim(file = "20200523_Hopkins_dailyreport_all_counties.txt", header = TRUE, sep = ",")

# Select only US counties (rows with non-NA values in "FIPS" column)
# FIPS= Federal Information Processing Standards code that uniquely identifies counties within the USA
hopkins <- hopkins[!is.na(hopkins$FIPS),]



########## Census data #######################################################
######## Population-Size, International Migration, Domestic Migration, Births, Deaths
# https://data.census.gov/cedsci/table?q=county&g=0100000US,.050000&tid=ACSDT1Y2018.B08130&vintage=2018&hidePreview=true
census <- read.delim(file = "co-est2019-alldata.csv", header = TRUE, sep = ",")

# Specify fields (for details see:
# https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2019/co-est2019-alldata.pdf
fields <- c("STATE", "COUNTY", "STNAME", "CTYNAME", 
            "POPESTIMATE2019", "NPOPCHG_2019", 
            "BIRTHS2019", "DEATHS2019", "NATURALINC2019", 
            "INTERNATIONALMIG2019", "DOMESTICMIG2019", "NETMIG2019", 
            "RESIDUAL2019", "GQESTIMATES2019", "RDEATH2019", 
            "RNATURALINC2019", "RINTERNATIONALMIG2019", "RDOMESTICMIG2019", "RNETMIG2019")
census <- census[, fields]


# Create FIPS values and set as rownames
rownames(census) <- census$STATE * 1000 + census$COUNTY


# Subset Hopkins data further:
# Take only counties with FIPS values in the census FIPS (reduction from 3001 to 2938)
hopkins_FIPS <- hopkins[hopkins$FIPS %in% rownames(census),]


# Merge
merged <- cbind(hopkins_FIPS, census[as.character(hopkins_FIPS$FIPS), ])
merged <- merged[,!(colnames(merged) %in% c("STATE", "COUNTY", "STNAME", "CTYNAME"))]

# Write to file
write.csv(merged, "merged1.csv", row.names = FALSE)





############ MEANS OF TRANSPORTATION TO WORK BY PLACE OF WORK--STATE AND COUNTY LEVEL 
# https://www.census.gov/content/census/en/data/datasets/2017/econ/cbp/2017-cbp.html
census <- read.delim(file = "ACSDT1Y2018.B08130_data_with_overlays_2020-05-25T235204.csv", header = TRUE, sep = ",")
#only 840 



# https://www.census.gov/data/tables/2015/demo/metro-micro/commuting-flows-2015.html
# Universe: Workers 16 years and over.
census <- read.delim(file = "5year ACS commuting flows.csv", header = TRUE, sep = ",")

# Specify fields (for details see:
fields <- c("State.FIPS.Code", "County.FIPS.Code", 
            "State.FIPS.Code.1", "County.FIPS.Code.1", 
            "Workers.in.Commuting.Flow")
census <- census[, fields]

# Remove counties (rows) with NAs
census <- census[complete.cases(census), ]


# Create FIPS values for home (FIPS) and work (FIPS.1) counties
census$FIPS.1 <- census$State.FIPS.Code.1 * 1000 + census$County.FIPS.Code.1

# Format numbers
census$Workers.in.Commuting.Flow <- gsub(pattern = ",",replacement = "", x = census$Workers.in.Commuting.Flow)

# Count number of workers for each work county (FIPS.1)
counts <- integer(max(census$FIPS.1))
for (i in 1:nrow(census)) {
  x <- as.integer(counts[as.integer(census$FIPS.1[i])])
  counts[as.integer(census$FIPS.1[i])] <- x + as.numeric(as.character(census$Workers.in.Commuting.Flow[i]))
}

# Create new field in merge and add data
merged$WorkersInCommutingFlow <- integer(nrow(merged))
for (i in 1:nrow(merged)) {
  merged$WorkersInCommutingFlow[i] <- as.integer(counts[as.integer(merged$FIPS[i])])
}

# Write to file
write.csv(merged, "merged2.csv", row.names = FALSE)









############ County Business Patterns 2017
# https://www.census.gov/content/census/en/data/datasets/2017/econ/cbp/2017-cbp.html
# Complete County File (12.5 MB)
census <- read.delim(file = "cbp17co.txt", header = TRUE, sep = ",")

# Specify fields (for details see:
fields <- c("fipstate", "fipscty", "emp", "qp1", "ap", "est")
census <- census[, fields]

# Create FIPS values for home (FIPS) and work (FIPS.1) counties
census$FIPS <- census$fipstate * 1000 + census$fipscty

# Merge rows based on FIPS value (smush all industries into 1 row)
counts <- as.data.frame(matrix(0, ncol = 4, nrow = length(unique(census$FIPS))))
rownames(counts) <- unique(census$FIPS)
colnames(counts) <- colnames(census)[3:6]

for (i in 1:nrow(census)) {
  counts[as.character(census$FIPS[i]), ] <- counts[as.character(census$FIPS[i]), ] + census[i, 3:6]
}

# Merge
merged <- cbind(merged, counts[as.character(merged$FIPS), ])

# Write to file
write.csv(merged, "merged3.csv", row.names = FALSE)







############ Per Capita Income 2018
# https://apps.bea.gov/iTable/index_regional.cfm
census <- read.delim(file = "PerCapitaIncome.csv", header = TRUE, sep = ",")

# Remove counties (rows) with NAs
census <- census[complete.cases(census), ]

# Clean up FIPs values (eg: from 01001 to 1001)
rownames(census) <- as.numeric(as.character(census$GeoFips))

# Create new field in merge and add data
merged$Income <- integer(nrow(merged))
for (i in 1:nrow(merged)) {
  merged$Income[i] <- census[as.character(merged$FIPS[i]), "X2018"]
}
# Write to file
write.csv(merged, "merged4.csv", row.names = FALSE)







############ GDP 2018
# https://apps.bea.gov/iTable/index_regional.cfm
census <- read.delim(file = "GDP.csv", header = TRUE, sep = ",")

# Remove counties (rows) with NAs
census <- census[complete.cases(census), ]

# Clean up FIPs values (eg: from 01001 to 1001)
rownames(census) <- as.numeric(as.character(census$GeoFips))

# Create new field in merge and add data
merged$GDP <- integer(nrow(merged))
for (i in 1:nrow(merged)) {
  merged$GDP[i] <- census[as.character(merged$FIPS[i]), "X2018"]
}

# Write to file
write.csv(merged, "merged5.csv", row.names = FALSE)





########## JieYingWu data #######################################################
# Source:   https://github.com/JieYingWu/COVID-19_US_County-level_Summaries/tree/master/data
# Data:     https://github.com/JieYingWu/COVID-19_US_County-level_Summaries/blob/master/data/counties.csv
# Annotations:    https://github.com/JieYingWu/COVID-19_US_County-level_Summaries/blob/master/data/list_of_columns.mdSummaries/blob/master/data/list_of_columns.csv
# Availability:   https://github.com/JieYingWu/COVID-19_US_County-level_Summaries/blob/master/data/availability.csv

JieData <- read.delim(file = "JieYingWu Data.txt", header = TRUE, sep = ",")

# Specify fields (for details see:
fields <- c("FIPS", "Rural.urban_Continuum.Code_2013", "Urban_Influence_Code_2013",
            "Economic_typology_2015", "Less.than.a.high.school.diploma.2014.18",
            "High.school.diploma.only.2014.18", "Some.college.or.associate.s.degree.2014.18", 
            "Bachelor.s.degree.or.higher.2014.18", "Percent.of.adults.with.less.than.a.high.school.diploma.2014.18",
            "Percent.of.adults.with.a.high.school.diploma.only.2014.18", "Percent.of.adults.completing.some.college.or.associate.s.degree.2014.18",
            "Percent.of.adults.with.a.bachelor.s.degree.or.higher.2014.18", "POVALL_2018", "MEDHHINC_2018",
            "Density.per.square.mile.of.land.area...Population", "Density.per.square.mile.of.land.area...Housing.units", 
            "Total_Male", "Total_Female", 
            "Total_age18to64", "Male_age18to64", "Female_age18to64", 
            "Total_age65plus", "Male_age65plus", "Female_age65plus",
            "Total_age85plusr", "Male_age85plusr", "Female_age85plusr",
            "Active.Physicians.per.100000.Population.2018..AAMC.", "Total.Active.Patient.Care.Physicians.per.100000.Population.2018..AAMC.",
            "Active.Primary.Care.Physicians.per.100000.Population.2018..AAMC.", "Active.General.Surgeons.per.100000.Population.2018..AAMC.",
            "Active.Patient.Care.General.Surgeons.per.100000.Population.2018..AAMC.", "Fraction.of.Active.Physicians.Who.Are.Female.2018..AAMC.",
            "Fraction.of.Active.Physicians.Who.Are.International.Medical.Graduates..IMGs..2018..AAMC.", "Fraction.of.Active.Physicians.Who.Are.Age.60.or.Older.2018..AAMC.",
            "Anatomic.Clinical.Pathology..AAMC.", "Anesthesiology..AAMC.", "Cardiovascular.Disease..AAMC.", 
            "Dermatology..AAMC.", "Emergency.Medicine..AAMC.", "Family.Medicine.General.Practice..AAMC.", 
            "Gastroenterology..AAMC.", "General.Surgery..AAMC.", "Hematology...Oncology..AAMC.", "Internal.Medicine..AAMC.", 
            "Neurology..AAMC.", "Orthopedic.Surgery..AAMC.", "Otolaryngology..AAMC.", "Pediatrics....AAMC.", "Plastic.Surgery..AAMC.",
            "Psychiatry..AAMC.", "Radiology...Diagnostic.Radiology..AAMC.", "Total.nurse.practitioners..2019.", "Total.physician.assistants..2019.",
            "Total.Hospitals..2019.", "Internal.Medicine.Primary.Care..2019.", "Family.Medicine.General.Practice.Primary.Care..2019.",
            "Pediatrics.Primary.Care..2019.", "Obstetrics...Gynecology.Primary.Care..2019.", "Geriatrics.Primary.Care..2019.",
            "Total.Primary.Care.Physicians..2019.", "Psychiatry.specialists..2019.", "Surgery.specialists..2019.",
            "Anesthesiology.specialists..2019.", "Emergency.Medicine.specialists..2019.", "Radiology.specialists..2019.",
            "Cardiology.specialists..2019.", "Oncology..Cancer..specialists..2019.", "Endocrinology.Diabetes.and.Metabolism.specialists..2019.",
            "All.Other.Specialties.specialists..2019.", "Total.Specialist.Physicians..2019.",
            "ICU.Beds", "transit_scores...population.weighted.averages.aggregated.from.town.city.level.to.county",
            "Total.number.of.UCR..Uniform.Crime.Report..Index.crimes.excluding.arson.", "Total.number.of.UCR..Uniform.Crime.Report..index.crimes.reported.including.arson",
            "MURDER", "RAPE", "ROBBERY", "Number.of.AGGRAVATED.ASSAULTS", "BURGLRY", "LARCENY", "MOTOR.VEHICLE.THEFTS", "ARSON"
)
JieData <- JieData[, fields]

# Set rownames as FIPS
rownames(JieData) <- JieData$FIPS

# Merge
merged <- cbind(merged, JieData[as.character(merged$FIPS), ])

# Remove NAs
merged <- merged[complete.cases(merged), ]

# Write to file
write.csv(merged, "merged6.csv", row.names = FALSE)





############# Adding Severity and Lethality Fields ##########################
# Create Severity field
merged$Severity <- log( merged$Confirmed / merged$POPESTIMATE2019)
# Adjust all values to be in range [-10, 0] (takes care of -Inf values)
merged$Severity[merged$Severity < -10] <- -10
# Round to whole numbers
merged$Severity <- round(merged$Severity, 0)


# New Lethality
# BE CAREFUL OF NaN's
merged$Lethality <- log( merged$Deaths / merged$Confirmed)
# Adjust all values to be in range [-10, 0] (takes care of -Inf values)
merged$Lethality[merged$Lethality < -6] <- -6
# Round to whole numbers
merged$Lethality <- round(merged$Lethality, 0)
# Set Nan to 1
merged$Lethality[is.nan(merged$Lethality)] <- 1

# Create Lethality2 field
merged$Lethality2 <- log( merged$Deaths / merged$POPESTIMATE2019)
# Adjust all values to be in range [-10, 0] (takes care of -Inf values)
merged$Lethality2[merged$Lethality2 < -12] <- -12
# Round to whole numbers
merged$Lethality2 <- round(merged$Lethality2, 0)




# Remove transit score column
merged <- merged[, -97]

# Fix NYC
merged[merged$FIPS == "36061",]$Severity <- -3
merged[merged$FIPS == "36061",]$Lethality2 <- -6

# Write to file
write.csv(merged, "merged7.csv", row.names = FALSE)




########## Kaggle big data #######################################################
# Source:   https://www.kaggle.com/johnjdavisiv/us-counties-covid19-weather-sociohealth-data?select=US_counties_COVID19_health_weather_data.csv

census <- read.delim(file = "US_counties_COVID19_health_weather_data.csv", header = TRUE, sep = ",")

# Specify fields (for details see:
fields <- c("fips", "county", "state", "percent_smokers", "percent_physically_inactive", 
            "percent_excessive_drinking", "percent_adults_with_obesity", "percent_vaccinated")
census <- census[, fields]
census <- unique(census)

# Fix NYC and Kansas City FIPS
census$fips <- as.character(census$fips)
census$fips[26] <- 36061
census <- census[-823, ]


# Set rownames as FIPS
rownames(census) <- as.character(as.numeric(census$fips))


# Merge
merged <- cbind(merged, census[as.character(merged$FIPS), 
                               c("percent_smokers", "percent_physically_inactive", "percent_excessive_drinking", "percent_adults_with_obesity", "percent_vaccinated")])
merged <- merged[complete.cases(merged), ]


# Write to file
write.csv(merged, "merged9.csv", row.names = FALSE)




