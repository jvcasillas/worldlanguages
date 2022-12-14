% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/language_names.R
\docType{data}
\name{language_names}
\alias{language_names}
\title{A data set containing information about 599 languages.}
\format{
A data frame with 599 rows and 4 columns:
\describe{
  \item{language_en}{Name of the language (in English)}
  \item{language}{Name of language (in native language, characters)}
  \item{notes}{Additional information regarding official status, where spoken/used, etc.}
  \item{is_extinct}{Logical vector (TRUE = extinct)}
}
}
\source{
\url{https://github.com/jvcasillas/worldlanguages}
}
\usage{
language_names
}
\description{
A long-form data set scraped from wikipedia containing an information about
599 languages. The data were scraped from:
https://en.wikipedia.org/wiki/List_of_language_names
}
\keyword{datasets}
