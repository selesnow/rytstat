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
            unnest_wider(.data$items) %>%
            unnest_wider(.data$id, names_sep = "_") %>%
            unnest_wider(.data$snippet) %>%
            unnest_wider(.data$thumbnails, names_sep = "_") %>%
            unnest_wider(.data$thumbnails_default, names_sep = "_") %>%
            unnest_wider(.data$thumbnails_medium, names_sep = "_") %>%
            unnest_wider(.data$thumbnails_high, names_sep = "_") %>%
            unnest_wider(.data$thumbnails_standard, names_sep = "_") %>%
            unnest_wider(.data$thumbnails_maxres , names_sep = "_") %>%
            rename_with(to_snake_case)

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)
}

