# =============================================================================================================
# title:          "Automated Validation of Homo sapiens Presence in GEO Datasets"
# author:                "Mohammad Reza Mohajeri"
# date:                      "2023-07-15"
# =============================================================================================================
# This script aids researchers in efficiently identifying and validating GEO datasets with Homo sapiens samples. 
#
# Key functionalities include:
# 1. Displaying the GEO accession number for dataset correlation. 
# 2. Reporting total samples and Homo sapiens count. 
# 3. Highlighting the relevant column for potential manual verification. 
# 4. Confirming when all samples match the Homo sapiens criterion.
# 
# This tool streamlines dataset screening, ensuring researchers work with relevant and accurate data.
# =============================================================================================================
# Example output:
# [1] "In the dataset GSE161420 , there are 60 samples in total, and 60 of them are Homo sapiens." 
# [1] "Homo sapiens found in the following columns: organism ch1" 
# [1] "All samples are human." 
# =============================================================================================================
# "For detailed code insights, see "Organism_Identifier.pdf"
# =============================================================================================================






# =============================================================================================================
#                                            Homo Sapiens Samples Checker
# =============================================================================================================
# Library imports
library(GEOquery)

# Dataset Identifier Initialization
dataset_id <- "GSE161420"

# Data Retrieval
dataset = GEOquery::getGEO(GEO = dataset_id)

# Specifying the Platform
dataset_idx <- 1 # Default set to 1

# Extracting Phenotype Data
if (length(dataset) >= dataset_idx) {
  pheno_data <- Biobase::phenoData(dataset[[dataset_idx]])@data
} else {
  stop("The specified index does not exist in the dataset.")
}

# Initialize a counter for human samples
human_samples <- 0

# Initialize a list to store column names where 'Homo sapiens' is found
columns_with_humans <- list()

# Loop through each column to search for 'Homo sapiens'
for(colname in names(pheno_data)) {
  if(is.factor(pheno_data[[colname]]) || is.character(pheno_data[[colname]])) {
    num_human_in_col <- sum(pheno_data[[colname]] == 'Homo sapiens', na.rm = TRUE)
    
    if(num_human_in_col > 0) {
      human_samples <- human_samples + num_human_in_col
      columns_with_humans <- c(columns_with_humans, list(colname))
    }
  }
}

# Find out the total number of samples
total_samples <- nrow(pheno_data)

# Create and print the final message
if(human_samples > 0) {
  final_message <- paste(
    "In the dataset", dataset_id, 
    ", there are", total_samples, "samples in total, and", 
    human_samples, "of them are Homo sapiens.")
  
  print(final_message)
  
  columns_message <- paste(
    "Homo sapiens found in the following columns:", 
    paste(columns_with_humans, collapse=", "))
  
  print(columns_message)
  
  if(human_samples == total_samples) {
    print("All samples are human.")
  } else {
    print("Not all samples are human.")
  }
} else {
  print("No Homo sapiens samples were found.")
}



