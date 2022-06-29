#' Search channels, playlists or videos on YouTube
#' @description Returns a collection of search results that match the query parameters specified in the API request. By default, a search result set identifies matching video, channel, and playlist resources, but you can also configure queries to only retrieve a specific type of resource.
#' @param part The part parameter specifies a comma-separated list of one or more search resource properties that the API response will include. Set the parameter value to snippet.
#' @param ... Filters and Optional parameters for resources search. See [list of all allowed params](https://developers.google.com/youtube/v3/docs/search/list#parameters). You can set params names in came or snake case.
#'
#' @return resources list
#' @export
#'
#' @examples
#' \dontrun{
#' # search
#' search_res_videos <- ryt_search(
#'   type            = 'video',
#'   q               = 'r language tutorial',
#'   published_after = '2022-03-01T00:00:00Z',
#'   published_before = '2022-06-01T00:00:00Z',
#'   max_results     = 10
#' )
#'
#' search_res_playlists <- ryt_search(
#'   type             = 'playlist',
#'   q                = 'r language tutorial',
#'   published_after  = '2022-03-01T00:00:00Z',
#'   published_before = '2022-06-01T00:00:00Z',
#'   max_results      = 50
#' )
#'
#' search_res_channels <- ryt_search(
#' type             = 'channel',
#' q                = 'r language tutorial',
#' published_after  = '2022-03-01T00:00:00Z',
#'   published_before = '2022-06-01T00:00:00Z',
#'   max_results      = 50
#' )
#' )
#' }
ryt_search <- function(
    part = "snippet",
    ...
  ) {

  cli_alert_info('Compose params')
  part <- paste0(part, collapse = ",")
  q_params <- c(as.list(environment()), list(...))
  names(q_params) <- names(q_params) %>% to_lower_camel_case()
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
  result <- tibble(items = resp$items) %>%
            unnest_wider(.data$items)

  nested_fields <- select(result, where(is.list)) %>% names()
  nested_fields <- nested_fields[!nested_fields %in% c("tags", "topicDetails")]

  while ( length(nested_fields) > 0 ) {

    for ( col in nested_fields ) {

      if (col == "tags") next

      result_t <- try(unnest_wider(result, col), silent = T)

      if ( 'try-error' %in% class(result_t) ) {
        result <- unnest_wider(result, col, names_sep = '_')
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

