#' A data set with total numbers of speakers for a variety of languages.
#'
#' A long-form data set scraped from wikipedia containing the number of L1 and
#' L2 speakers of 45 languages. The data set also contains information
#' regarding the language family, language branch, and other notes. The table
#' was scraped from:
#' https://en.wikipedia.org/wiki/List_of_languages_by_total_number_of_speakers
#'
#' @format A data frame with 45 rows and 7 columns:
#' \describe{
#'   \item{language}{Language name in English}
#'   \item{family}{Language family}
#'   \item{branch}{Language branch}
#'   \item{notes}{Misc. notes about the language}
#'   \item{l1_speakers}{Number of L1 speakers}
#'   \item{l2_speakers}{Number of L2 speakers}
#'   \item{total_speakers}{Total number of speakers (L1 + L2)}
#' }
#' @source \url{https://github.com/jvcasillas/worldlanguages}
"total_speakers"
