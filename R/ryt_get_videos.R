#' Get list of your videos from 'YouTube'
#'
#' @param fields Fields of video metadata, see \href{https://developers.google.com/youtube/v3/docs/videos/list}{API documentation}.
#' @return tibble with video list
#' @export
#'
ryt_get_videos <- function(
    fields = NULL
  ) {

  cli_alert_info('Compose params')

  q_params <- list(
          part       = "snippet",
          forMine    = TRUE,
          type       = 'video',
          fields     = fields,
          maxResults = 50
  )

  result <- list()

  cli_alert_info('Send query')
  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {


    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = ryt_token(),
      path     = 'youtube/v3/search',
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

  nested_fields <- select(result, where(is.list)) %>% names()
  nested_fields <- nested_fields[!nested_fields %in% c("tags", "topicDetails")]

  while ( length(nested_fields) > 0 ) {

    for ( col in nested_fields ) {

      if (col == "tags") next

      result_t <- try(unnest_wider(result, any_of(col)), silent = T)

      if ( 'try-error' %in% class(result_t) ) {
        result <- unnest_wider(result, any_of(col), names_sep = '_')
      } else {
        result <- result_t
      }

    }

    nested_fields <- select(result, where(is.list)) %>%
      names()

    nested_fields <- nested_fields[!nested_fields %in% c("tags", "topicDetails")]

  }

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)
}

