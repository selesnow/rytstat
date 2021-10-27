#' Get playlist items data on 'YouTube'
#'
#' @param playlist_id Playlist ID.
#' @param fields Fields of video metadata, see \href{https://developers.google.com/youtube/v3/docs/playlistItems/list}{API documentation}.
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return tibble with playlist items details
#' @export
#'
ryt_get_playlist_items <- function(
  playlist_id,
  fields = c('contentDetails',
             'id',
             'snippet',
             'status'),
  cl = NULL
) {

  res <- pblapply(
    playlist_id,
    ryt_get_playlist_items_helper,
    fields = fields,
    cl = cl
  )

  res <- bind_rows(res) %>%
         rename_with(to_snake_case)

  return(res)

}
