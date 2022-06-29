#' Get channel info from 'YouTube API'
#'
#' @param part The part parameter specifies a comma-separated list of one or more channel resource properties that the API response will include., see \href{https://developers.google.com/youtube/v3/docs/channels/list}{API documentation}.
#' @param fields Allows you to specify individual nested part fields
#' @return tibble with channel metadata
#' @export
#'
#' @details Parts and fields
#' **part:**
#' * auditDetails
#' * brandingSettings
#' * contentDetails
#' * contentOwnerDetails
#' * id
#' * localizations
#' * snippet
#' * statistics
#' * status
#' * topicDetails
#'
#' **parts and fields details**
#' * kind - Identifies the API resource's type.
#' * etag - The Etag of this resource.
#' * id - The ID that YouTube uses to uniquely identify the channel.
#' * snippet - The snippet object contains basic details about the channel, such as its title, description, and thumbnail images.
#'   * snippet.title - The channel's title.
#'   * snippet.description - The channel's description. The property's value has a maximum length of 1000 characters.
#'   * snippet.customUrl - The channel's custom URL. The YouTube Help Center explains eligibility requirements for getting a custom URL as well as how to set up the URL.
#'   * snippet.publishedAt - The date and time that the channel was created. The value is specified in ISO 8601 format.
#'   * snippet.thumbnails - A map of thumbnail images associated with the channel. For each object in the map, the key is the name of the thumbnail image, and the value is an object that contains other information about the thumbnail.
#'   * snippet.thumbnails.(key) - Valid key values are: default, medium, high.
#'   * snippet.thumbnails.(key).url - The image's URL. See the snippet.thumbnails property definition for additional guidelines on using thumbnail URLs in your application.
#'   * snippet.thumbnails.(key).width - The image's width.
#'   * snippet.thumbnails.(key).height - The image's height.
#'   * snippet.defaultLanguage - The language of the text in the channel resource's snippet.title and snippet.description properties.
#'   * snippet.localized - The snippet.localized object contains a localized title and description for the channel or it contains the channel's title and description in the default language for the channel's metadata.
#'   * snippet.localized.title - The localized channel title.
#'   * snippet.localized.description - The localized channel description.
#'   * snippet.country - The country with which the channel is associated.
#' * contentDetails - The contentDetails object encapsulates information about the channel's content.
#'   * contentDetails.relatedPlaylists - The relatedPlaylists object is a map that identifies playlists associated with the channel, such as the channel's uploaded videos or liked videos.
#'   * contentDetails.relatedPlaylists.likes - The ID of the playlist that contains the channel's liked videos.
#'   * contentDetails.relatedPlaylists.uploads - The ID of the playlist that contains the channel's uploaded videos.
#' * statistics - The statistics object encapsulates statistics for the channel.
#'   * statistics.viewCount - The number of times the channel has been viewed.
#'   * statistics.subscriberCount - The number of subscribers that the channel has.
#'   * statistics.hiddenSubscriberCount - Indicates whether the channel's subscriber count is publicly visible.
#'   * statistics.videoCount - The number of public videos uploaded to the channel.
#' * topicDetails - The topicDetails object encapsulates information about topics associated with the channel.
#'   * topicDetails.topicIds[] - A list of topic IDs associated with the channel.
#'   * topicDetails.topicCategories[] - A list of Wikipedia URLs that describe the channel's content.
#' * status - The status object encapsulates information about the privacy status of the channel.
#'   * status.privacyStatus - Privacy status of the channel.
#'   * status.isLinked - Indicates whether the channel data identifies a user that is already linked to either a YouTube username or a Google+ account.
#'   * status.longUploadsStatus - Indicates whether the channel is eligible to upload videos that are more than 15 minutes long.
#'   * status.madeForKids - This value indicates whether the channel is designated as child-directed, and it contains the current "made for kids" status of the channel.
#'   * status.selfDeclaredMadeForKids - In a channels.update request, this property allows the channel owner to designate the channel as child-directed.
#' * brandingSettings - The brandingSettings object encapsulates information about the branding of the channel.
#'   * brandingSettings.channel - The channel object encapsulates branding properties of the channel page.
#'   * brandingSettings.channel.title - The channel's title. The title has a maximum length of 30 characters.
#'   * brandingSettings.channel.description - The channel description, which appears in the channel information box on your channel page. The property's value has a maximum length of 1000 characters.
#'   * brandingSettings.channel.keywords - Keywords associated with your channel.
#'   * brandingSettings.channel.trackingAnalyticsAccountId - The ID for a Google Analytics account that you want to use to track and measure traffic to your channel.
#'   * brandingSettings.channel.moderateComments - This setting determines whether user-submitted comments left on the channel page need to be approved by the channel owner to be publicly visible.
#'   * brandingSettings.channel.unsubscribedTrailer - The video that should play in the featured video module in the channel page's browse view for unsubscribed viewers.
#'   * brandingSettings.channel.defaultLanguage - The language of the text in the channel resource's snippet.title and snippet.description properties.
#'   * brandingSettings.channel.country - The country with which the channel is associated. Update this property to set the value of the snippet.country property.
#'   * brandingSettings.watch - The watch object encapsulates branding properties of the watch pages for the channel's videos.
#'   * brandingSettings.watch.textColor - The text color for the video watch page's branded area.
#'   * brandingSettings.watch.backgroundColor - The background color for the video watch page's branded area.
#' * auditDetails - The auditDetails object encapsulates channel data that a multichannel network (MCN) would evaluate while determining whether to accept or reject a particular channel.
#'   * auditDetails.overallGoodStanding - This field indicates whether there are any issues with the channel. Currently, this field represents the result of the logical AND operation over the communityGuidelinesGoodStanding, copyrightStrikesGoodStanding, and contentIdClaimsGoodStanding properties, meaning that this property has a value of true if all of those other properties also have a value of true.
#'   * auditDetails.communityGuidelinesGoodStanding - Indicates whether the channel respects YouTube's community guidelines.
#'   * auditDetails.copyrightStrikesGoodStanding - Indicates whether the channel has any copyright strikes.
#'   * auditDetails.contentIdClaimsGoodStanding - Indicates whether the channel has any unresolved claims.
#' * contentOwnerDetails - The contentOwnerDetails object encapsulates channel data that is relevant for YouTube Partners linked with the channel.
#'   * contentOwnerDetails.contentOwner - The ID of the content owner linked to the channel.
#'   * contentOwnerDetails.timeLinked - The date and time of when the channel was linked to the content owner. The value is specified in ISO 8601 format.
#' * localizations - The localizations object encapsulates translations of the channel's metadata.
#'   * localizations.(key) - The language of the localized metadata associated with the key value.
#'   * localizations.(key).title - The localized channel title.
#'   * localizations.(key).description - The localized channel description.
#'
#' @examples
#' \dontrun{
#' channels <- ryt_get_channels()
#'
#' }
ryt_get_channels <- function(
    part = c('contentDetails',
             'id',
             'snippet',
             'statistics',
             'status',
             'topicDetails'),
    fields = NULL
) {

  cli_alert_info('Compose params')

  q_params <- list(
    mine = TRUE,
    part = paste0(part, collapse = ","),
    fields = fields,
    maxResults = 5
  )

  result <- list()

  cli_alert_info('Send query')
  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = ryt_token(),
      path     = 'youtube/v3/channels',
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

  if ( 'snippet' %in%  part )         result <- unnest_wider(result, .data$snippet)
  if ( 'contentDetails' %in%  part )  result <- unnest_wider(result, .data$contentDetails)
  if ( 'statistics' %in%  part )      result <- unnest_wider(result, .data$statistics)
  if ( 'status' %in%  part )          result <- unnest_wider(result, .data$status)
  if ( 'topicDetails' %in%  part )    result <- unnest_wider(result, .data$topicDetails)

  result <- rename_with(result, to_snake_case)
  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}
