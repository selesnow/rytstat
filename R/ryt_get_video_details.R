#' Get detail data of your videos on 'YouTube'
#'
#' @param video_id Video ID.
#' @param fields Fields of data, see \href{https://developers.google.com/youtube/v3/docs/videos/list}{API documentation}.
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return tibble with video details
#' @export
#'
#' @examples
ryt_get_video_details <- function(
  video_id,
  fields = c('contentDetails',
             'fileDetails',
             'id',
             'liveStreamingDetails',
             'localizations',
             'player',
             'processingDetails',
             'recordingDetails',
             'snippet',
             'statistics',
             'status',
             'suggestions',
             'topicDetails'),
  cl = NULL
) {

  res <- pblapply(
          video_id,
          ryt_get_video_details_helper,
          fields = fields,
          cl = cl
          )

  res <- bind_rows(res) %>%
         rename_with(to_snake_case)

  return(res)

}
