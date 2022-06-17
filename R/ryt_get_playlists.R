#' Get playlist from 'YouTube API'
#'
#' @param part parts of playist metadata, see \href{https://developers.google.com/youtube/v3/docs/playlists/list}{API documentation}.
#' @param fields Fields of video metadata, see \href{https://developers.google.com/youtube/v3/docs/playlists/list#parameters}{API documentation}.
#'
#' @return tibble with playlist metadata
#'
#' @details Parts and fields
#' **part:**
#' * contentDetails
#' * id
#' * localizations
#' * player
#' * snippet
#' * status
#'
#' **parts and fields details**
#' * kind - Identifies the API resource's type.
#' * etag - The Etag of this resource.
#' * id - The ID that YouTube uses to uniquely identify the playlist.
#' * snippet - The snippet object contains basic details about the playlist, such as its title and description.
#'   * snippet/publishedAt - The date and time that the playlist was created.
#'   * snippet/channelId - The ID that YouTube uses to uniquely identify the channel that published the playlist.
#'   * snippet/title - The playlist's title.
#'   * snippet/description - The playlist's description.
#'   * snippet/thumbnails - A map of thumbnail images associated with the playlist.
#'   * snippet/thumbnails/(key) - Valid key values are: default, medium, high, standard, maxres
#'   * snippet/thumbnails/(key)/url - The image's URL.
#'   * snippet/thumbnails/(key)/width - The image's width.
#'   * snippet/thumbnails/(key)/height - The image's height.
#'   * snippet/channelTitle - The channel title of the channel that the video belongs to.
#'   * snippet/defaultLanguage - The language of the text in the playlist resource's snippet.title and snippet.description properties.
#'   * snippet/localized - The snippet.localized object contains either a localized title and description for the playlist or the title in the default language for the playlist's metadata.
#'   * snippet/localized/title - The localized playlist title.
#'   * snippet/localized/description - The localized playlist description.
#' * status - The status object contains status information for the playlist.
#'   * status/privacyStatus - The playlist's privacy status.
#' * contentDetails - The contentDetails object contains information about the playlist content, including the number of videos in the playlist.
#'   * contentDetails/itemCount - The number of videos in the playlist.
#' * player - The player object contains information that you would use to play the playlist in an embedded player.
#'   * player/embedHtml - An iframe tag that embeds a player that will play the playlist.
#' * localizations - The localizations object encapsulates translations of the playlist's metadata.
#'   * localizations/(key) - The language of the localized text associated with the key value.
#'   * localizations/(key)/title - The localized playlist title.
#'   * localizations/(key)/description - The localized playlist description.
#'
#' @export
#' @examples
#' \dontrun{
#' pl <- ryt_get_playlists(
#'     part = c('id', 'contentDetails', 'snippet'),
#'     fields = 'items(id,snippet/channelId,snippet/title,contentDetails/itemCount)'
#'  )
#' }
ryt_get_playlists <- function(
    part   = c('contentDetails',
               'id',
               'localizations',
               'player',
               'snippet',
               'status'),
    fields = NULL
  ) {

    cli_alert_info('Compose params')

    q_params <- list(
      mine       = TRUE,
      part       = paste0(part, collapse = ","),
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
      path     = 'youtube/v3/playlists',
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

    if ( 'snippet' %in%  part )        result <- unnest_wider(result, .data$snippet)
    if ( 'localizations' %in%  part )  result <- unnest_wider(result, .data$localized, names_sep = "_")
    if ( 'status' %in%  part )         result <- unnest_wider(result, .data$status)
    if ( 'contentDetails' %in%  part ) result <- unnest_wider(result, .data$contentDetails)
    if ( 'player' %in%  part )         result <- unnest_wider(result, .data$player)


    result <- rename_with(result, to_snake_case)
    cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
    return(result)

}
