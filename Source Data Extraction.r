# Final Project - Data Practicum
# Brian K. Nietzold
# August 7, 2025
# Attribution is given to Dun & Bradstreet, Inc. that provides the source data used in my project that has been accessed through the SAM.gov website.

# Set the directory for saving and accessing data to my local directory
setwd('C:/Users/brian.nietzold/Documents/DSSA/Sum25/Data Practicum 5302')


library(tidyverse)   # Manipulates and visualizes data
# These are likely needed tool/packages included in tidyverse:
# readr,rvest,dplyr,readr,stringr,lubridate,hms,ggplot2,purr,tibble,magrittr
# Additionally these are need to web scrabe, 
library(httr) # These functions GET(),PATCH(),POST(),HEAD(),PUT(),and DELETE()
library(jsonlite) # to and from json files
library(writexl)

# Webpage - Data Exploration, investigate the source data
# Familiarizing with the ranges of the data, looking at unique values

# ********************************************************************************************************
# Attribution: Dun & Bradstreet, Inc. that provides the source data used in my project that has been accessed through the SAM.gov website.
# https://sam.gov/
# ********************************************************************************************************


# ************************************************************************************************************************************************************************
# ************************************************************************************************************************************************************************
# ***********************************************     API Pulls/Web Scraping - Data Access     ***************************************************************************
# ************************************************************************************************************************************************************************
# ************************************************************************************************************************************************************************

# SAM.gov API Key
my_api_key <- "lRzVsDTj7lwQWgob1llKGSWKf5KipcFwhUo9pEku"


# ************************************************************************************************************************************************************************
# *******************************************************   Pre-Solicitation    ******************************************************************************************
# ************************************************************************************************************************************************************************


# This base url provides the access to source information for federal opportunities 
# To pull pre-solicitation data use ptype: 'p' for pre-solicitation
# date ranges 'postedFrom' and 'postedTo' by State using 'state' or zip code using 'zip' and the type of set aside using 'typeOfSetAside'
# Small and disadvantaged business codes SDVOSBC, 8A SBA, SBP, WOSB, EDWOSB more see list



base_url <- "https://api.sam.gov/prod/opportunities/v2/search?limit=1000&api_key=lRzVsDTj7lwQWgob1llKGSWKf5KipcFwhUo9pEku&postedFrom=01/01/2025&postedTo=06/29/2025&ptype=p&deptname=general"

# Step 1: Make the API request
response_p <- GET(base_url)
api_response_p <- response_p$status_code # Check to ensure valid response

# Step 2: Show the contents
api_content_p <- response_p$content

# Extract the content from the response (this is where the actual data is)
api_content_p <- content(response_p, as = "text")

# Step 3: Convert response to JSON format
api_JSON_p <- fromJSON(api_content_p, flatten = TRUE) # Flatten true means to create a tabular structure

# Extract the results into a dataframe
# 43 Columns Features and 1000 observations
# Note the limit per API call is 1000 and this step will be repeated over days and weeks to continue to build up the dataset
presolicitation_df <- as.data.frame(api_JSON_p)
presolicitation_col_names <- as.data.frame(colnames(presolicitation_df))

# Identified which columns were of interest and enter into c(4,5,6,7,9,14,15,16,17,18,19,21,26,33,34,35,36,37,38,39,40,41)

presolicitation_selected_df <- presolicitation_df[,c(4,5,6,7,9,14,15,16,17,19,34,35,33,41,40,37,36,39,38)]
presolicitation_col_names <- as.data.frame(colnames(presolicitation_selected_df))

#  str(presolicitation_selected_df)




# Create the pre-solicitation data set for SBA Total Small Business Set-Aside (FAR 19.5) program
presolicitation_SBA_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SBA')

# Create the award data set for 8A program
presolicitation_8A_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == '8A')

# Create the award data set for HZC Historically Underutilized Business (HUBZone) Set-Aside (FAR 19.13)
presolicitation_HZC_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'HZC')

# Create the award data set for SDVOSBC Service-Disabled Veteran-Owned Small Business (SDVOSB) Set-Aside (FAR 19.14)
presolicitation_SDVOSBC_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SDVOSBC')

# Create the award data set for WOSB Women-Owned Small Business (WOSB) Program Set-Aside (FAR 19.15)
presolicitation_WOSB_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'WOSB')

# Create the award data set for EDWOSB Economically Disadvantaged WOSB (EDWOSB) Program Set-Aside (FAR 19.15)
presolicitation_EDWOSB_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'EDWOSB')

# Create the award data set for ISBEE Indian Small Business Economic Enterprise (ISBEE) Set-Aside (specific to Department of Interior)
presolicitation_ISBEE_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'ISBEE')

# Create the award data set for VSA Veteran-Owned Small Business Set-Aside (specific to Department of Veterans Affairs)
presolicitation_VSA_selected_df <- presolicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'VSA')



# ************************************************************************************************************************************************************************
# *******************************************************        Award          ******************************************************************************************
# ************************************************************************************************************************************************************************


# This base url provides the access to source information for federal opportunities  ptype: 'a' is for award

base_url <- "https://api.sam.gov/prod/opportunities/v2/search?limit=1000&api_key=lRzVsDTj7lwQWgob1llKGSWKf5KipcFwhUo9pEku&postedFrom=01/01/2025&postedTo=06/29/2025&ptype=a&deptname=general"

# Step 1: Make the API request
response_a <- GET(base_url)
api_response_a <- response_a$status_code # Check to ensure valid response

# Step 2: Show the contents
api_content_a <- response_a$content

# Extract the content from the response (this is where the actual data is)
api_content_a <- content(response_a, as = "text")

# Step 3: Convert response to JSON format
api_JSON_a <- fromJSON(api_content_a, flatten = TRUE) # Flatten true means to create a tabular structure

# Extract the results into a dataframe
award_df <- as.data.frame(api_JSON_a)

award_selected_df <- award_df[,c(4,5,6,7,9,14,15,16,17,19,30,49,50,51,52,53,54,55,56,57)]
award_col_names <- as.data.frame(colnames(award_selected_df))

# Create the award data set for SBA Total Small Business Set-Aside (FAR 19.5) program
award_SBA_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SBA')

# Create the award data set for 8A program
award_8A_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == '8A')

# Create the award data set for HZC Historically Underutilized Business (HUBZone) Set-Aside (FAR 19.13)
award_HZC_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'HZC')

# Create the award data set for SDVOSBC Service-Disabled Veteran-Owned Small Business (SDVOSB) Set-Aside (FAR 19.14)
award_SDVOSBC_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SDVOSBC')

# Create the award data set for WOSB Women-Owned Small Business (WOSB) Program Set-Aside (FAR 19.15)
award_WOSB_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'WOSB')

# Create the award data set for EDWOSB Economically Disadvantaged WOSB (EDWOSB) Program Set-Aside (FAR 19.15)
award_EDWOSB_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'EDWOSB')

# Create the award data set for ISBEE Indian Small Business Economic Enterprise (ISBEE) Set-Aside (specific to Department of Interior)
award_ISBEE_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'ISBEE')

# Create the award data set for VSA Veteran-Owned Small Business Set-Aside (specific to Department of Veterans Affairs)
award_VSA_selected_df <- award_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'VSA')


# ************************************************************************************************************************************************************************
# *******************************************************    Sources Sought     ******************************************************************************************
# ************************************************************************************************************************************************************************

# This base url provides the access to source information for federal opportunities  ptype: 'r' is sources sought
base_url <- "https://api.sam.gov/prod/opportunities/v2/search?limit=1000&api_key=lRzVsDTj7lwQWgob1llKGSWKf5KipcFwhUo9pEku&postedFrom=01/01/2025&postedTo=06/29/2025&ptype=r&deptname=general"

# Step 1: Make the API request
response_r <- GET(base_url)


api_response_r <- response_r$status_code # Check to ensure valid response

# Step 2: Show the contents
api_content_r <- response_r$content

# Extract the content from the response (this is where the actual data is)
api_content_r <- content(response_r, as = "text")

# Step 3: Convert response to JSON format
api_JSON_r <- fromJSON(api_content_r, flatten = TRUE) # Flatten true means to create a tabular structure

# Extract the results into a dataframe
sources_df <- as.data.frame(api_JSON_r)
sources_selected_df <- sources_df[,c(4,5,6,7,9,14,15,16,17,19,33,35,34,37,36,39,38,41,40)]
sources_col_names <- as.data.frame(colnames(sources_selected_df))

# Checking on the unique values entered for the SBA socioeconomic programs
sba_unique <- unique(sources_selected_df$opportunitiesData.typeOfSetAside)

# Create the sources sought data set for SBA Total Small Business Set-Aside (FAR 19.5) program
sources_SBA_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SBA')

# Create the sources sought data set for 8A program
sources_8A_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == '8A')

# Create the sources sought data set for HZC Historically Underutilized Business (HUBZone) Set-Aside (FAR 19.13)
sources_HZC_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'HZC')

# Create the sources sought data set for SDVOSBC Service-Disabled Veteran-Owned Small Business (SDVOSB) Set-Aside (FAR 19.14)
sources_SDVOSBC_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SDVOSBC')

# Create the sources sought data set for WOSB Women-Owned Small Business (WOSB) Program Set-Aside (FAR 19.15)
sources_WOSB_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'WOSB')

# Create the sources sought data set for EDWOSB Economically Disadvantaged WOSB (EDWOSB) Program Set-Aside (FAR 19.15)
sources_EDWOSB_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'EDWOSB')

# Create the sources sought data set for ISBEE Indian Small Business Economic Enterprise (ISBEE) Set-Aside (specific to Department of Interior)
sources_ISBEE_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'ISBEE')

# Create the sources sought data set for VSA Veteran-Owned Small Business Set-Aside (specific to Department of Veterans Affairs)
sources_VSA_selected_df <- sources_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'VSA')


# ************************************************************************************************************************************************************************
# *******************************************************   Combined Synopsis/Solicitation    ****************************************************************************
# ************************************************************************************************************************************************************************

# This base url provides the access to source information for federal opportunities  ptype: 'k' is combined synopsis/solicitation
base_url <- "https://api.sam.gov/prod/opportunities/v2/search?limit=1000&api_key=lRzVsDTj7lwQWgob1llKGSWKf5KipcFwhUo9pEku&postedFrom=01/01/2025&postedTo=06/29/2025&ptype=k&deptname=general"

# Step 1: Make the API request
response_k <- GET(base_url)
api_response_k <- response_k$status_code # Check to ensure valid response

# Step 2: Show the contents
api_content_k <- response_k$content

# Extract the content from the response (this is where the actual data is)
api_content_k <- content(response_k, as = "text")

# Step 3: Convert response to JSON format
api_JSON_k <- fromJSON(api_content_k, flatten = TRUE) # Flatten true means to create a tabular structure

# Extract the results into a dataframe
combined_df <- as.data.frame(api_JSON_k)
combined_col_names <- as.data.frame(colnames(combined_df))

combined_selected_df <- combined_df[,c(4,5,6,7,9,14,15,16,17,19,46,48,47,50,49,52,51,54,53)]

combined_col_names <- as.data.frame(colnames(combined_selected_df))

# Create the combined data set for SBA Total Small Business Set-Aside (FAR 19.5) program
combined_SBA_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SBA')

# Create the combined data set for 8A program
combined_8A_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == '8A')

# Create the combined data set for HZC Historically Underutilized Business (HUBZone) Set-Aside (FAR 19.13)
combined_HZC_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'HZC')

# Create the combined data set for SDVOSBC Service-Disabled Veteran-Owned Small Business (SDVOSB) Set-Aside (FAR 19.14)
combined_SDVOSBC_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SDVOSBC')

# Create the combined data set for WOSB Women-Owned Small Business (WOSB) Program Set-Aside (FAR 19.15)
combined_WOSB_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'WOSB')

# Create the combined data set for EDWOSB Economically Disadvantaged WOSB (EDWOSB) Program Set-Aside (FAR 19.15)
combined_EDWOSB_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'EDWOSB')

# Create the combined data set for ISBEE Indian Small Business Economic Enterprise (ISBEE) Set-Aside (specific to Department of Interior)
combined_ISBEE_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'ISBEE')

# Create the combined data set for VSA Veteran-Owned Small Business Set-Aside (specific to Department of Veterans Affairs)
combined_VSA_selected_df <- combined_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'VSA')


# ************************************************************************************************************************************************************************
# *******************************************************     Solicitation      ******************************************************************************************
# ************************************************************************************************************************************************************************

# This base url provides the access to source information for federal opportunities  ptype: 'o' is for solicitation
base_url <- "https://api.sam.gov/prod/opportunities/v2/search?limit=1000&api_key=lRzVsDTj7lwQWgob1llKGSWKf5KipcFwhUo9pEku&postedFrom=01/01/2025&postedTo=06/29/2025&ptype=o&deptname=general"

# Step 1: Make the API request
response_o <- GET(base_url)
api_response_o <- response_o$status_code # Check to ensure valid response

# Step 2: Show the contents
api_content_o <- response_o$content

# Extract the content from the response (this is where the actual data is)
api_content_o <- content(response_o, as = "text")

# Step 3: Convert response to JSON format
api_JSON_o <- fromJSON(api_content_o, flatten = TRUE) # Flatten true means to create a tabular structure

# Extract the results into a dataframe
solicitation_df <- as.data.frame(api_JSON_o)
solicitation_selected_df <- solicitation_df[,c(4,5,6,7,9,14,15,16,17,19,33,35,34,36,37,39,38,41,40)]

solicitation_col_names <- as.data.frame(colnames(solicitation_selected_df))


# Create the solicitation data set for SBA Total Small Business Set-Aside (FAR 19.5) program
solicitation_SBA_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SBA')

# Create the solicitation data set for 8A program
solicitation_8A_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == '8A')

# Create the solicitation data set for HZC Historically Underutilized Business (HUBZone) Set-Aside (FAR 19.13)
solicitation_HZC_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'HZC')

# Create the solicitation data set for SDVOSBC Service-Disabled Veteran-Owned Small Business (SDVOSB) Set-Aside (FAR 19.14)
solicitation_SDVOSBC_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'SDVOSBC')

# Create the solicitation data set for WOSB Women-Owned Small Business (WOSB) Program Set-Aside (FAR 19.15)
solicitation_WOSB_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'WOSB')

# Create the solicitation data set for EDWOSB Economically Disadvantaged WOSB (EDWOSB) Program Set-Aside (FAR 19.15)
solicitation_EDWOSB_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'EDWOSB')

# Create the solicitation data set for ISBEE Indian Small Business Economic Enterprise (ISBEE) Set-Aside (specific to Department of Interior)
solicitation_ISBEE_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'ISBEE')

# Create the solicitation data set for VSA Veteran-Owned Small Business Set-Aside (specific to Department of Veterans Affairs)
solicitation_VSA_selected_df <- solicitation_selected_df %>% filter(opportunitiesData.typeOfSetAside == 'VSA')


# Need to exploit this data for lcats and lrates:  Digital Experience (DX) CALC+ Quick Rate API
# Need to exploit this data for regulations and rules; Regulations.gov API
# Need to explore the viability of using this apiL  Per Diem API




# ************************************************************************************************************************************************************************
# ************************************************************************************************************************************************************************
# ***********************************************                Data Wrangling                ***************************************************************************
# ************************************************************************************************************************************************************************
# ************************************************************************************************************************************************************************


# ************************************************************************************************************************************************************************
# **********************************************************      SBA Pipeline  ******************************************************************************************
# ************************************************************************************************************************************************************************
opportunities_SBA <- rbind(presolicitation_SBA_selected_df, sources_SBA_selected_df, solicitation_SBA_selected_df, combined_SBA_selected_df)
predict_SBA <- as.data.frame(rbind(award_SBA_selected_df))


# ************************************************************************************************************************************************************************
# **********************************************************      8A Pipeline  *******************************************************************************************
# ************************************************************************************************************************************************************************
opportunities_8A <- rbind(presolicitation_8A_selected_df, sources_8A_selected_df,  solicitation_8A_selected_df, combined_8A_selected_df)
predict_8A <- rbind(award_8A_selected_df)


# ************************************************************************************************************************************************************************
# **********************************************************      HZC Pipeline  ******************************************************************************************
# ************************************************************************************************************************************************************************
opportunities_HZC <- rbind(presolicitation_HZC_selected_df, sources_HZC_selected_df, solicitation_HZC_selected_df, combined_HZC_selected_df)
predict_HZC <- rbind(award_HZC_selected_df)



opportunities_SDVOSBC <- rbind(presolicitation_SDVOSBC_selected_df, sources_SDVOSBC_selected_df, combined_SDVOSBC_selected_df, solicitation_SDVOSBC_selected_df)
predict_SDVOSBC <- rbind(award_SDVOSBC_selected_df)



opportunities_WOSB <- rbind(presolicitation_WOSB_selected_df, sources_WOSB_selected_df, combined_WOSB_selected_df, solicitation_WOSB_selected_df)
predict_WOSB <- rbind(award_WOSB_selected_df)



opportunities_EDWOSB <- rbind(presolicitation_EDWOSB_selected_df, sources_EDWOSB_selected_df, combined_EDWOSB_selected_df, solicitation_EDWOSB_selected_df)
predict_EDWOSB <- rbind(award_EDWOSB_selected_df)



opportunities_ISBEE <- rbind(presolicitation_ISBEE_selected_df, sources_ISBEE_selected_df, combined_ISBEE_selected_df, solicitation_ISBEE_selected_df)
predict_ISBEE <- rbind(award_ISBEE_selected_df)




opportunities_VSA <- rbind(presolicitation_VSA_selected_df, sources_VSA_selected_df, combined_VSA_selected_df, solicitation_VSA_selected_df)
predict_VSA <- rbind(award_VSA_selected_df)




# ***********************************************************************************************************
# ***********************************************************************************************************




# ***********************************     Data Saving to CSV     ********************************************
# ***********************************************************************************************************

# Save the dataframe as a CSV file in same folder as R file
write_xlsx(as.data.frame(opportunities_SBA), "SBA_Pipeline.xlsx")


write_xlsx(opportunities_8A, "8A_Pipeline.xlsx")

# Save the dataframe as a CSV file in same folder as R file
write.xlsx(opportunities_HZC, "HZC_Pipeline.xlsx")

# Save the dataframe as a CSV file in same folder as R file
write.xlsx(opportunities_SDVOSBC, "SDVOSBC_Pipeline.xlsx")


# Save the dataframe as a CSV file in same folder as R file
write.xlsx(opportunities_WOSB, "WOSB_Pipeline.xlsx")


# Save the dataframe as a CSV file in same folder as R file
write.xlsx(opportunities_EDWOSB, "EDWOSB_Pipeline.xlsx")


# Save the dataframe as a CSV file in same folder as R file
write.xlsx(opportunities_ISBEE, "SBA_Pipeline.xlsx")


write.xlsx(opportunities_VSA, "VSA_Pipeline.xlsx")


# ***********************************************************************************************************
# ***********************************************************************************************************
