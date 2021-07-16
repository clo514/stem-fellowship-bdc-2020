#### R Scripts/Environments #####
File
Description
Notes



HopkinsData.R
First script to generate merged[1-9].csv's. Uses datafiles from Datafiles/ directory.
Run first.



HopkinsData_environment.RData
Environment of merged dataset prior to addition of modified New York Times data.



HopkinsData_environment_modified NY.RData
Environment of merged dataset with the addition of modified New York Times data.



HopkinsData_environment_modified NY_kaggle dataset.RData
Environment of merged dataset with the addition of modified New York Times data and US Counties: Covid-19 + Weather + Socio/Health data.



20200628_Round 2 Data.R
Second script to generate updated merged10.csv (as of June 27, 2020). Requires datafiles from Datafiles/ directory, as well as merged9.csv.
Run second.



20200628_Round 2 Data_environment.RData
Environment of merged10.csv dataset.



#### Datafiles ####
File
Feature data
Notes



Datafiles/5year ACS commuting flows.csv
MEANS OF TRANSPORTATION TO WORK BY PLACE OF WORK--STATE AND COUNTY LEVEL
https://www.census.gov/data/tables/2015/demo/metro-micro/commuting-flows-2015.html
Universe: Workers 16 years and over.



Datafiles/20200523_Hopkins_dailyreport_all_counties.txt
Hopkins data (May 23, 2020)
Not used in final version



Datafiles/20200627_Hopkins_dailyreport_all_counties.txt
Hopkins data (June 27, 2020)
Not used in final version



Datafiles/ACSDT1Y2018.B08130_data_with_overlays_2020-05-25T235204.csv
MEANS OF TRANSPORTATION TO WORK BY PLACE OF WORK--STATE AND COUNTY LEVEL 
https://www.census.gov/content/census/en/data/datasets/2017/econ/cbp/2017-cbp.html
Only 840 counties



Datafiles/co-est2019-alldata.csv
Population-Size, International Migration, Domestic Migration, Births, Deaths
https://data.census.gov/cedsci/table?q=county&g=0100000US,.050000&tid=ACSDT1Y2018.B08130&vintage=2018&hidePreview=true
Census data
Information about naming:	https://www2.census.gov/programs-surveys/popest/technical-documentation/file-layouts/2010-2019/co-est2019-alldata.pdf



Datafiles/GDP.csv
GDP 2018
https://apps.bea.gov/iTable/index_regional.cfm



Datafiles/JieYingWu Data.txt
https://github.com/JieYingWu/COVID-19_US_County-level_Summaries/blob/master/data/counties.csv
Annotations:    https://github.com/JieYingWu/COVID-19_US_County-level_Summaries/blob/master/data/list_of_columns.mdSummaries/blob/master/data/list_of_columns.csv
Availability:   https://github.com/JieYingWu/COVID-19_US_County-level_Summaries/blob/master/data/availability.csv



Datafiles/ny_case.csv
New York Times COVID-19 case data in the United States (June 27, 2020)
https://github.com/nytimes/covid-19-data



Datafiles/ny_death.csv
New York Times COVID-19 death data in the United States (June 27, 2020)
https://github.com/nytimes/covid-19-data



Datafiles/PerCapitaIncome.csv
Per Capita Income 2018
https://apps.bea.gov/iTable/index_regional.cfm



