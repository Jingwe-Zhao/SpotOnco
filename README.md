# SpotOnco
## A universal tool for rapid identification of cancer foci and tumor boundary in spatial transcriptome

![workflow](https://github.com/user-attachments/assets/ba3b2ad4-7cf5-4ecf-9c37-85825298bc0b)

SpotOnco, a method based on machine learning that utilizes the spatial expression patterns of specific metabolic gene sets to provide an efficient way to quickly identify cancer lesions and tumor boundaries in cancer tissue slices

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
