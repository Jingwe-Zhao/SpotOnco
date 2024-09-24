#' @title Scoring based on characteristic gene set
#'
#' @param st_object a ST Seurat object
#' @param assay default is 'Spatial'
#' @param slot 	Slot to pull expression data from (default is counts)
#' @param ncores multi-core
#'
#' @return ST object after scoring
#' @export
#'
#' @examples
CompScore <- function(st_object,assay = 'Spatial', slot = "counts", ncores = 1) {
  signatures <- system.file("data", "gene_set.gmt", package = "SpotOnco")

  if (is.null(assay)) {
    assay <- Seurat::DefaultAssay(st_object)
  }

  matrix <- Seurat::GetAssayData(object = st_object, slot = slot, assay = assay)
  x <- as.matrix(matrix)
  n.umi <- colSums(x)
  center.umi <- median(n.umi)
  scaled_counts <- t(t(x) / n.umi) * center.umi

  vis <- Vision(scaled_counts, signatures = signatures, min_signature_genes = 1)
  options(mc.cores = ncores)
  vis <- analyze(vis)

  signature_exp <- data.frame(vis@SigScores)
  colnames(signature_exp)[1] <- 'malignancy_score'
  st_object <- Seurat::AddMetaData(st_object, signature_exp)

  return(st_object)
}
