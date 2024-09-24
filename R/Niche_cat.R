#' @title Niche category based on malignancy_score
#'
#' @param st_object a ST Seurat object
#' @param score_column malignancy_score column name
#' @param niche_column ST Niche column name
#' @param formula Choose 'Q1' or 'median'(default is Q1:lower quartile)
#'
#' @return ST object after Niche category
#' @export
#'
#' @examples
NicheCat <- function(st_object, score_column = "malignancy_score", niche_column = "Niche", formula = "Q1") {
  # check score_column
  if (!score_column %in% colnames(st_object@meta.data) || !niche_column %in% colnames(st_object@meta.data)) {
    stop("score_column don't exist in ST@meta.data")
  }

  # malignancy_score Q1 or median
  if (formula == "Q1") {
    threshold_value <- quantile(st_object@meta.data[[score_column]], 0.25, na.rm = TRUE)
  } else if (formula == "median") {
    threshold_value <- median(st_object@meta.data[[score_column]], na.rm = TRUE)
  } else {
    stop("Invalid value for formula, Choose 'Q1' or 'median'.")
  }


  # Niche median_values
  median_values <- aggregate(as.formula(paste(score_column, "~", niche_column)),
                             data = st_object@meta.data,
                             FUN = median, na.rm = TRUE)

  # Niche category
  median_values$Niche_category <- ifelse(median_values[[score_column]] > threshold_value, "Mal", "nMal")


  # update ST@meta.data
  st_object@meta.data <- st_object@meta.data %>%
    mutate(Niche_category = coalesce(median_values$Niche_category[match(Niche, median_values$Niche)], "nMal"))

  return(st_object)
}
