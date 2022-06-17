#' Get playlist items data on 'YouTube'
#'
#' @param playlist_id Playlist ID, see \code{\link{ryt_get_playlists}}.
#' @param part The part parameter specifies a comma-separated list of one or more playlistItem resource properties that the API response will include. see \href{https://developers.google.com/youtube/v3/docs/playlistItems/list}{API documentation}.
#' @param fields The fields parameter filters the API response, which only contains the resource parts identified in the part parameter value, so that the response only includes a specific set of fields. see \href{https://developers.google.com/youtube/v3/docs/playlistItems/list#properties}{API documentation}.
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @return tibble with playlist items details
#'
#' @details Parts and fields
#' **part:**
#' * contentDetails
#' * id
#' * snippet
#' * status
#'
#' **parts and fields details**
#' * kind - Identifies the API resource's type. The value will be youtube#playlistItemListResponse.
#' * etag - The Etag of this resource.
#' * id - The ID that YouTube uses to uniquely identify the playlist item.
#' * snippet - The snippet object contains basic details about the playlist item, such as its title and position in the playlist.
#'   * snippet/publishedAt - The date and time that the item was added to the playlist.
#'   * snippet/channelId - The ID that YouTube uses to uniquely identify the user that added the item to the playlist.
#'   * snippet/title - The item's title.
#'   * snippet/description - The item's description.
#'   * snippet/thumbnails - A map of thumbnail images associated with the playlist item.
#'   * snippet/thumbnails/(key) - Valid key values are: default, medium, high, standard, maxres
#'   * snippet/thumbnails/(key)/url - The image's URL.
#'   * snippet/thumbnails/(key)/width - The image's width.
#'   * snippet/thumbnails/(key)/height - The image's height.
#'   * snippet/channelTitle - The channel title of the channel that the playlist item belongs to.
#'   * snippet/videoOwnerChannelTitle - The channel title of the channel that uploaded this video.
#'   * snippet/videoOwnerChannelId - The channel ID of the channel that uploaded this video.
#'   * snippet/playlistId - The ID that YouTube uses to uniquely identify the playlist that the playlist item is in.
#'   * snippet/position - The order in which the item appears in the playlist.
#'   * snippet/resourceId	- The id object contains information that can be used to uniquely identify the resource that is included in the playlist as the playlist item.
#'   * snippet/resourceId.kind - The kind, or type, of the referred resource.
#'   * snippet/resourceId/videoId - If the snippet.resourceId.kind property's value is youtube#video, then this property will be present and its value will contain the ID that YouTube uses to uniquely identify the video in the playlist.
#' * contentDetails - The contentDetails object is included in the resource if the included item is a YouTube video. The object contains additional information about the video.
#'   * contentDetails/videoId - The ID that YouTube uses to uniquely identify a video.
#'   * contentDetails/note - A user-generated note for this item. The property value has a maximum length of 280 characters.
#'   * contentDetails/videoPublishedAt - The date and time that the video was published to YouTube.
#' * status - The status object contains information about the playlist item's privacy status.
#'   * status/privacyStatus - The playlist item's privacy status.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # get playlist ids and title
#' pl <- ryt_get_playlists(part = c('id', 'snippet'), fields = 'items(id, snippet/title)')
#'
#' # get itemms of first playlist
#' pli <- ryt_get_playlist_items(
#'     playlist_id = pl$id[1],
#'     part = c('contentDetails', 'snippet'),
#'     fields = 'items(id,snippet/channelId,snippet/title,contentDetails/videoId)'
#'  )
#' }
ryt_get_playlist_items <- function(
  playlist_id,
  part = c('contentDetails',
            'id',
            'snippet',
            'status'),
  fields = NULL,
  cl = NULL
) {

  res <- pblapply(
    playlist_id,
    ryt_get_playlist_items_helper,
    part = part,
    fields = fields,
    cl = cl
  )

  res <- bind_rows(res) %>%
         rename_with(to_snake_case)

  return(res)

}
