ryt_get_playlist_items_helper <- function(
  playlist_id,
  fields = c('contentDetails',
             'id',
             'snippet',
             'status')
) {


  fields <- paste0(fields, collapse = ",")

  q_params <- list(
    playlistId = playlist_id,
    part = fields,
    maxResults = 50
  )

  result <- list()

  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

  out <- request_build(
    method   = "GET",
    params   = q_params,
    token    = ryt_token(),
    path     = 'youtube/v3/playlistItems',
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


  result <- tibble(items = result) %>%
            unnest_longer(.data$items) %>%
            unnest_wider(.data$items)

  nested_fields <- select(result, where(is.list)) %>%
                   names()

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


  return(result)

}
