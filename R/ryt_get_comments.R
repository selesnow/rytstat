#' Returns a list of comment threads of video or channel
#'
#' @param video_id YouTUbe Video ID
#' @param channel_id YouTube Channel ID
#' @param text_format Set this parameter's value to html or plainText to instruct the API to return the comments left by users in html formatted or in plain text. The default value is plainText
#'
#' @return tibble with comments
#' @seealso \href{https://developers.google.com/youtube/v3/docs/commentThreads/list}{Reporting API Documentation}.
#' @export
#'
#' @examples
#' \dontrun{
#' # all comments
#' comments <- ryt_get_comments()
#'
#' # videos comments
#' video_comments <- ryt_get_comments(video_id = 'fW7gGS^G78')
#' }
ryt_get_comments <- function(
  video_id = NULL,
  channel_id = NULL,
  text_format = c('plainText', 'html')
) {

  cli_alert_info('Compose params')

  q_params <- list(
    videoId = video_id,
    channelId = channel_id,
    part = 'id,replies,snippet',
    textFormat = match.arg(text_format, text_format),
    maxResults = 3
  )

  result <- list()

  cli_alert_info('Send query')
  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = ryt_token(),
      path     = 'youtube/v3/commentThreads',
      base_url = 'https://www.googleapis.com/'
    )

    # send request
    ans <- request_retry(
      out,
      encode = 'json'
    )

    resp <- response_process(ans)
    result <- append(result, list(resp$items))
    q_params$pageToken <- resp$nextPageToken

  }

  if ( length(result) > 0 ) {
    result <- tibble(items = result) %>%
                unnest_longer(.data$items) %>%
                unnest_wider(.data$items) %>%
                unnest_wider(.data$snippet) %>%
                unnest_wider(.data$replies) %>%
                unnest_longer(.data$comments) %>%
                unnest_wider(.data$comments, names_sep = "_") %>%
                unnest_wider(.data$comments_snippet, names_sep = "_") %>%
                unnest_longer(.data$comments_snippet_authorChannelId) %>%
                rename_with(to_snake_case)
  }

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)
}
