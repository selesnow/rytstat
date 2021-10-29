
# rytstat - R пакет для работы с YouTube API <a href='https://selesnow.github.io/rytstat/'><img src='https://github.com/selesnow/rytstat/raw/master/man/figures/logo.png' align="right" height="138.5" /></a>

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/rytstat)](https://CRAN.R-project.org/package=rytstat)
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/selesnow/rytstat/workflows/R-CMD-check/badge.svg)](https://github.com/selesnow/rytstat/actions)
<!-- badges: end -->

Пакет `rytstat` предназначен для работы с YouTube API, на данный момент поддерживает работу со следующими API интерфесами:

* [YouTube Reporting API](https://developers.google.com/youtube/reporting/v1/reports)
* [YouTube Analytics API](https://developers.google.com/youtube/analytics/data_model)
* [YouTube Data API](https://developers.google.com/youtube/v3/getting-started)

## Privacy Policy

The `rytstat` package for authorization uses the [gargle](https://gargle.r-lib.org/) package, the credentials obtained during authorization are stored exclusively on your local PC, you can find out the folder into which the credentials are cached using the `ryt_auth_cache_path()` function.

For loading data from your YouTube channel `rytstat` needs next scopes:

* View monetary and non-monetary YouTube Analytics reports for your YouTube content
* View your YouTube account
* View and manage your assets and associated content on YouTube
* View YouTube Analytics reports for your YouTube content
* Manage your YouTube account

For more details see [Official YouTube API documentation](https://developers.google.com/youtube/reporting/guides/authorization#identify-access-scopes).

The package does not transfer your credentials or data obtained from your advertising accounts to third parties, however, the responsibility for information leakage remains on the side of the package user. The author does not bear any responsibility for their safety, be careful when transferring cached credentials to third parties.

For more details, I recommend that you read the following articles from the official documentation of the gargle package:

* [Stewarding the cache of user tokens](https://www.tidyverse.org/blog/2021/07/gargle-1-2-0/)
* [Auth when using R in the browser](https://cran.r-project.org/package=gargle/vignettes/auth-from-web.html)
* [How gargle gets tokens](https://cran.r-project.org/package=gargle/vignettes/how-gargle-gets-tokens.html)

### Authorization process

You run `gads_auth('me@gmail.com')` and start [OAuth Dance](https://medium.com/typeforms-engineering-blog/the-beginners-guide-to-oauth-dancing-4b8f3666de10) in the browser:

![Typical OAuth dance in the browser, when initiated from within R](https://raw.githubusercontent.com/selesnow/rytstat/master/man/figures/auth_process.png)

Upon success, you see this message in the browser:

`Authentication complete. Please close this page and return to R.`

And you credentials cached locally on your PC in the form of RDS files.

### Key points
* By default, gargle caches user tokens centrally, at the user level, and their keys or labels also convey which Google identity is associated with each token.
* Token storage relies on serialized R objects. That is, tokens are stored locally on your PC in the form of RDS files.

### Use own OAuth client
You can use own OAuth app:

```r
app <- httr::oauth_app(appname = "app name", key = "app id", secret = "app secret")
ryt_auth_configure(app = app)

# or from json file 
ryt_auth_configure(path = 'D:/ga_auth/app.json')

# run authorization
ryt_auth('me@gmail.com')
```

## Установка

Вы можете установить пакет `rytstat` из [CRAN](https://CRAN.R-project.org):

``` r
install.packages("rytstat")
```

или GitHub:

```r
devtools::install_github('selesnow/rytstat')
```

## Авторизация

Для работы с API YouTube вам необходимо создать OAuth клиент в [Google Console](https://console.cloud.google.com/), и включить все связанные с YouTube API.

![](http://img.netpeak.ua/alsey/53WIMY.png)

Далее для прохождения авторизации используйте приведённый ниже пример:

```r
library(rytstat)
library(httr)

# авторизация
app <- oauth_app(
    appname = 'my app',
    key = 'ключ вашего приложения', 
    secret = 'секрет вашего приложения')

ryt_auth_configure(app = app)

ryt_auth(email = 'me@gmail.com')

# запрос списка видео
videos <- ryt_get_video_list()

```

## Пример запроса данных из YouTube Analytics API


``` r
library(rytstat)

# список видео
videos <- ryt_get_video_list()

# функция для запроса статистики по конкретному видео
get_videos_stat <- function(video_id) {

data <- ryt_get_analytics(
  metrics = c('views', 'likes', 'dislikes', 'comments', 'shares'),
  filters = str_glue('video=={video_id}')
)

 if ( nrow(data) > 0 ) {
      data <- mutate(data, video_id = video_id)
    }
}

# применяем функцию к каждому видео
video_stat <- purrr::map_df(videos$id_video_id, get_videos_stat)

# объединяем статистику с данными о видео
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
```

## Пример запроса данных из YouTube Reporting API

```r
# auth
ryt_auth('me@gmail.com')

# get reporting data
## create job
ryt_reports_create_job('channel_basic_a2')

## get job list
jobs2 <- ryt_reports_get_job_list()

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
```

## Автор
Alexey Seleznev, Head of analytics dept. at [Netpeak](https://netpeak.net)
<Br>Telegram Channel: @R4marketing
<Br>email: selesnow@gmail.com
<Br>facebook: [facebook.com/selesnow](https://www.facebook.com/selesnow)
<Br>blog: [alexeyseleznev.wordpress.com](https://alexeyseleznev.wordpress.com/)
