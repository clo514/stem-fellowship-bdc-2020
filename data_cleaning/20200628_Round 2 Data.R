merged <- read.delim(file = "D:/BDC2020/bdc2020/Hopkinsdata/merged9.csv", header = TRUE, sep = ",")
# Making dataset cleaner
merged <- merged[, c(1:3, 10, 4:9, 11:114)]
merged <- merged[, c(1:106, 110:114, 107:109)]
rownames(merged) <- as.character(merged$FIPS)
merged <- merged[, -114]

# ########## UPDATE Hopkins data #######################################################
# # Set working directory
# setwd("D:/BDC2020/bdc2020/Hopkinsdata/Datafiles/")
# 
# # Read in data
# hopkins <- read.delim(file = "20200627_Hopkins_dailyreport_all_counties.txt", header = TRUE, sep = ",")
# 
# # Select only US counties (rows with non-NA values in "FIPS" column)
# # FIPS= Federal Information Processing Standards code that uniquely identifies counties within the USA
# hopkins <- hopkins[!is.na(hopkins$FIPS),]
# 
# rownames(hopkins) <- as.character(hopkins$FIPS)
# # Updating Confirmed, Deaths, Recovered, Active
# for (i in rownames(merged)) {
#   merged[i, c("Confirmed", "Deaths", "Recovered", "Active")] <- hopkins[i, c("Confirmed", "Deaths", "Recovered", "Active")]
# }

# Recalculating Lethality, Severity
merged$Severity <- log(merged$Confirmed / merged$POPESTIMATE2019)
# Adjust all values to be in range [-10, 0] (takes care of -Inf values)
merged$Severity[merged$Severity < -10] <- -10
# Round to whole numbers
merged$Severity <- round(merged$Severity, 0)
merged["36061", "Severity"] <- -3

merged$Lethality <- log(merged$Deaths / merged$POPESTIMATE2019)
# Adjust all values to be in range [-12, 0] (takes care of -Inf values)
merged$Lethality[merged$Lethality < -12] <- -12
# Round to whole numbers
merged$Lethality <- round(merged$Lethality, 0)
# Set NYC value to -6 (resolve singles)
merged["36061", "Lethality"] <- -6

# Introduce CaseFatality
merged$CaseFatality <- log(merged$Deaths / merged$Confirmed)
merged$CaseFatality[merged$CaseFatality < -6] <- -6
merged$CaseFatality <- round(merged$CaseFatality, 0)
merged["55013", "CaseFatality"] <- -1


########## NYT data #######################################################
# https://github.com/nytimes/covid-19-data
# https://github.com/nytimes/covid-19-data/blob/master/us-counties.csv

case_timecourse <- read.delim(file = "D:/BDC2020/bdc2020/Hopkinsdata/Datafiles/ny_case.csv", header = TRUE, sep = ",")
rownames(case_timecourse) <- case_timecourse[, 1]
case_timecourse <- case_timecourse[, -1]

death_timecourse <- read.delim(file = "D:/BDC2020/bdc2020/Hopkinsdata/Datafiles/ny_death.csv", header = TRUE, sep = ",")
rownames(death_timecourse) <- death_timecourse[, 1]
death_timecourse <- death_timecourse[, -1]

merged <- cbind(merged, case_timecourse[rownames(merged), c(3, 4)])
merged <- cbind(merged, death_timecourse[rownames(merged), c(3, 4)])
colnames(merged)[115:118] <- c("case_Day30", "case_Day60", "death_Day30", "death_Day60")

merged <- merged[complete.cases(merged), ]


merged$Rate_case_Day30 <- log( merged$case_Day30 / merged$POPESTIMATE2019 )
merged$Rate_case_Day30[merged$Rate_case_Day30 < -10] <- -10
merged$Rate_case_Day30 <- round(merged$Rate_case_Day30, 0)

merged$Rate_case_Day60 <- log( merged$case_Day60 / merged$POPESTIMATE2019 )
merged$Rate_case_Day60[merged$Rate_case_Day60 > -3] <- -3
merged$Rate_case_Day60 <- round(merged$Rate_case_Day60, 0)

merged$Rate_death_Day30 <- log( merged$death_Day30 / merged$POPESTIMATE2019 )
merged$Rate_death_Day30[merged$Rate_death_Day30 < -14] <- -14
merged$Rate_death_Day30[merged$Rate_death_Day30 > -7] <- -7
merged$Rate_death_Day30 <- round(merged$Rate_death_Day30, 0)

merged$Rate_death_Day60 <- log( merged$death_Day60 / merged$POPESTIMATE2019 )
merged$Rate_death_Day60[merged$Rate_death_Day60 < -13] <- -13
merged$Rate_death_Day60 <- round(merged$Rate_death_Day60, 0)

merged$Rate_fatality_Day30 <- log( merged$death_Day30 / merged$case_Day30 )
merged$Rate_fatality_Day30[merged$Rate_fatality_Day30 < -7] <- -7
merged$Rate_fatality_Day30[merged$Rate_fatality_Day30 > -1] <- -1
merged$Rate_fatality_Day30 <- round(merged$Rate_fatality_Day30, 0)

merged$Rate_fatality_Day60 <- log( merged$death_Day60 / merged$case_Day60 )
merged$Rate_fatality_Day60[merged$Rate_fatality_Day60 < -6] <- -6
merged$Rate_fatality_Day60[merged$Rate_fatality_Day60 > -1] <- -1
merged$Rate_fatality_Day60 <- round(merged$Rate_fatality_Day60, 0)


write.csv(merged, "merged10.csv", row.names = FALSE)
