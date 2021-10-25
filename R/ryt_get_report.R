#' Returns a list of report types that the channel or content owner can retrieve. Each item in the list contains an id property, which identifies the report's ID, and you need this value to schedule a reporting job.
#'
#' @return ryt_get_report_types: tibble with report types
#' @export
#' @family reporting api functions
#' @rdname reporting_api
#' @seealso \href{https://developers.google.com/youtube/reporting/v1/reference/rest/v1/reportTypes/list}{Reporting API Documentation: Method reportTypes.list}.
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

#' Creates a reporting job.
#' @description By creating a reporting job, you are instructing YouTube to generate that report on a daily basis. The report is available within 24 hours of the time that the job is created.
#' @param report_type The type of report that the job creates. The property value corresponds to the id of a reportType as retrieved from the \code{\link{ryt_get_report_types}} function.
#'
#' @return ryt_reports_create_job: No return value, called for side effects
#' @export
#' @family reporting api functions
#' @rdname reporting_api
#' @seealso \href{https://developers.google.com/youtube/reporting/v1/reference/rest/v1/jobs/create}{Reporting API Documentation: Method jobs.create}
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

#' Lists reporting jobs that have been scheduled for a channel or content owner.
#' @description Each resource in the response contains an id property, which specifies the ID that YouTube uses to uniquely identify the job. You need that ID to retrieve the list of reports that have been generated for the job or to delete the job.
#' @return ryt_reports_get_job_list: tibble with jobs metadata
#' @seealso \href{https://developers.google.com/youtube/reporting/v1/reference/rest/v1/jobs/list}{Reporting API Documentation: Method jobs.list}
#' @export
#' @rdname reporting_api
#' @family reporting api functions
ryt_reports_get_job_list <- function() {

  q_params <- list()
  result   <- list()

  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

    out <- request_build(
      method   = "GET",
      params   = q_params,
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
    q_params$pageToken <- resp$nextPageToken

  }

  cli_alert_info('Parse result')
  result <- tibble(items = result) %>%
            unnest_longer(.data$items) %>%
            unnest_wider(.data$items)

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}

#' Lists reports that have been generated for the specified reporting job.
#'
#' @param job_id The ID that YouTube uses to uniquely identify the job for which reports are being listed.
#' @param created_after If specified, this parameter indicates that the API response should only contain reports created after the specified date and time, including new reports with backfilled data. Note that the value pertains to the time that the report is created and not the dates associated with the returned data. The value is a timestamp in RFC3339 UTC "Zulu" format, accurate to microseconds. Example: \code{"2015-10-02T15:01:23.045678Z"}.
#' @param start_time_at_or_after This parameter indicates that the API response should only contain reports if the earliest data in the report is on or after the specified date. Whereas the createdAfter parameter value pertains to the time the report was created, this date pertains to the data in the report. The value is a timestamp in RFC3339 UTC "Zulu" format, accurate to microseconds. Example: \code{"2015-10-02T15:01:23.045678Z"}.
#' @param start_time_before This parameter indicates that the API response should only contain reports if the earliest data in the report is before the specified date. Whereas the createdAfter parameter value pertains to the time the report was created, this date pertains to the data in the report. The value is a timestamp in RFC3339 UTC "Zulu" format, accurate to microseconds. Example: \code{"2015-10-02T15:01:23.045678Z"}.
#'
#' @return ryt_reports_get_report_list: tibble with reports metadata
#' @export
#' @family reporting api functions
#' @rdname reporting_api
#' @seealso \href{https://developers.google.com/youtube/reporting/v1/reference/rest/v1/jobs.reports/list}{Reporting API Documentation: Method jobs.reports.list }
ryt_reports_get_report_list <- function(
  job_id,
  created_after = NULL,
  start_time_at_or_after = NULL,
  start_time_before = NULL
  ) {

  q_params <- list(

  )
  result   <- list()

  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {
    out <- request_build(
      method   = "GET",
      params   = q_params,
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

    result <- append(result, list(resp$reports))
    q_params$pageToken <- resp$nextPageToken
  }

  cli_alert_info('Parse result')
  result <- tibble(items = result) %>%
            unnest_longer(.data$items) %>%
            unnest_wider(.data$items)

  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}

#' Load report data
#'
#' @param download_url download URL, you can get it by \code{\link{ryt_reports_get_report_list}} or \code{\link{ryt_get_report_metadata}}
#'
#' @return ryt_get_report: tibble with report data
#' @seealso \href{https://developers.google.com/youtube/reporting/v1/reports}{Reporting API Documentation: Data Model}
#' @export
#' @family reporting api functions
#' @rdname reporting_api
#' @examples
#' \dontrun{
#'  # auth
#'  ryt_auth('me@gmail.com')
#'
#'  # get reporting data
#'  ## create job
#'  ryt_reports_create_job('channel_basic_a2')
#'
#'  ## get job list
#'  jobs <- ryt_reports_get_job_list()
#'
#'  ## get job report list
#'  reports <- ryt_reports_get_report_list(
#'    job_id = jobs$id[1],
#'    created_after = '2021-10-20T15:01:23.045678Z'
#'  )
#'
#'  ## get report data
#'  data <- ryt_get_report(
#'    download_url = reports$downloadUrl[1]
#'  )
#'
#'  ## delete job
#'  ryt_reports_delete_job(jobs$id[1])
#'  }
ryt_get_report <- function(download_url){

  out <- request_build(
    method   = "GET",
    token    = ryt_token(),
    path     = str_remove_all(download_url, 'https://youtubereporting.googleapis.com/'),
    base_url = 'https://youtubereporting.googleapis.com/'
  )

  # send request
  cli_alert_info('Send query')

  ans <- request_retry(
    out,
    encode = content_type("text/csv")
  )

  data <- content(ans, 'parsed', "text/csv", encoding = 'UTF-8', show_col_types = FALSE)

  cli_alert_success(str_glue('Success, loading {nrow(data)} rows.'))
  return(data)
}

#' Retrieves the metadata for a specific report.
#'
#' @param job_id job_id The ID that YouTube uses to uniquely identify the job for which reports are being listed. Use \code{\link{ryt_reports_get_job_list}}.
#' @param report_id The ID that YouTube uses to uniquely identify the report that is being retrieved. Use \code{\link{ryt_reports_get_report_list}}
#' @seealso \href{https://developers.google.com/youtube/reporting/v1/reference/rest/v1/jobs.reports/get}{Reporting API Documentation: Method jobs.reports.get}
#' @return ryt_get_report_metadata: list with report metadata
#' @export
#' @family reporting api functions
#' @rdname reporting_api
ryt_get_report_metadata <- function(
  job_id,
  report_id
) {

  out <- request_build(
    method   = "GET",
    token    = ryt_token(),
    path     = str_glue('v1/jobs/{job_id}/reports/{report_id}'),
    base_url = 'https://youtubereporting.googleapis.com/'
  )

  # send request
  cli_alert_info('Send query')
  ans <- request_retry(
    out,
    encode = 'json'
  )

  resp <- response_process(ans)

}

#' Deletes a reporting job.
#'
#' @param job_id The ID that YouTube uses to uniquely identify the job that is being deleted. Use \code{\link{ryt_reports_get_job_list}}.
#'
#' @return ryt_reports_delete_job: No return value, called for side effects
#' @seealso \href{https://developers.google.com/youtube/reporting/v1/reference/rest/v1/jobs/delete}{Reporting API Documentation: Method jobs.delete}
#' @export
#' @family reporting api functions
#' @rdname reporting_api
ryt_reports_delete_job <- function(
  job_id
){

  out <- request_build(
    method   = "DELETE",
    token    = ryt_token(),
    path     = str_glue('v1/jobs/{job_id}'),
    base_url = 'https://youtubereporting.googleapis.com/'
  )

  ans <- request_retry(
    out,
    encode = 'multipart'
  )

  resp <- response_process(ans)

  cli_alert_success(str_glue('Success, job was deleted.'))
  return(TRUE)
}
