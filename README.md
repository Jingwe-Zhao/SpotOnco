# SpotOnco
## A universal tool for rapid identification of cancer foci and tumor boundary in spatial transcriptomics

![workflw3png](https://github.com/user-attachments/assets/b7b60025-ae15-4c2c-83ea-e9c29ffa8e20)



SpotOnco : Provides an efficient method for rapid identification of cancer foci and tumor boundaries in tumor spatial transcriptomics data by exploiting spatially scored expression patterns of a  malignant cell gene set

# Installation
### Dependencies
* R packages: Seurat, VISION, tidyverse

```
# install the SpotOnco package
devtools::install_github('Jingwe-Zhao/SpotOnco')
```

```
library(SpotOnco)
library(VISION)
library(clusterProfiler)
library(tidyverse)

# load demo data
data<- system.file("data", "CRC1.RDS", package = "SpotOnco")
ST<-readRDS(data)

# SCTransform And Clustering
ST<-SCT(ST, resolution = 0.3)
SpatialPlot(ST)

# malignancy Scoring
ST<-CompScore(ST, assay = "Spatial")

# Niche category 
ST<-NicheCat(ST,formula = 'Q1')

# Tumor boundary recognition Description
ST <- CompBdy(ST, NicheLabel = 'Mal', minSpot = 10, sliceName = "CRC1")

SpatialPlot(ST,group.by = 'Region')
```
### More features are being developed
