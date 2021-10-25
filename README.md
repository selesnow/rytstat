
# ryoutube - R пакет для работы с YouTube API

<!-- badges: start -->
<!-- badges: end -->

Пакет `ryoutube` предназначен для работы с YouTube API, на данный момент поддерживает работу со следующими API интерфесами:

* [YouTube Reporting API](https://developers.google.com/youtube/reporting/v1/reports)
* [YouTube Analytics API](https://developers.google.com/youtube/analytics/data_model)
* [YouTube Data API](https://developers.google.com/youtube/v3/getting-started)

## Установка

Вы можете установить пакет `ryoutube` из [CRAN](https://CRAN.R-project.org):

``` r
install.packages("ryoutube")
```

или GitHub:

```r
devtools::install_github('selesnow/ryoutube')
```

## Авторизация

Для работы с API YouTube вам необходимо создать OAuth клиент в [Google Console](https://console.cloud.google.com/), и включить все связанные с YouTube API.

![](http://img.netpeak.ua/alsey/53WIMY.png)

Далее для прохождения авторизации используйте приведённый ниже пример:

```r
library(ryoutube)
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
library(ryoutube)

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

## Author
Alexey Seleznev, Head of analytics dept. at [Netpeak](https://netpeak.net)
<Br>Telegram Channel: [R4marketing](https://t.me/R4marketing)
<Br>email: selesnow@gmail.com
<Br>facebook: [facebook.com/selesnow](https://www.facebook.com/selesnow)
<Br>blog: [alexeyseleznev.wordpress.com](https://alexeyseleznev.wordpress.com/)
