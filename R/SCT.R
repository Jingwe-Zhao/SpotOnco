#' @title SCTransform And Clustering
#'
#' @param st_object a ST Seurat object
#' @param assay default is 'Spatial'
#' @param npcs Total Number of PCs to compute and store
#' @param resolution Value of the resolution parameter
#'
#' @return a normalized ST object
#' @export
#'
#' @examples
SCT <- function(st_object, assay = "Spatial", npcs = 30, resolution = 0.3) {
  if (is.null(assay)){
    assay <- Seurat::DefaultAssay(st_object)
  }

  st_object <- SCTransform(st_object, assay = assay) %>%
    RunPCA(npcs = npcs) %>%
    FindNeighbors(reduction = "pca") %>%
    FindClusters(resolution = resolution)

  # Add Niche column
  if ("seurat_clusters" %in% colnames(st_object@meta.data)) {
    st_object@meta.data$Niche <- paste0('Niche', st_object@meta.data$seurat_clusters)

  # Set identities to Niche
  Seurat::Idents(st_object) <- st_object@meta.data$Niche
  } else {
  warning("seurat_clusters not found")
  }

  return(st_object)
}
