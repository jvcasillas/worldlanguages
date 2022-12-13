#' A data set containing a information on 642 extinct languages.
#'
#' A long-form data set scraped from wikipedia containing an information about
#' 642 extinct languages. Information on the data, language family, region,
#' and terminal speakers is provided if available. The table curated by scraping
#' multiple tables from:
#' https://en.wikipedia.org/wiki/List_of_languages_by_time_of_extinction
#'
#' @format A data frame with 642 rows and 7 columns:
#' \describe{
#'   \item{language}{Name of the language (in English)}
#'   \item{date}{Approximate date when the language went extinct}
#'   \item{century}{Century in which the language went extinct}
#'   \item{language_family}{Family of the language}
#'   \item{region}{The region where the language was spoken}
#'   \item{terminal_speaker}{Information about the terminal speaker, if available}
#'   \item{notes}{Misc. notes}
#' }
#' @source \url{https://github.com/jvcasillas/worldlanguages}
"extinct_languages"
