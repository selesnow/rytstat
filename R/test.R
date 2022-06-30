
if (FALSE) {
  library(gargle)
  library(httr)
  library(tidyr)
  library(dplyr)
  library(rlang)
  library(snakecase)
  library(cli)
  library(stringr)

  library(rytstat)
  library(httr)

  # OAuth клиент
  app <- oauth_app(
    'my app',
    key = '321452169616-jnrn2ja27503ijs2qs52rckk5ie2er3m.apps.googleusercontent.com',
    secret = '9-fe5feYYQtQaarQv9xoL3B0'
  )
  # Конфигурация авторизации
  ryt_auth_configure(app = app)
  # Авторизация
  ryt_auth(email = 'r4marketing-6832@pages.plusgoogle.com')
  channel <- ryt_get_channels()
  ryt_open_auth_cache_folder()
  ryt_auth(email = 'selesnow@gmail.com')
  videos <- ryt_get_videos()

  video_details <- ryt_get_video_details(video_id = videos$id_video_id)

  analytics_data <- ryt_get_analytics(filters = 'video==sCp2D6068es')

  pl <- ryt_get_playlists()

  # auth
  ryt_auth('selesnow@gmail.com')

  # get list of your videos
  videos <- ryt_get_videos()

  # search
  search_res_videos <- ryt_search(
        type            = 'video',
        q               = 'r language tutorial',
        published_after = '2022-03-01T00:00:00Z',
        published_before = '2022-06-01T00:00:00Z',
        max_results     = 10
    )

  search_res_playlists <- ryt_search(
    type             = 'playlist',
    q                = 'r language tutorial',
    published_after  = '2022-03-01T00:00:00Z',
    published_before = '2022-06-01T00:00:00Z',
    max_results      = 50
  )

  search_res_channels <- ryt_search(
    type             = 'channel',
    q                = 'r language tutorial',
    published_after  = '2022-03-01T00:00:00Z',
    published_before = '2022-06-01T00:00:00Z',
    max_results      = 50
  )

  search_my_videos <- ryt_search(
    type             = 'video',
    for_mine         = TRUE,
    max_results      = 50
  )

  search_own_dplyr_videos <- ryt_search(
    type             = 'video',
    for_mine         = TRUE,
    q                = 'dplyr'
  )

  # search channel id by name
  search_chn <-  ryt_search(
    type   = 'channel',
    q      = 'R4marketing',
    fields = 'items(snippet(title,channelId))'
  )

  # Search videos in the channel
  search_channel_dplyr_videos <- ryt_search(
    type       = 'video',
    q          = 'dplyr',
    channel_id = "UCyHC6R3mCCP8bhD9tPbjnzQ"
  )


ryt_get_channels()$id
  # function for loading video stat
  get_videos_stat <- function(video_id) {

    data <- ryt_get_analytics(
      metrics = c('views', 'likes', 'dislikes', 'comments', 'shares'),
      filters = str_glue('video=={video_id}')
    )

    if ( nrow(data) > 0 ) {
      data <- mutate(data, video_id = video_id)
    }
  }

  # load video stat
  video_stat <- purrr::map_df(videos$id_video_id, get_videos_stat)

  # join stat with video metadata
  video_stat <- left_join(video_stat,
                          videos,
                          by = c("video_id" = "id_video_id")) %>%
                select(video_id,
                       title,
                       day,
                       views,
                       likes,
                       dislikes,
                       comments,
                       shares)

  # auth
  ryt_auth('me@gmail.com')

  # get reporting data
  ## create job
  ryt_reports_create_job('channel_basic_a2')

  ## get job list
  jobs2 <- ryt_get_job_list()

  ## get job report list
  reports <- ryt_reports_get_report_list(
    job_id = jobs$id[1],
    created_after = '2021-10-20T15:01:23.045678Z'
  )

  # get report data
  data <- ryt_get_report(
    download_url = reports$downloadUrl[1]
  )

  # delete job
  ryt_reports_delete_job(jobs$id[1])


  pblapply(videos$id_video_id[1:5],
           function(x) ryt_get_analytics(filters = str_glue('video=={x}')))

  temp <- lapply(videos$id_video_id[1:5],
         function(x) ryt_get_analytics(filters = str_glue('video=={x}')))


  app <- oauth_app(
    'ryoutube',
    key    = '321452169616-9i7uup8nkrtv26ra87q53hkokbuum071.apps.googleusercontent.com',
    secret = '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'
  )

  cred <- gargle::token_fetch(
    scopes  = c('https://www.googleapis.com/auth/youtube',
                'https://www.googleapis.com/auth/youtube.readonly',
                'https://www.googleapis.com/auth/youtubepartner',
                'https://www.googleapis.com/auth/yt-analytics-monetary.readonly',
                'https://www.googleapis.com/auth/yt-analytics.readonly'),
    app     = app,
    email   = 'selesnow@gmail.com',
    path    = NULL,
    package = "ryoutube",
    cache   = gargle::gargle_oauth_cache(),
    use_oob = gargle::gargle_oob_default(),
    token   = NULL
  )

  # analytics
  {
  out <- request_build(
    method   = "GET",
    params   = list(startDate = '2021-10-01',
                    endDate = '2021-10-15',
                    ids = 'channel==UCyHC6R3mCCP8bhD9tPbjnzQ',
                    dimensions = 'day',
                    filters = 'video==zJyDxd4JGg0',
                    metrics = 'views,likes'),
    token    = cred,
    path = 'v2/reports',
    base_url = 'https://youtubeanalytics.googleapis.com/'
  )

  # send request
  ans <- request_retry(
    out,
    encode = 'json'
  )

  resp <- response_process(ans)

  data <- tibble(response = resp$rows) %>%
          unnest_wider(response)

  headers <- tibble(response = resp$columnHeaders) %>%
             unnest_wider(response)

  data <- setNames(data, headers$name)
  }




  # data
  {
    #https://developers.google.com/youtube/v3/docs/search/list

    out <- request_build(
      method   = "GET",
      params   = list(
                    part = "id",
                    forMine = TRUE,
                    type = 'video',
                    maxResults = 50,
                    pageToken = resp$nextPageToken),
      token    = cred,
      path     = 'youtube/v3/search',
      base_url = 'https://www.googleapis.com/'
    )

    # send request
    ans <- request_retry(
      out,
      encode = 'json'
    )

    resp <- response_process(ans)

    resp$nextPageToken


    #res <- list()
    res <- append(res, list(resp))



    data <- tibble(response = resp$items) %>%
            #unnest_longer(response)
            unnest_wider(response) %>%
            unnest_wider(id, names_sep = '_')

    headers <- tibble(response = resp$columnHeaders) %>%
      unnest_wider(response)

    data <- setNames(data, headers$name)

  }




  # документация
  # https://developers.google.com/youtube/analytics/reference/reports/query
  # https://developers.google.com/youtube/analytics/metrics
  # https://developers.google.com/youtube/reporting
}
