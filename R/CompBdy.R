#' @title Tumor boundary recognition
#'
#' @param st_object a ST Seurat object
#' @param NicheLabel Tumor spot label (default is 'Tumor')
#' @param minSpot Remove areas with fewer spots (default is 10)
#' @param sliceName Slice name (default is 'slices')
#'
#' @return a ST Seurat object
#' @export
#'
#' @examples
CompBdy <- function(st_object, NicheLabel = 'Mal', minSpot = 10, sliceName = "slices") {
  # select tumor spot
  Tumor <- subset(ST, Niche_category %in% NicheLabel)

  # Visualization
  p <- SpatialPlot(Tumor, crop = FALSE, group.by = 'Niche_category')
  print(p)

  # spatial location
  coordinates <- Tumor@images[[sliceName]]@coordinates

  # max location
  xDiml <- max(coordinates$row)
  yDiml <- max(coordinates$col)

  # Convert coordinates
  coordinates$row <- xDiml - coordinates$row
  coordinates$cor_name <- paste0(coordinates$row, "x", coordinates$col)

  # segment spot
  spot_area <- segSpot(coordinates)

  # Count the quantity of each type
  section_counts <- table(spot_area$section)
  print(section_counts)

  # Remove areas with fewer than minSpot spots
  spot_filter <- spot_area %>% group_by(section) %>% filter(n() > minSpot)

  # Initialize group column
  spot_filter$group <- NA

  # Obtain the outer contour of the area and classify it
  for (i in spot_filter$rowname) {
    spot <- c("row" = spot_filter$row[spot_filter$rowname == i], "col" = spot_filter$col[spot_filter$rowname == i])
    suround <- nearSpotN(spot_filter, spot)
    if (nrow(suround) < 6) {
      spot_filter[spot_filter$rowname == i, "Region"] <- "Bdy"
    } else {
      spot_filter[spot_filter$rowname == i, "Region"] <- "Mal"
    }
  }

  # plot spot Region
  p <- ggplot(spot_filter, aes(x = col, y = row, colour = Region)) +
    geom_point() +
    labs(title = "Spot Label", x = "Column", y = "Row") +
    theme_minimal()

  print(p)

  # Extract Region results
  label <- spot_filter[, (ncol(spot_filter)-1):ncol(spot_filter)]
  rownames(label) <- spot_filter$rowname

  st_object <- AddMetaData(st_object, metadata = label)

  # other spot is "nMal"
  st_object@meta.data$Region[is.na(st_object@meta.data$Region)] <- "nMal"


  return(st_object)
}
