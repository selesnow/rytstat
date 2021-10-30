
#' Returns a list of channel activity events
#'
#' @param fields Fields of channel metadata, see \href{https://developers.google.com/youtube/v3/docs/activities/list}{API documentation}.
#'
#' @return tibble with channel activies
#' @export
ryt_get_channel_activities <- function(
  fields = c('contentDetails',
             'id',
             'snippet')
) {

  cli_alert_info('Compose params')

  q_params <- list(
    mine = TRUE,
    part = paste0(fields, collapse = ","),
    maxResults = 50
  )

  result <- list()

  cli_alert_info('Send query')
  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = ryt_token(),
      path     = 'youtube/v3/activities',
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


  result <- rename_with(result, to_snake_case)
  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}
