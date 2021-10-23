ryt_get_report_types <- function(){

  q_params <- list()
  result   <- list()

  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {
    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = ryt_token(),
      path     = 'v1/reportTypes',
      base_url = 'https://youtubereporting.googleapis.com/'
    )

    # send request
    cli_alert_info('Send query')
    ans <- request_retry(
      out,
      encode = 'json'
    )

    resp <- response_process(ans)

    result <- append(result, list(resp$reportTypes))

    q_params$pageToken <- resp$nextPageToken
  }

  cli_alert_info('Parse result')
  result <- tibble(items = result) %>%
            unnest_longer(.data$items) %>%
            unnest_wider(.data$items)

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}

ryt_reports_create_job <- function(
  report_type = c('channel_annotations_a1',
                  'channel_basic_a2',
                  'channel_cards_a1',
                  'channel_combined_a2',
                  'channel_demographics_a1',
                  'channel_device_os_a2',
                  'channel_end_screens_a1',
                  'channel_playback_location_a2',
                  'channel_province_a2',
                  'channel_sharing_service_a1',
                  'channel_playback_location_a2',
                  'channel_province_a2',
                  'channel_sharing_service_a1',
                  'channel_subtitles_a2',
                  'channel_traffic_source_a2',
                  'playlist_basic_a1',
                  'playlist_device_os_a1',
                  'playlist_playback_location_a1',
                  'playlist_province_a1',
                  'playlist_traffic_source_a1')
) {

  report_type <- match.arg(report_type)

  job_name <- str_glue('{report_type}: {Sys.time()} by ryoutube')

  job <- list(reportTypeId = report_type,
              name = job_name)

  out <- request_build(
    method   = "POST",
    body     = job,
    token    = ryt_token(),
    path     = 'v1/jobs',
    base_url = 'https://youtubereporting.googleapis.com/'
  )

  # send request
  cli_alert_info('Send query')
  ans <- request_retry(
    out,
    encode = 'json'
  )

  resp <- response_process(ans)

  return(resp)

}

ryt_reports_get_job_list <- function() {

  q_params <- list()
  result   <- list()

  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

    out <- request_build(
      method   = "GET",
      token    = ryt_token(),
      path     = 'v1/jobs',
      base_url = 'https://youtubereporting.googleapis.com/'
    )

    # send request
    cli_alert_info('Send query')
    ans <- request_retry(
      out,
      encode = 'json'
    )

    resp <- response_process(ans)

    result <- append(result, list(resp$jobs))

  }

  cli_alert_info('Parse result')
  result <- tibble(items = result) %>%
            unnest_longer(.data$items) %>%
            unnest_wider(.data$items)

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}

ryt_reports_get_report_list <- function(job_id) {

  out <- request_build(
    method   = "GET",
    token    = ryt_token(),
    path     = str_glue('v1/jobs/{job_id}/reports'),
    base_url = 'https://youtubereporting.googleapis.com/'
  )

  # send request
  cli_alert_info('Send query')
  ans <- request_retry(
    out,
    encode = 'json'
  )

  resp <- response_process(ans)

  result <- append(result, list(resp$reportTypes))

}

ryt_get_report <- function(){

}
