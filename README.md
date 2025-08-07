Final-Project-DSSA-Data-Practicum

**PLEASE DO NOT RUN**  This application uses API calls to the federal government website SAM.gov which strictly limits the data authorized to download and will lock me out if the limits are exceeded.

Attribution: Dun & Bradstreet, Inc. that provides the source data used in my project that has been accessed through the SAM.gov website.
Source of raw data from: https://sam.gov/

R based application to create a clean dataset from raw data regarding federal contract opportunities obtained from the federal government website SAM.gov.
Initial software version only has the API calls functioning to retrieve raw data from SAM.gov, a government website that publishes contract opportunities for interested federal contractors.
The R code clean and processes the data into usable clean data sets that will be the source to train a future machine learning algorithm.  The output from the source code is a series of dataset saved in excel format.  

The out put a dataset for each of the SBA's socioeconmoic programs:
  SBA_Pipeline.xlsx       Total Small Business                                
  8A_Pipeline.xlsx        8A                                                 
  HZC_Pipeline.xlsx       Historically Underutilized Business                
  SDVOSBC_Pipeline.xlsx   Service-Disabled Veteran Owned Small Business
  WOSB_Pipeline.xlsx      Woman-Owned Small Business
  ISBEE_Pipeline.xlsx     Indian Small Business Economic Enterprise
  VSA_Pipeline.xlsx       Veteran-Owned Small Business
