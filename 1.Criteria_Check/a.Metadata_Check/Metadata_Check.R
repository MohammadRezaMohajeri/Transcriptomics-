
# =============================================================================
# title:          "Metadata Check for GEO Datasets"
# author:                "Mohammad Reza Mohajeri"
# date:                      "2023-08-15"
# =============================================================================

# =============================================================================
#  This script is tailored to fetch and scrutinize datasets from the GEO database,
#  irrespective of the dataset type, be it microarray, RNA-seq, or others.
# =============================================================================
# "For detailed code insights, see 'Metadata_Check.pdf'."
# =============================================================================



# GEO Metadata Extraction 
# ========================
library(GEOquery)
# ========================

# Initialize the unique identifier for the dataset on GEO.
# "GSE161420" is a placeholder and can be replaced with any valid GEO accession number.
dataset_id <- "GSE161420"
# ========================

# Use the getGEO function from the GEOquery package to 
# retrieve the dataset from GEO based on its identifier.
dataset <- GEOquery::getGEO(GEO = dataset_id)
# ========================

# Datasets in GEO may have multiple platforms indicating different methodologies or technologies.
# 'dataset_idx' specifies the desired platform from the dataset.
# Default is set to 1, indicating the first platform. Adjust as needed.
dataset_idx <- 1 
# ========================

# Extract and display the phenotype data (metadata about each sample) if available.
if (length(dataset) >= dataset_idx) {
  pheno_data <- Biobase::phenoData(dataset[[dataset_idx]])@data
  # The View function displays the data in a spreadsheet-like viewer.
  View(pheno_data)
} else {
  print("The specified index does not exist in the dataset.")
}
# ========================

