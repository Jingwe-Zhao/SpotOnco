#' @title Get 6 spots around a certain spot
#'
#' @param coor_df spatial coordinates data frame
#' @param spot spatial location
#'
#' @return a data frame
#' @export
#'
#' @examples
nearSpotN = function(coor_df, spot){
  #spot = as.vector(spot)
  spot_top_left = c(row=spot["row"] + 1, col=spot["col"] - 1)
  spot_top_right = c(row=spot["row"] + 1, col=spot["col"] + 1)
  spot_right = c(row=spot["row"], col=spot["col"] + 2)
  spot_bottom_right = c(row=spot["row"] - 1, col=spot["col"] + 1)
  spot_bottom_left = c(row=spot["row"] - 1, col=spot["col"] - 1)
  spot_left = c(row=spot["row"], col=spot["col"] - 2)

  df_circle = data.frame(row=c(spot_top_left[1], spot_top_right[1],spot_right[1],spot_bottom_right[1],spot_bottom_left[1],spot_left[1]),
                         col=c(spot_top_left[2], spot_top_right[2],spot_right[2],spot_bottom_right[2],spot_bottom_left[2],spot_left[2])
  )

  df_circle$cor_name = paste0(df_circle$row, "x", df_circle$col)
  df_circle = coor_df[coor_df$cor_name %in% df_circle$cor_name,]
  return(df_circle)
}


