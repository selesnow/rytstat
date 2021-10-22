.onLoad <- function(libname, pkgname) {

  # auth object
  .auth <<- gargle::init_AuthState(
    package     = "rgoogleads",
    auth_active = TRUE
  )

  # auth object
  # this is to insure we get an instance of gargle's AuthState using the
  # current, locally installed version of gargle
  assign(
    ".auth",
    gargle::init_AuthState(package = "ryoutube", auth_active = TRUE),
    environment(.onLoad)
  )

  # where function
  utils::globalVariables("where")

  if ( Sys.getenv("RYT_EMAIL") != "" ) {

    ryt_email <- Sys.getenv("RYT_EMAIL")
    cli_alert_info('Set email from environt variables')

  } else {

    ryt_email <- NULL

  }

  # options
  op <- options()
  op.gads <- list(gargle_oauth_email = ryt_email)

  toset <- !(names(op.gads) %in% names(op))
  if (any(toset)) options(op.gads[toset])

  invisible()
}

.onAttach <- function(lib, pkg,...){

  packageStartupMessage(ryoutubeWelcomeMessage())

}


ryoutubeWelcomeMessage <- function(){
  # library(utils)

  paste0("\n",
         "---------------------\n",
         "Welcome to ryoutube version ", utils::packageDescription("ryoutube")$Version, "\n",
         "\n",
         "Author:           Alexey Seleznev (Head of analytics dept at Netpeak).\n",
         "Telegram channel: https://t.me/R4marketing \n",
         "YouTube channel:  https://www.youtube.com/R4marketing/?sub_confirmation=1 \n",
         "Email:            selesnow@gmail.com\n",
         "Site:             https://selesnow.github.io \n",
         "Blog:             https://alexeyseleznev.wordpress.com \n",
         "Facebook:         https://facebook.com/selesnown \n",
         "Linkedin:         https://www.linkedin.com/in/selesnow \n",
         "\n",
         "Type ?ryoutube for the main documentation.\n",
         "The github page is: https://github.com/selesnow/ryoutube/\n",
         "Package site: https://selesnow.github.io/ryoutube/docs\n",
         "\n",
         "Suggestions and bug-reports can be submitted at: https://github.com/selesnow/ryoutube/issues\n",
         "Or contact: <selesnow@gmail.com>\n",
         "\n",
         "\tTo suppress this message use:  ", "suppressPackageStartupMessages(library(ryoutube))\n",
         "---------------------\n"
  )
}
