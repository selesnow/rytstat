
#' Returns a list of channel activity events
#'
#' @param part The part parameter specifies a comma-separated list of one or more activity resource properties that the API response will include. See \href{https://developers.google.com/youtube/v3/docs/activities/list}{API documentation}.
#' @param fields Fields of video metadata see \href{https://developers.google.com/youtube/v3/docs/activities#properties}{Properties}
#' @return tibble with channel activies
#' @export
#'
#' @details Parts and fields
#' **part:**
#' * contentDetails
#' * id
#' * snippet
#'
#' **parts and fields details**
#' * kind - Identifies the API resource's type.
#' * etag - The Etag of this resource.
#' * id - The ID that YouTube uses to uniquely identify the activity.
#' * snippet - The snippet object contains basic details about the activity, including the activity's type and group ID.
#'   * snippet.publishedAt - The date and time that the activity occurred.
#'   * snippet.channelId - The ID that YouTube uses to uniquely identify the channel associated with the activity.
#'   * snippet.title - The title of the resource primarily associated with the activity.
#'   * snippet.description - The description of the resource primarily associated with the activity.
#'   * snippet.thumbnails - A map of thumbnail images associated with the resource that is primarily associated with the activity.
#'   * snippet.thumbnails.(key) - Valid key values are: default, medium, high, standard, maxres
#'   * snippet.thumbnails.(key).url - The image's URL.
#'   * snippet.thumbnails.(key).width - The image's width.
#'   * snippet.thumbnails.(key).height - The image's height.
#'   * snippet.channelTitle - Channel title for the channel responsible for this activity
#'   * snippet.type - The type of activity that the resource describes.
#'   * snippet.groupId - The group ID associated with the activity.
#' * contentDetails - The contentDetails object contains information about the content associated with the activity.
#'   * contentDetails.upload - The upload object contains information about the uploaded video.
#'   * contentDetails.upload.videoId - The ID that YouTube uses to uniquely identify the uploaded video.
#'   * contentDetails.like - The like object contains information about a resource that received a positive (like) rating.
#'   * contentDetails.like.resourceId - The resourceId object contains information that identifies the rated resource.
#'   * contentDetails.like.resourceId.kind - The type of the API resource.
#'   * contentDetails.like.resourceId.videoId - The ID that YouTube uses to uniquely identify the video, if the rated resource is a video.
#'   * contentDetails.favorite - The favorite object contains information about a video that was marked as a favorite video.
#'   * contentDetails.favorite.resourceId - The resourceId object contains information that identifies the resource that was marked as a favorite.
#'   * contentDetails.favorite.resourceId.kind - The type of the API resource.
#'   * contentDetails.favorite.resourceId.videoId - The ID that YouTube uses to uniquely identify the favorite video.
#'   * contentDetails.comment - The comment object contains information about a resource that received a comment. This property is only present if the snippet.type is comment.
#'   * contentDetails.comment.resourceId - The resourceId object contains information that identifies the resource associated with the comment.
#'   * contentDetails.comment.resourceId.kind - The type of the API resource.
#'   * contentDetails.comment.resourceId.videoId - The ID that YouTube uses to uniquely identify the video associated with a comment.
#'   * contentDetails.comment.resourceId.channelId - The ID that YouTube uses to uniquely identify the channel associated with a comment.
#'   * contentDetails.subscription - The subscription object contains information about a channel that a user subscribed to.
#'   * contentDetails.subscription.resourceId - The resourceId object contains information that identifies the resource that the user subscribed to.
#'   * contentDetails.subscription.resourceId.kind - The type of the API resource.
#'   * contentDetails.subscription.resourceId.channelId - The ID that YouTube uses to uniquely identify the channel that the user subscribed to.
#'   * contentDetails.playlistItem - The playlistItem object contains information about a new playlist item.
#'   * contentDetails.playlistItem.resourceId - The resourceId object contains information that identifies the resource that was added to the playlist.
#'   * contentDetails.playlistItem.resourceId.kind - The type of the API resource.
#'   * contentDetails.playlistItem.resourceId.videoId - The ID that YouTube uses to uniquely identify the video that was added to the playlist. This property is only present if the resourceId.kind is youtube#video.
#'   * contentDetails.playlistItem.playlistId - The value that YouTube uses to uniquely identify the playlist.
#'   * contentDetails.playlistItem.playlistItemId - The value that YouTube uses to uniquely identify the item in the playlist.
#'   * contentDetails.recommendation - The recommendation object contains information about a recommended resource. This property is only present if the snippet.type is recommendation.
#'   * contentDetails.recommendation.resourceId - The resourceId object contains information that identifies the recommended resource.
#'   * contentDetails.recommendation.resourceId.kind - The type of the API resource.
#'   * contentDetails.recommendation.resourceId.videoId - The ID that YouTube uses to uniquely identify the video, if the recommended resource is a video.
#'   * contentDetails.recommendation.resourceId.channelId - The ID that YouTube uses to uniquely identify the channel, if the recommended resource is a channel.
#'   * contentDetails.recommendation.reason - The reason that the resource is recommended to the user.
#'   * contentDetails.recommendation.seedResourceId - The seedResourceId object contains information about the resource that caused the recommendation.
#'   * contentDetails.recommendation.seedResourceId.kind - The type of the API resource.
#'   * contentDetails.recommendation.seedResourceId.videoId - The ID that YouTube uses to uniquely identify the video, if the recommendation was caused by a particular video.
#'   * contentDetails.recommendation.seedResourceId.channelId - The ID that YouTube uses to uniquely identify the channel, if the recommendation was caused by a particular channel.
#'   * contentDetails.recommendation.seedResourceId.playlistId - The ID that YouTube uses to uniquely identify the playlist, if the recommendation was caused by a particular playlist.
#'   * contentDetails.social - The social object contains details about a social network post.
#'   * contentDetails.social.type - The name of the social network.
#'   * contentDetails.social.resourceId - The resourceId object encapsulates information that identifies the resource associated with a social network post.
#'   * contentDetails.social.resourceId.kind - The type of the API resource.
#'   * contentDetails.social.resourceId.videoId - The ID that YouTube uses to uniquely identify the video featured in a social network post, if the post refers to a video.
#'   * contentDetails.social.resourceId.channelId - The ID that YouTube uses to uniquely identify the channel featured in a social network post, if the post refers to a channel. This property will only be present if the value of the social.
#'   * contentDetails.social.resourceId.playlistId - The ID that YouTube uses to uniquely identify the playlist featured in a social network post, if the post refers to a playlist.
#'   * contentDetails.social.author - The author of the social network post.
#'   * contentDetails.social.referenceUrl - The URL of the social network post.
#'   * contentDetails.social.imageUrl - An image of the post's author.
#'   * contentDetails.channelItem - The channelItem object contains details about a resource that was added to a channel.
#'   * contentDetails.channelItem.resourceId - The resourceId object contains information that identifies the resource that was added to the channel.
#'
#'
#' @examples
#' \dontrun{
#'
#' channel_activities <- ryt_get_channel_activities()
#'
#' }
ryt_get_channel_activities <- function(
    part = c('contentDetails',
             'id',
             'snippet'),
    fields = NULL
) {

  cli_alert_info('Compose params')

  q_params <- list(
    mine = TRUE,
    part = paste0(part, collapse = ","),
    fields = fields,
    maxResults = 50
  )

  result <- list()

  cli_alert_info('Send query')
  while (!is.null(q_params$pageToken)|!exists('resp', inherits = FALSE)) {

    out <- request_build(
      method   = "GET",
      params   = q_params,
      token    = ryt_token(),
      path     = 'youtube/v3/activities',
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


  result <- rename_with(result, to_snake_case)
  cli_alert_success(str_glue('Success, loading {nrow(result)} rows.'))
  return(result)

}
