#' @title Segment Divide the spot into regions
#'
#' @param selected_df Selected spots
#'
#' @return section spot data frame
#' @export
#'
#' @examples
segSpot = function(selected_df){
  spot_area = list()
  for (row_idx in rownames(selected_df)){
    #idx = 0
    if (row_idx %in% unlist(spot_area))
    {next}

    spot_1 = selected_df[row_idx, ]

    idx = length(spot_area) + 1
    spot_area[[idx]] = c(row_idx)

    new_spot = nearSpotN(selected_df, spot=c(row=spot_1$row[1], col=spot_1$col[1]))
    if(nrow(new_spot) == 0){next}
    else{
      new_area = c(spot_area[[idx]], rownames(new_spot))
      while(length(new_area) > length(spot_area[[idx]]))
      {
        spot_area[[idx]] = new_area
        new_area_df = nearSpotA(coor_df = selected_df, spot_all=selected_df[spot_area[[idx]],])
        new_area = unique(c(spot_area[[idx]], rownames(new_area_df)))
      }
    }

  }
  spot_area = data.frame(barcode = unlist(spot_area), section = rep(seq(length(spot_area)), lengths(spot_area)))
  df_section = left_join(rownames_to_column(selected_df), spot_area, by = c('rowname'="barcode"))
  return(df_section)
}
