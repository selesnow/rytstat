library(gargle)
library(httr)
library(tidyr)
library(rlang)

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
  #path     = str_glue('{options("gads.api.version")}/customers/{customer_id}/googleAds:searchStream'),
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
https://developers.google.com/youtube/analytics/reference/reports/query
https://developers.google.com/youtube/analytics/metrics
