#' Get statistics from 'YouTube Analytics API'
#' @description The YouTube Analytics API enables you to generate custom reports containing YouTube Analytics data. The API supports reports for channels and for content owners.
#' @param start_date The start date for fetching YouTube Analytics data. The value should be in YYYY-MM-DD format.
#' @param end_date The end date for fetching YouTube Analytics data. The value should be in YYYY-MM-DD format.
#' @param metrics Character vector of YouTube Analytics metrics, such as views or likes,dislikes. See the \href{https://developers.google.com/youtube/analytics/channel_reports}{documentation} for channel reports or a list of the reports that you can retrieve and the metrics available in each report. The \href{https://developers.google.com/youtube/analytics/dimsmets/mets}{Metrics document} contains definitions for all of the metrics.
#' @param dimensions Character vector of YouTube Analytics dimensions, such as video or ageGroup,gender. The \href{https://developers.google.com/youtube/analytics/dimsmets/dims}{Dimensions document} contains definitions for all of the dimensions.
#' @param filters Character vector of filters that should be applied when retrieving YouTube Analytics data. The \href{https://developers.google.com/youtube/analytics/channel_reports}{documentation} for channel reports reports identifies the dimensions that can be used to filter each report, and the \href{https://developers.google.com/youtube/analytics/dimsmets/dims}{Dimensions document} defines those dimensions.
#'
#' @return tibble with analytics data
#' @export
#' @examples
#' \dontrun{
#' # auth
#' ryt_auth()
#'
#' # get list of your videos
#' videos <- ryt_get_video_list()
#'
#' # function for loading video stat
#' get_videos_stat <- function(video_id) {
#'
#'   data <- ryt_get_analytics(
#'     metrics = c('views', 'likes', 'dislikes', 'comments', 'shares'),
#'     filters = stringr::str_glue('video=={video_id}')
#'   )
#'
#'   if ( nrow(data) > 0 ) {
#'     data <- mutate(data, video_id = video_id)
#' }
#' }
#'
#' # load video stat
#' video_stat <- purrr::map_df(videos$id_video_id, get_videos_stat)
#'
#' # join stat with video metadata
#' video_stat <- left_join(video_stat,
#'                         videos,
#'                         by = c("video_id" = "id_video_id")) %>%
#'               select(video_id,
#'                      title,
#'                      day,
#'                      views,
#'                      likes,
#'                      dislikes,
#'                      comments,
#'                      shares)
#' }
ryt_get_analytics <- function(
  start_date = Sys.Date() - 14,
  end_date = Sys.Date(),
  metrics = c('views',
              'estimatedMinutesWatched',
              'averageViewDuration',
              'averageViewPercentage',
              'subscribersGained'),
  dimensions = 'day',
  filters = NULL
) {

  cli_alert_info('Compose params')
  metrics <- paste0(metrics, collapse = ',')
  dimensions <- paste0(dimensions, collapse = ',')

  out <- request_build(
    method   = "GET",
    params   = list(startDate = start_date,
                    endDate = end_date,
                    ids = 'channel==MINE',
                    dimensions = 'day',
                    filters = filters,
                    metrics = metrics),
    token    = ryt_token(),
    path     = 'v2/reports',
    base_url = 'https://youtubeanalytics.googleapis.com/'
  )

  # send request
  cli_alert_info('Send query')
  ans <- request_retry(
    out,
    encode = 'json'
  )

  resp <- response_process(ans)


  cli_alert_info('Parse result')
  suppressMessages(
    {data <- tibble(response = resp$rows) %>%
            unnest_wider(.data$response)
    }
  )

  if ( nrow(data) == 0 ) {
    cli_alert_warning('Empty answer')
    return(tibble())
  }

  headers <- tibble(response = resp$columnHeaders) %>%
             unnest_wider(.data$response)

  data <- set_names(data, headers$name)

  cli_alert_success(str_glue('Success, loading {nrow(data)} rows.'))
  return(data)

}
