#' Get detail data of your videos on 'YouTube'
#'
#' @param video_id Video ID, see \code{\link{ryt_get_videos}}.
#' @param fields Fields of video metadata, see \href{https://developers.google.com/youtube/v3/docs/videos/list}{API documentation}.
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return tibble with video details
#' @export
#' @examples
#' \dontrun{
#' # get all videos
#' videos <- ryt_get_videos()
#'
#' # get videos metadata
#' videos_details <- ryt_get_video_details(
#'     video_id = videos$id_video_id
#' )
#'
#' }
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

  # split by 50 videos
  x <- seq_along(video_id)
  video_id <- split(video_id, ceiling(x/50))
  video_id <- lapply(video_id, paste0, collapse = ',')

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
