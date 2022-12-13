#' A data set with estimates of native speakers for 27 languages.
#'
#' A long-form data set scraped from wikipedia containing an approximate number
#' of native speakers for 27 of the world's languages. The data set also
#' contains information regarding the language family, language branch, and
#' other notes. The table was scraped from:
#' https://en.wikipedia.org/wiki/List_of_languages_by_number_of_native_speakers
#'
#' @format A data frame with 27 rows and 5 columns:
#' \describe{
#'   \item{language}{Language name in English}
#'   \item{native_speakers_millions}{Approximate number of native speakers (in millions)}
#'   \item{language_family}{Language family}
#'   \item{branch}{Language branch}
#'   \item{notes}{Misc. notes about the language}
#' }
#' @source \url{https://github.com/jvcasillas/worldlanguages}
"native_speakers"
