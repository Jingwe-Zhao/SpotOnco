# SpotOnco
## A novel tool for identifying cancer foci and tumor invasion frontier regions in spatial transcriptomics

![workflow](https://github.com/user-attachments/assets/a1c1dab5-63a6-4040-ab34-94518b38d7f5)




SpotOnco : Provides an efficient method for rapid identification of cancer foci and tumor invasion frontier in tumor spatial transcriptomics data by exploiting spatially scored expression patterns of a Pan-cancer malignant cell gene set

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
