---
title:  
author: 
date:  
output: pdf_document
---
\begin{quote}
\vspace{4cm}
\end{quote}

\begin{quote}

\begin{center}
\Huge\textbf{Metadata Check for GEO Datasets}
\end{center}
\vspace{0.2cm}
\begin{center}
\Large\textbf{Author: "Mohammad Reza Mohajeri"}
\end{center}
\vspace{0.1cm}
\begin{center}
\large\textbf{Date: "2023-08-15"}
\end{center}


\vspace{0.5cm}
This script is tailored to fetch and scrutinize datasets from the Gene Expression Omnibus (GEO) database, irrespective of the dataset type, be it microarray, RNA-seq, or others.
\vspace{0.5cm}





{\hspace*{0.5cm} \Large \textbf{1. Dataset Identification:}} \\
\hspace*{1cm} Initiated with a dataset identifier, for instance, "GSE161420", which signifies a specific dataset in GEO. This identifier is a placeholder and can be substituted with any valid GEO accession number to retrieve corresponding data. \\
 
{\hspace*{0.5cm} \Large \textbf{2. Data Retrieval:}} \\
\hspace*{1cm} The getGEO function from the GEOquery package is employed to obtain the mentioned dataset from GEO. \\

{\hspace*{0.5cm} \Large \textbf{3. Platform Specification:}} \\
\hspace*{1cm} Datasets in GEO might encompass multiple platforms, indicating various methodologies or technologies utilized in generating the data. This script introduces the concept of 'Platforms', denoted by the dataset idx. For instance, if dataset\_idx is set to 1 and the output states "Found 1 file(s)", it suggests that the dataset was generated using one platform. Conversely, "Found 6 file(s)" would imply the presence of data from six distinct platforms. By default, the script is configured to process data from the first platform, but this can be adjusted based on user preference. \\

{\hspace*{0.5cm} \Large \textbf{4. Phenotype Data Viewing:}} \\
\hspace*{1cm} After successful data import, the script endeavors to extract and present the phenotype data of the selected platform. Phenotype data, essentially metadata, offers insights like clinical details, sample origin, and various experimental parameters. For user-friendly viewing, the View function is utilized, especially in interfaces like RStudio, providing data in a tabular, spreadsheet-like layout.

\vspace{0.5cm}

In summary, this script serves as an intermediary tool to seamlessly import GEO datasets, grants the flexibility of platform choice, and facilitates the immediate visual inspection of the pertinent phenotype data.

\end{quote}

\vspace{4cm}

```{r geo_metadata_extraction, message= FALSE}
library(GEOquery)

# Initialize the unique identifier for the dataset on GEO.
# "GSE161420" is a placeholder and can be replaced with any valid GEO accession number.
dataset_id <- "GSE161420"

# Use the getGEO function from the GEOquery package to 
# retrieve the dataset from GEO based on its identifier.
dataset <- GEOquery::getGEO(GEO = dataset_id)

# Datasets in GEO may have multiple platforms indicating different methodologies or technologies.
# 'dataset_idx' specifies the desired platform from the dataset.
# Default is set to 1, indicating the first platform. Adjust as needed.
dataset_idx <- 1 

# Extract and display the phenotype data (metadata about each sample) if available.
if (length(dataset) >= dataset_idx) {
  pheno_data <- Biobase::phenoData(dataset[[dataset_idx]])@data
  # The View function displays the data in a spreadsheet-like viewer.
  View(pheno_data)
} else {
  print("The specified index does not exist in the dataset.")
}
```
 