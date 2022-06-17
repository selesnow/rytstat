#' Get detail data of your videos on 'YouTube'
#'
#' @param video_id Video ID, see \code{\link{ryt_get_videos}}.
#' @param part The parameter identifies one or more top-level (non-nested) resource properties that should be included in an API response. Posible values: snippet, contentDetails, fileDetails, player, processingDetails, recordingDetails, statistics, status, suggestions, topicDetails.See \href{https://developers.google.com/youtube/v3/docs/videos/list}{API documentation}.
#' @param fields Fields of video metadata, see \href{https://developers.google.com/youtube/v3/docs/videos/list}{API documentation}.
#' @param cl A cluster object created by \code{\link{makeCluster}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations (see Details on performance).
#'
#' @details For get more information about videos parts and fields go \href{this link}{https://developers.google.com/youtube/v3/docs/videos#properties}
#' *Properties:*
#' * kind - Identifies the API resource's type. The value will be youtube#video.
#' * etag - The Etag of this resource.
#' * id - The ID that YouTube uses to uniquely identify the video.
#' * snippet - The snippet object contains basic details about the video, such as its title, description, and category.
#'   * snippet/publishedAt - The date and time that the video was published. Note that this time might be different than the time that the video was uploaded.
#'   * snippet/channelId - The ID that YouTube uses to uniquely identify the channel that the video was uploaded to.
#'   * snippet/title - The video's title.
#'   * snippet/description - The video's description.
#'   * snippet/thumbnails - A map of thumbnail images associated with the video.
#'   * snippet/thumbnails/(key) - Valid key values are: default, medium, high, standard, maxres
#'   * snippet/thumbnails/(key)/url - The image's URL.
#'   * snippet/thumbnails/(key)/width - The image's width.
#'   * snippet/thumbnails/(key)/height - The image's height.
#'   * snippet/channelTitle - Channel title for the channel that the video belongs to.
#'   * snippet/tags[] - A list of keyword tags associated with the video.
#'   * snippet/categoryId - The YouTube video category associated with the video.
#'   * snippet/liveBroadcastContent - Indicates if the video is an upcoming/active live broadcast.
#'   * snippet/defaultLanguage - The language of the text in the video resource's snippet.title and snippet.description properties.
#'   * snippet/localized - The snippet.localized object contains either a localized title and description for the video or the title in the default language for the video's metadata.
#'   * snippet/localized/title - The localized video title.
#'   * snippet/localized/description - The localized video description.
#'   * snippet/defaultAudioLanguage - The default_audio_language property specifies the language spoken in the video's default audio track.
#' * contentDetails - The contentDetails object contains information about the video content, including the length of the video and an indication of whether captions are available for the video.
#'   * contentDetails/duration - The length of the video.
#'   * contentDetails/dimension - Indicates whether the video is available in 3D or in 2D.
#'   * contentDetails/definition - Indicates whether the video is available in high definition (HD) or only in standard definition.
#'   * contentDetails/caption - Indicates whether captions are available for the video.
#'   * contentDetails/licensedContent - Indicates whether the video represents licensed content, which means that the content was uploaded to a channel linked to a YouTube content partner and then claimed by that partner.
#'   * contentDetails/regionRestriction - The regionRestriction object contains information about the countries where a video is (or is not) viewable.
#'   * contentDetails/regionRestriction/allowed[] - A list of region codes that identify countries where the video is viewable.
#'   * contentDetails/regionRestriction/blocked[] - A list of region codes that identify countries where the video is blocked.
#'   * contentDetails/contentRating - Specifies the ratings that the video received under various rating schemes.
#'   * contentDetails/contentRating/acbRating - The video's Australian Classification Board (ACB) or Australian Communications and Media Authority (ACMA) rating. ACMA ratings are used to classify children's television programming.
#'   * contentDetails/contentRating/agcomRating - The video's rating from Italy's Autorità per le Garanzie nelle Comunicazioni (AGCOM).
#'   * contentDetails/contentRating/anatelRating - The video's Anatel (Asociación Nacional de Televisión) rating for Chilean television.
#'   * contentDetails/contentRating/bbfcRating - The video's British Board of Film Classification (BBFC) rating.
#'   * contentDetails/contentRating/bfvcRating - The video's rating from Thailand's Board of Film and Video Censors.
#'   * contentDetails/contentRating/bmukkRating - The video's rating from the Austrian Board of Media Classification.
#'   * contentDetails/contentRating/catvRating - Rating system for Canadian TV - Canadian TV Classification System The video's rating from the Canadian Radio-Television and Telecommunications Commission (CRTC) for Canadian English-language broadcasts.
#'   * contentDetails/contentRating/catvfrRating - The video's rating from the Canadian Radio-Television and Telecommunications Commission (CRTC) for Canadian French-language broadcasts.
#'   * contentDetails/contentRating/cbfcRating - The video's Central Board of Film Certification (CBFC - India) rating.
#'   * contentDetails/projection - Specifies the projection format of the video.
#'   * contentDetails/hasCustomThumbnail - Indicates whether the video uploader has provided a custom thumbnail image for the video. This property is only visible to the video uploader.
#' * status - The status object contains information about the video's uploading, processing, and privacy statuses.
#'   * status/uploadStatus - The status of the uploaded video.
#'   * status/failureReason - This value explains why a video failed to upload. This property is only present if the uploadStatus property indicates that the upload failed.
#'   * status/rejectionReason - This value explains why YouTube rejected an uploaded video.
#'   * status/privacyStatus - The video's privacy status.
#'   * status/publishAt - The date and time when the video is scheduled to publish. It can be set only if the privacy status of the video is private.
#'   * status/license - The video's license.
#'   * status/embeddable - This value indicates whether the video can be embedded on another website.
#'   * status/publicStatsViewable - This value indicates whether the extended video statistics on the video's watch page are publicly viewable.
#'   * status/madeForKids - This value indicates whether the video is designated as child-directed, and it contains the current "made for kids" status of the video.
#'   * status/selfDeclaredMadeForKids - In a videos.insert or videos.update request, this property allows the channel owner to designate the video as being child-directed.
#' * statistics - The statistics object contains statistics about the video.
#'   * statistics/viewCount - The number of times the video has been viewed.
#'   * statistics/likeCount - The number of users who have indicated that they liked the video.
#'   * statistics/dislikeCount - The number of users who have indicated that they disliked the video.
#'   * statistics/commentCount - The number of comments for the video.
#' * player - The player object contains information that you would use to play the video in an embedded player.
#'   * player/embedHtml - An <iframe> tag that embeds a player that plays the video.
#'   * player/embedHeight - The height of the embedded player returned in the player.embedHtml property.
#'   * player/embedWidth - The width of the embedded player returned in the player.embedHtml property.
#' * topicDetails - The topicDetails object encapsulates information about topics associated with the video.
#'   * topicDetails/relevantTopicIds[] - A list of topic IDs that are relevant to the video.
#'   * topicDetails/topicCategories[] - A list of Wikipedia URLs that provide a high-level description of the video's content.
#' * recordingDetails - The recordingDetails object encapsulates information about the location, date and address where the video was recorded.
#'   * recordingDetails/location - The geolocation information associated with the video.
#'   * recordingDetails/recordingDate - The date and time when the video was recorded.
#' * fileDetails - The fileDetails object encapsulates information about the video file that was uploaded to YouTube, including the file's resolution, duration, audio and video codecs, stream bitrates, and more.
#'   * fileDetails/fileName - The uploaded file's name.
#'   * fileDetails/fileSize - The uploaded file's size in bytes.
#'   * fileDetails/fileType - The uploaded file's type as detected by YouTube's video processing engine.
#'   * fileDetails/container - The uploaded video file's container format.
#'   * fileDetails/videoStreams[] - A list of video streams contained in the uploaded video file.
#'   * fileDetails/videoStreams[]/widthPixels - The encoded video content's width in pixels.
#'   * fileDetails/videoStreams[]/heightPixels - The encoded video content's height in pixels.
#'   * fileDetails/videoStreams[]/frameRateFps - The video stream's frame rate, in frames per second.
#'   * fileDetails/videoStreams[]/aspectRatio - The video content's display aspect ratio, which specifies the aspect ratio in which the video should be displayed.
#'   * fileDetails/videoStreams[]/codec - The video codec that the stream uses.
#'   * fileDetails/videoStreams[]/bitrateBps - The video stream's bitrate, in bits per second.
#'   * fileDetails/videoStreams[]/rotation - The amount that YouTube needs to rotate the original source content to properly display the video.
#'   * fileDetails/videoStreams[]/vendor - A value that uniquely identifies a video vendor.
#'   * fileDetails/audioStreams[] - A list of audio streams contained in the uploaded video file.
#'   * fileDetails/audioStreams[]/channelCount - The number of audio channels that the stream contains.
#'   * fileDetails/audioStreams[]/codec - The audio codec that the stream uses.
#'   * fileDetails/audioStreams[]/bitrateBps - The audio stream's bitrate, in bits per second.
#'   * fileDetails/audioStreams[]/vendor - A value that uniquely identifies a video vendor.
#'   * fileDetails/durationMs - The length of the uploaded video in milliseconds.
#'   * fileDetails/bitrateBps - The uploaded video file's combined (video and audio) bitrate in bits per second.
#'   * fileDetails/creationTime - The date and time when the uploaded video file was created.
#' * processingDetails - The processingDetails object encapsulates information about YouTube's progress in processing the uploaded video file.
#'   * processingDetails/processingStatus - The video's processing status.
#'   * processingDetails/processingProgress - The processingProgress object contains information about the progress YouTube has made in processing the video.
#'   * processingDetails/processingProgress/partsTotal - An estimate of the total number of parts that need to be processed for the video.
#'   * processingDetails/processingProgress/partsProcessed - The number of parts of the video that YouTube has already processed.
#'   * processingDetails/processingProgress/timeLeftMs - An estimate of the amount of time, in millseconds, that YouTube needs to finish processing the video.
#'   * processingDetails/processingFailureReason - The reason that YouTube failed to process the video.
#'   * processingDetails/fileDetailsAvailability - This value indicates whether file details are available for the uploaded video.
#'   * processingDetails/processingIssuesAvailability - This value indicates whether the video processing engine has generated suggestions that might improve YouTube's ability to process the the video, warnings that explain video processing problems, or errors that cause video processing problems.
#'   * processingDetails/tagSuggestionsAvailability - This value indicates whether keyword (tag) suggestions are available for the video.
#'   * processingDetails/editorSuggestionsAvailability - This value indicates whether video editing suggestions, which might improve video quality or the playback experience, are available for the video.
#'   * processingDetails/thumbnailsAvailability - This value indicates whether thumbnail images have been generated for the video.
#' * suggestions - The suggestions object encapsulates suggestions that identify opportunities to improve the video quality or the metadata for the uploaded video.
#'   * suggestions/processingErrors[] - A list of errors that will prevent YouTube from successfully processing the uploaded video.
#'   * suggestions/processingWarnings[] - A list of reasons why YouTube may have difficulty transcoding the uploaded video or that might result in an erroneous transcoding.
#'   * suggestions/processingHints[] - A list of suggestions that may improve YouTube's ability to process the video.
#'   * suggestions/tagSuggestions[] - A list of keyword tags that could be added to the video's metadata to increase the likelihood that users will locate your video when searching or browsing on YouTube.
#'   * suggestions/tagSuggestions[]/tag - The keyword tag suggested for the video.
#'   * suggestions/tagSuggestions[].categoryRestricts[] - A set of video categories for which the tag is relevant.
#'   * suggestions/editorSuggestions[] - A list of video editing operations that might improve the video quality or playback experience of the uploaded video.
#' * liveStreamingDetails - The liveStreamingDetails object contains metadata about a live video broadcast.
#'   * liveStreamingDetails/actualStartTime - The time that the broadcast actually started.
#'   * liveStreamingDetails/actualEndTime - The time that the broadcast actually ended.
#'   * liveStreamingDetails/scheduledStartTime - The time that the broadcast is scheduled to begin.
#'   * liveStreamingDetails/scheduledEndTime - The time that the broadcast is scheduled to end.
#'   * liveStreamingDetails/concurrentViewers - The number of viewers currently watching the broadcast.
#'   * liveStreamingDetails/activeLiveChatId - The ID of the currently active live chat attached to this video.
#' * localizations - The localizations object contains translations of the video's metadata.
#'   * localizations/(key) - The language of the localized text associated with the key value.
#'   * localizations/(key).title - The localized video title.
#'   * localizations/(key).description - The localized video description.
#'
#' @return tibble with video details
#' @export
#' @examples
#' \dontrun{
#' # get all videos
#' videos <- ryt_get_videos()
#'
#' # get all videos metadata
#' videos_details <- ryt_get_video_details(
#'     video_id = videos$id_video_id
#' )
#'
#' # get only snippet and statistics part
#' videos_details <- ryt_get_video_details(
#'     video_id = videos$id_video_id,
#'     part = c('snippet', 'statistics')
#' )
#'
#' # get only id, channelId, title and view_count fields
#' videos_details <- ryt_get_video_details(
#'     video_id = videos$id_video_id,
#'     part = c('snippet', 'statistics'),
#'     fields = "items(id,snippet(channelId,title),statistics(viewCount))"
#' )
#'
#' # same with other fields syntax like part/field
#' # get only id, channelId, title and view_count fields
#' videos_details <- ryt_get_video_details(
#'     video_id = videos$id_video_id,
#'     part = c('snippet', 'statistics'),
#'     fields = "items(id,snippet/channelId,snippet/title,statistics/viewCount)"
#' )
#' }
ryt_get_video_details <- function(
  video_id,
  part   = c('contentDetails',
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
             'topicDetails'),
  fields = NULL,
  cl = NULL
) {

  # split by 50 videos
  x <- seq_along(video_id)
  video_id <- split(video_id, ceiling(x/50))
  video_id <- lapply(video_id, paste0, collapse = ',')

  res <- pblapply(
          video_id,
          ryt_get_video_details_helper,
          part = part,
          fields = fields,
          cl = cl
          )

  res <- bind_rows(res) %>%
         rename_with(to_snake_case)

  return(res)

}
