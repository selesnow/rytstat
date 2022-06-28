#' Get channel info from 'YouTube API'
#'
#' @param part The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include. Allowed values: contentDetails, id, snippet, statistics, status, topicDetails
#' @param fields Fields of channel metadata, see \href{https://developers.google.com/youtube/v3/docs/channels/list}{API documentation}.
#'
#' @return tibble with channel metadata
#' @export
#'
#' @examples
#' \dontrun{
#' channels <- ryt_get_channels()
#'
#' }
ryt_get_channels <- function(
    part = c('contentDetails',
             'id',
             'snippet',
             'statistics',
             'status',
             'topicDetails'),
    fields = NULL
) {

  cli_alert_info('Compose params')

  q_params <- list(
    mine       = TRUE,
    part       = paste0(part, collapse = ","),
    fields     = fields,
    maxResults = 5
  )

  result <- list()

  cli_alert_info('Send query')
  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = ryt_token(),
      path     = 'youtube/v3/channels',
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

  cli_alert_info('Parse result')
  result <- tibble(items = result) %>%
            unnest_longer(.data$items) %>%
            unnest_wider(.data$items)

  if ( 'snippet' %in%  fields )         result <- unnest_wider(result, .data$snippet)
  if ( 'contentDetails' %in%  fields )  result <- unnest_wider(result, .data$contentDetails)
  if ( 'statistics' %in%  fields )      result <- unnest_wider(result, .data$statistics)
  if ( 'status' %in%  fields )          result <- unnest_wider(result, .data$status)
  if ( 'topicDetails' %in%  fields )    result <- unnest_wider(result, .data$topicDetails)

  result <- rename_with(result, to_snake_case)
  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}
