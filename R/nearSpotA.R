#' @title Get 6 spots around some spots
#'
#' @param coor_df spatial coordinates data frame
#' @param spot_all  all spots spatial location
#'
#' @return a data frame
#' @export
#'
#' @examples
nearSpotA = function(coor_df, spot_all){
  res = purrr::map(rownames(spot_all), function(x){
    df_one = spot_all[x,]
    #pinrt(x)
    df_one = nearSpotN(coor_df=coor_df, spot=c("row"=spot_all[x, "row"], "col"=spot_all[x, "col"]))
    df_one = df_one %>% tibble::rownames_to_column(., "barcode")
    return(df_one)
  }) %>% bind_rows() %>% distinct()
  rownames(res) = res$barcode
  res=res[,!colnames(res) %in% c("barcode")]
  return(res)
}

