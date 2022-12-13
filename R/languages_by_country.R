#' A data set listing the languages spoken in 212 different countries.
#'
#' A long-form data set scraped from wikipedia containing a list of the languages
#' spoken in 212 different countries. The data set distinguishes between official,
#' regional, minority, and national status, as well as widely spoken languages.
#' The data were scraped from:
#' https://en.wikipedia.org/wiki/List_of_official_languages_by_country_and_territory
#'
#' @format A data frame with 212 rows and 6 columns:
#' \describe{
#'   \item{country_region}{The country (or region)}
#'   \item{official_language}{Character vector of official language(s)}
#'   \item{regional_language}{Character vector of regional language(s)}
#'   \item{minority_language}{Character vector of minority language(s)}
#'   \item{national_language}{Character vector of national language(s)}
#'   \item{widely_spoken}{Character vector of widely spoken language(s)}
#' }
#' @source \url{https://github.com/jvcasillas/worldlanguages}
"languages_by_country"
