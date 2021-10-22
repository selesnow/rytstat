#' Get list of your videos from 'YouTube'
#'
#' @return tibble with video list
#' @export
#'
ryt_get_video_list <- function() {

  cli_alert_info('Compose params')

  q_params <- list(
          part       = "snippet",
          forMine    = TRUE,
          type       = 'video',
          maxResults = 50
  )

  result <- list()

  cli_alert_info('Send query')
  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {


    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = .auth$cred,
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
            unnest_longer(items) %>%
            unnest_wider(items) %>%
            unnest_wider(id, names_sep = "_") %>%
            unnest_wider(snippet) %>%
            unnest_wider(thumbnails, names_sep = "_") %>%
            unnest_wider(thumbnails_default, names_sep = "_") %>%
            unnest_wider(thumbnails_medium, names_sep = "_") %>%
            unnest_wider(thumbnails_high, names_sep = "_") %>%
            unnest_wider(thumbnails_standard, names_sep = "_") %>%
            unnest_wider(thumbnails_maxres , names_sep = "_") %>%
            rename_with(to_snake_case)

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)
}

