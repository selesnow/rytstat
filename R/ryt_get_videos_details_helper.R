ryt_get_video_details_helper <- function(
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
             'topicDetails')
) {

  fields <- paste0(fields, collapse = ",")

  out <- request_build(
    method   = "GET",
    params   = list(
      id = video_id,
      part = fields
    ),
    token    = .auth$cred,
    path     = 'youtube/v3/videos',
    base_url = 'https://www.googleapis.com/'
  )

  # send request
  ans <- request_retry(
    out,
    encode = 'json'
  )

  resp <- response_process(ans)

  result <- tibble(items = resp$items) %>%
            unnest_wider(.data$items)

  nested_fields <- select(result, where(is.list)) %>%
                   names()
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

  return(result)

}

