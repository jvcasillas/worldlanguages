# Load libraries --------------------------------------------------------------

library("tidyverse")
library("rvest")
library("janitor")
library("stringr")
library("here")
library("glue")

# -----------------------------------------------------------------------------




# Languages by total # of speakers --------------------------------------------

url_lxts <- "https://en.wikipedia.org/wiki/List_of_languages_by_total_number_of_speakers"

total_speakers <- url_lxts %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div[1]/table[2]') %>%
  html_table() %>%
  bind_rows() %>%
  clean_names() %>%
  separate(
    col = language,
    into = c("language", "notes"),
    sep = "\\(",
    fill = "right"
  ) %>%
  mutate(notes = str_remove_all(notes, "\\)")) %>%
  mutate(across(everything(), str_remove_all, pattern = "—")) %>%
  mutate(
    across(
      .cols = everything(),
      str_remove_all,
      pattern = "\\[[a-z]\\]|\\[[0-9][0-9]\\]|\\[[0-9]\\]"
    )
  ) %>%
  mutate(across(everything(), na_if, y = "")) %>%
  separate(
    col = first_language_l1_speakers,
    into = c("l1_speakers", "l1_mag"),
    sep = " ",
    fill = "right") %>%
  mutate(l1_speakers = as.numeric(l1_speakers)) %>%
  mutate(l1_speakers = case_when(
    l1_mag == "million" ~ l1_speakers * 1000000,
    l1_mag == "billion" ~ l1_speakers * 1000000000,
    TRUE ~ .$l1_speakers)
  ) %>%
  separate(
    col = second_language_l2_speakers,
    into = c("l2_speakers", "l2_mag"),
    sep = " ",
    fill = "right") %>%
  mutate(l2_speakers = as.numeric(l2_speakers)) %>%
  mutate(l2_speakers = case_when(
    l2_mag == "million" ~ l2_speakers * 1000000,
    l2_mag == "billion" ~ l2_speakers * 1000000000,
    TRUE ~ .$l2_speakers)
  ) %>%
  separate(
    col = total_speakers_l1_l2,
    into = c("total_speakers", "total_mag"),
    sep = " ",
    fill = "right") %>%
  mutate(total_speakers = as.numeric(total_speakers)) %>%
  mutate(total_speakers = case_when(
    total_mag == "million" ~ total_speakers * 1000000,
    total_mag == "billion" ~ total_speakers * 1000000000,
    TRUE ~ .$total_speakers)
  ) %>%
  select(language, family, branch, !contains("mag"), notes) %>%
  write_csv(here("data-raw", glue("total_speakers_{Sys.Date()}.csv")))

usethis::use_data(total_speakers, overwrite = TRUE)

# -----------------------------------------------------------------------------




# Languages by # of native speakers -------------------------------------------

url_lxns <- "https://en.wikipedia.org/wiki/List_of_languages_by_number_of_native_speakers"

native_speakers <- url_lxns %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div[1]/table[1]') %>%
  html_table() %>%
  bind_rows() %>%
  clean_names() %>%
  separate(
    col = language,
    into = c("language", "notes"),
    sep = "\\(",
    fill = "right"
  ) %>%
  mutate(notes = str_remove_all(notes, "\\)")) %>%
  select(language, native_speakers_millions:branch, notes) %>%
  write_csv(here("data-raw", glue("native_speakers_{Sys.Date()}.csv")))

usethis::use_data(native_speakers, overwrite = TRUE)

# -----------------------------------------------------------------------------




# Languages by # of countries -------------------------------------------------

url_lxnc <- "https://en.wikipedia.org/wiki/List_of_languages_by_the_number_of_countries_in_which_they_are_recognized_as_an_official_language"

n_countries_by_language <- url_lxnc %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div[1]/table[3]') %>%
  html_table() %>%
  bind_rows() %>%
  clean_names() %>%
  mutate(across(world:oceania, str_remove_all, pattern = "\\*")) %>%
  mutate(across(world:oceania, na_if, y = "-")) %>%
  mutate(across(world:oceania, replace_na, replace = "0")) %>%
  mutate(across(world:oceania, str_remove_all, pattern = "[0-9]+-")) %>%
  mutate(across(world:oceania, as.numeric)) %>%
  write_csv(here("data-raw", glue("n_countries_by_language_{Sys.Date()}.csv")))

usethis::use_data(n_countries_by_language, overwrite = TRUE)

# -----------------------------------------------------------------------------




# N of languages by country ---------------------------------------------------

url_nlxc <- "https://en.wikipedia.org/wiki/Number_of_languages_by_country"

# nol_percent refers to the percentage of total number of languages in the
# world, including both established and immigrant languages.

n_languages_by_country <- url_nlxc %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div[1]/table') %>%
  html_table() %>%
  bind_rows() %>%
  row_to_names(row_number = 1) %>%
  clean_names() %>%
  rename(
    country = country_or_territory,
    nol_established = established,
    nol_immigrant = immigrant,
    nol_total = total,
    nol_percent = percent_note_1,
    nos_total = total_2,
    nos_mean = mean,
    nos_median = median
  ) %>%
  mutate(
    country = if_else(
      condition = country == "China (mainland only)",
      true = "China",
      false = .$country
    )
  ) %>%
  mutate(across(nol_established:nos_median, str_remove_all, pattern = ",")) %>%
  mutate(across(-country, as.numeric)) %>%
  write_csv(here("data-raw", glue("n_languages_by_country_{Sys.Date()}.csv")))

usethis::use_data(n_languages_by_country, overwrite = TRUE)

# -----------------------------------------------------------------------------




# Languages by n words (in dictionary) ----------------------------------------

url_lxnw <- "https://en.wikipedia.org/wiki/List_of_dictionaries_by_number_of_words"

n_words_by_language <- url_lxnw %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div[1]/table') %>%
  html_table() %>%
  bind_rows() %>%
  clean_names() %>%
  select(language, n_headwords = approx_no_of_headwords_3,
         n_definitions = approx_no_of_definitions, dictionary, notes) %>%
  mutate(n_definitions = str_remove_all(n_definitions, ","),
         n_definitions = as.integer(n_definitions)) %>%
  write_csv(here("data-raw", glue("n_words_by_language_{Sys.Date()}.csv")))

usethis::use_data(n_words_by_language, overwrite = TRUE)

# -----------------------------------------------------------------------------




# Extinct languages -----------------------------------------------------------

url_extl <- "https://en.wikipedia.org/wiki/List_of_languages_by_time_of_extinction"

extl_list <- list()

for (tab in 2:30) {
  path <- paste0('//*[@id="mw-content-text"]/div[1]/table[', tab, ']')

  extl_list[[tab]] <- url_extl %>%
    read_html() %>%
    html_nodes(xpath = path) %>%
    html_table() %>%
    bind_rows() %>%
    clean_names() %>%
    mutate(century_order = tab)
}

extinct_languages <- bind_rows(extl_list) %>%
  mutate(language_name = case_when(
    is.na(language) ~ languageor_dialect,
    is.na(languageor_dialect) ~ language),
    century = case_when(
      century_order == 2 ~ "21st",
      century_order == 3 ~ "20th",
      century_order == 4 ~ "19th",
      century_order == 5 ~ "18th",
      century_order == 6 ~ "17th",
      century_order == 7 ~ "16th",
      century_order == 8 ~ "15th",
      century_order == 9 ~ "14th",
      century_order == 10 ~ "13th",
      century_order == 11 ~ "11th and 12th",
      century_order == 12 ~ "10th",
      century_order == 13 ~ "9th",
      century_order == 14 ~ "8th",
      century_order == 15 ~ "7th",
      century_order == 16 ~ "6th",
      century_order == 17 ~ "5th",
      century_order == 18 ~ "4th",
      century_order == 19 ~ "3rd",
      century_order == 20 ~ "2nd",
      century_order == 21 ~ "1st",
      century_order == 22 ~ "1st BC",
      century_order == 23 ~ "2nd BC",
      century_order == 24 ~ "3rd BC",
      century_order == 25 ~ "4th BC",
      century_order == 26 ~ "5th BC",
      century_order == 27 ~ "6th BC",
      century_order == 28 ~ "7th BC",
      century_order == 29 ~ "2nd mill. BC",
      century_order == 30 ~ "Unknown")
  ) %>%
  select(
    language = language_name,
    date, century, language_family:notes
  ) %>%
  write_csv(here("data-raw", glue("extinct_languages_{Sys.Date()}.csv")))

usethis::use_data(extinct_languages, overwrite = TRUE)

# -----------------------------------------------------------------------------




# List of known language names ------------------------------------------------

url_ll <- "https://en.wikipedia.org/wiki/List_of_language_names"

remove1 <- "Note: Georgia but there is a dispute with Russia and Georgia with North Ossetia and South Ossetia is wanting independence."
remove2 <- "† = Extinct dialect"
remove3 <- "† = Extinct alphabet or Script"

ll_elements <- url_ll %>%
  read_html() %>%
  html_elements("ul+ p , p+ ul li , h3+ p")

language_names <- ll_elements %>%
  html_text2() %>%
  as_tibble() %>%
  filter(!(value %in% c(remove1, remove2, remove3))) %>%
  mutate(is_lang = str_detect(value, "†|–")) %>%
  mutate(row = row_number()) %>%
  pivot_wider(names_from = is_lang, values_from = value) %>%
  fill(`TRUE`, .direction = "down") %>%
  fill(`FALSE`, .direction = "up") %>%
  transmute(language = `TRUE`, notes = `FALSE`) %>%
  distinct() %>%
  group_by(language) %>%
  summarize(notes_c = paste(notes, collapse = "; ")) %>%
  mutate(is_extinct = str_detect(language, "†")) %>%
  separate(col = language, into = c("language_en", "language"), sep = " –") %>%
  mutate(language_en = str_remove_all(language_en, " †"),
         language = str_remove(language, "^\\s")) %>%
  rename(notes = notes_c) %>%
  write_csv(here("data-raw", glue("language_names_{Sys.Date()}.csv")))

usethis::use_data(language_names, overwrite = TRUE)

# -----------------------------------------------------------------------------




# Languages by country --------------------------------------------------------

url_lxct <- "https://en.wikipedia.org/wiki/List_of_official_languages_by_country_and_territory"

languages_by_country <- url_lxct %>%
  read_html() %>%
  html_nodes(xpath = '//*[@id="mw-content-text"]/div[1]/table') %>%
  html_table() %>%
  bind_rows() %>%
  clean_names() %>%
  mutate(
    across(
      .cols = everything(),
      .fns = str_remove_all,
      pattern = "\\[[a-z]\\]|\\[[0-9][0-9]\\]|\\[[0-9]\\]"
    )
  ) %>%
  mutate(across(everything(), str_replace_all, "\\n", ", ")) %>%
  write_csv(here("data-raw", glue("languages_by_country_{Sys.Date()}.csv")))

usethis::use_data(languages_by_country, overwrite = TRUE)

# -----------------------------------------------------------------------------
