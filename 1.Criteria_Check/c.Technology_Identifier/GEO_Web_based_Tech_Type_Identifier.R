# =============================================================================================================
# title:          "GEO Web-based Technology Identifier"
# author:              "Mohammad Reza Mohajeri"
# date:                    "2023-8-25"
# =============================================================================================================
# NOTE: This code is a working prototype and requires further modifications for enhanced accuracy. 
# =============================================================================================================
# Identifying Transcriptomics Technology Types from GEO Webpages using GEO Accession Numbers   
# such as Expression Array, Bulk RNA-seq, and Single-cell RNA-seq
# =============================================================================================================
# This automation aids researchers in swiftly and efficiently classifying datasets and ensuring compatibility with their analytical requirements. 
# 
# Quickly discern the technology type (e.g., Single-cell RNA-seq, Bulk RNA-seq, Expression Array) of a GEO dataset using a given accession number or a list of them
# =============================================================================================================
# "For detailed code insights, see "GEO_Web_based_Tech_Type_Identifier.pdf"
# =============================================================================================================




# ============================================================================================================= 
#                    1. Technology Identification for a Single GEO Accession Number:
# =============================================================================================================

# Load necessary libraries
library(stringi)
library(rvest)
library(dplyr)

get_dataset_type <- function(accession_number) {
  # Construct the URL
  url <- paste0("https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=", accession_number)
  
  # Fetch the page content (rvest)
  page <- read_html(url)
  
  # Extract the text content from the page (rvest and dplyr)
  page_text <- page %>% html_text()
  
  # Convert to lower case for case-insensitive matching (base R)
  page_text_lower <- tolower(page_text)
  
  # Initialize an empty vector to hold matching keywords (base R)
  matching_keywords <- c()
  
  # Priority check for single-cell keywords (stringi) 
  if (stri_detect_regex(page_text_lower, "single[- ]?cell") || 
      stri_detect_regex(page_text_lower, "sc[- ]?rna[- ]?seq")) {
    
    matching_keywords <- c("Single-cell RNA-seq")
    return(paste("The dataset", accession_number, "is of type: Single-cell RNA-seq, because of keywords:", paste(matching_keywords, collapse=", ")))
  }
  
  # Check for the keywords to determine the type of dataset
  if (stri_detect_fixed(page_text_lower, "array") &&
      stri_detect_fixed(page_text_lower, "expression")) {
    matching_keywords <- c(matching_keywords, "Array", "Expression")
    return(paste("The dataset", accession_number, "is of type: Expression Array, because of keywords:", paste(matching_keywords, collapse=", ")))
  }
  
  if (stri_detect_fixed(page_text_lower, "rna-seq")) {
    matching_keywords <- c(matching_keywords, "RNA-Seq")
  } 
  
  if (stri_detect_fixed(page_text_lower, "rna sequencing")) {
    matching_keywords <- c(matching_keywords, "RNA Sequencing")
  }
  
  if (stri_detect_fixed(page_text_lower, "expression profiling") && 
      stri_detect_fixed(page_text_lower, "high throughput") && 
      stri_detect_fixed(page_text_lower, "illumina")) {
    matching_keywords <- c(matching_keywords, "Expression profiling", "High throughput", "Illumina")
  }
  
  if (stri_detect_fixed(page_text_lower, "bulkrnaseq")) {
    matching_keywords <- c(matching_keywords, "BulkRnaseq")
  }
  
  if (length(matching_keywords) > 0) {
    return(paste("The dataset", accession_number, "is of type: Bulk RNA-seq, because of keywords:", paste(matching_keywords, collapse=", ")))
  } else {
    return(paste("The dataset", accession_number, "is of type: Other/Unknown"))
  }
}

# Test the function with a GEO accession number
result <- get_dataset_type("GSE159282")  # Replace this with any GEO accession number
print(result)






# ============================================================================================================= 
#         2. Technology Identification for Multiple GEO Accession Numbers from a TSV File:
# ============================================================================================================= 

# Load necessary libraries
library(stringi)
library(rvest)
library(dplyr)
library(readr)
library(writexl)

# options(timeout=300)  # sets timeout to 10 minutes

get_dataset_type <- function(accession_number) {
  url <- paste0("https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=", accession_number)
  page <- read_html(url)
  page_text <- page %>% html_text()
  page_text_lower <- tolower(page_text)
  matching_keywords <- c()
  
  if (stri_detect_regex(page_text_lower, "single[- ]?cell") || 
      stri_detect_regex(page_text_lower, "sc[- ]?rna[- ]?seq")) {
    matching_keywords <- c("Single-cell RNA-seq")
    return(c("Single cell RNA Seq", paste("Keywords:", paste(matching_keywords, collapse=", "))))
  }
  
  if (stri_detect_fixed(page_text_lower, "array") && 
      stri_detect_fixed(page_text_lower, "expression")) {
    matching_keywords <- c(matching_keywords, "Array", "Expression")
    return(c("Expression array", paste("Keywords:", paste(matching_keywords, collapse=", "))))
  }
  
  if (stri_detect_fixed(page_text_lower, "rna-seq")) {
    matching_keywords <- c(matching_keywords, "RNA-Seq")
  }
  
  if (stri_detect_fixed(page_text_lower, "rna sequencing")) {
    matching_keywords <- c(matching_keywords, "RNA Sequencing")
  }
  
  if (stri_detect_fixed(page_text_lower, "expression profiling") && 
      stri_detect_fixed(page_text_lower, "high throughput") && 
      stri_detect_fixed(page_text_lower, "illumina")) {
    matching_keywords <- c(matching_keywords, "Expression profiling", "High throughput", "Illumina")
  }
  
  if (length(matching_keywords) > 0) {
    return(c("Bulk RNA Seq", paste("Keywords:", paste(matching_keywords, collapse=", "))))
  } else {
    return(c("Other", "N/A"))
  }
}

# Read the list of dataset IDs from the TSV file
dataset_ids <- read_tsv("/home/omidmoh1980/Desktop/SLE_Dataset_IDs.tsv")$Dataset_ID

# Initialize an empty data frame to store the results
result_df <- data.frame(Dataset_ID=character(),
                        Type=character(),
                        Reason=character(),
                        stringsAsFactors=FALSE)

# Loop through each dataset ID and get its type and reason
for(id in dataset_ids) {
  
  
  Sys.sleep(5)  # Add a 5-second delay here
  
  type_and_reason <- get_dataset_type(id)
  result_df <- rbind(result_df, data.frame(Dataset_ID=id, 
                                           Type=type_and_reason[1], 
                                           Reason=type_and_reason[2], 
                                           stringsAsFactors=FALSE))
}

# Save the result to a new TSV file
write_tsv(result_df, "/Desktop/GEO_Technology_Type_Result.tsv")

