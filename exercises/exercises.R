# Enterprise {gtsummary} — R/Pharma 2026
# Workshop exercises
#
# Four exercises, in the order they come up in the slides.
# Run the setup block first, then work through each exercise when prompted.


# Setup: run this first! --------------------------------------------------

library(cards)
library(gtsummary)
library(tidyverse)

adsl <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  mutate(ARM2 = word(ARM))

adae <- pharmaverseadam::adae |>
  filter(SAFFL == "Y") |>
  filter(AESOC %in% unique(AESOC)[1:3]) |>
  group_by(AESOC) |>
  filter(AEDECOD %in% unique(AEDECOD)[1:3]) |>
  ungroup()

df_gtsummary_exercise <- pharmaverseadam::adsl |>
  filter(SAFFL == "Y") |>
  left_join(
    pharmaverseadam::advs |>
      filter(PARAMCD %in% c("BMI", "HEIGHT", "WEIGHT"), !is.na(AVAL)) |>
      arrange(ADY) |>
      slice(1, .by = c(USUBJID, PARAMCD)) |>
      pivot_wider(id_cols = USUBJID, names_from = PARAMCD, values_from = AVAL),
    by = "USUBJID"
  ) |>
  select(USUBJID, TRT01A, AGE, AGEGR1, SEX, RACE, ETHNIC, BMI, HEIGHT, WEIGHT) |>
  labelled::set_variable_labels(
    BMI = "BMI",
    HEIGHT = "Height, cm",
    WEIGHT = "Weight, kg"
  )


# Exercise 1: ARDs with {cards} -------------------------------------------

# Calculate the number and percentage of *unique* subjects with at least
# one AE:
#  - By each SOC (AESOC)
#  - By each Preferred term (AEDECOD) within SOC (AESOC)
# By every combination of treatment group (ARM)

ard_stack_hierarchical(
  data = ,
  variables = ,
  by = ,
  id = ,
  denominator =
)



# Exercise 2: a demography table with {gtsummary} -------------------------

# A. Use tbl_summary() to summarize AGE, AGEGR1, SEX, RACE, ETHNIC, BMI,
# HEIGHT, WEIGHT by TRT01A
#  - For all continuous variables, present c("{mean} ({sd})",
#    "{median} ({p25}, {p75})", "{min}, {max}")
#  - Ensure the AGEGR1 levels are reported in the correct order
#  - View the ARD saved in the table using `gather_ard()`

tbl <-
  df_gtsummary_exercise |>
  mutate(AGEGR1 = factor()) |>
  tbl_summary(
    by = ,
    include = ,
    type = ,
    statistic = ,
    label =  # add a label for AGEGR1
  )

tbl

# extract the ARD from the table


# B. [*BONUS*] Add the header "**Active Treatment**" over the 'Xanomeline'
# treatments using `modify_spanning_header()`.
# HINT: `show_header_names()` tells you the column names


# Exercise 3: a theme for your organization -------------------------------

# A. Finish the theme below. It should:
#  - be named "R/Pharma 2026"
#  - print every table with {flextable}
#  - round percentages to one decimal place
#  - round p-values to three decimal places
# HINT: the element names are catalogued in the themes vignette,
# https://www.danieldsjoberg.com/gtsummary/articles/themes.html

theme_gtsummary_rpharma <- function(set_theme = TRUE) {
  lst_theme <-
    utils::modifyList(
      # start from the shipped compact theme, then layer ours on top
      theme_gtsummary_compact(set_theme = FALSE),
      list(
        "pkgwide-str:theme_name"     = ,
        "pkgwide-str:print_engine"   = ,
        "tbl_summary-fn:percent_fun" = ,
        "pkgwide-fn:pvalue_fun"      =
      )
    )

  if (set_theme == TRUE) set_gtsummary_theme(lst_theme)
  invisible(lst_theme)
}

# B. Check the theme, then set it and build a table to see it applied.

check_gtsummary_theme()

# C. Clear the theme again before moving on.

reset_gtsummary_theme()


# Exercise 4: tbl_pharma_summary() ----------------------------------------

# A. Finish the wrapper below. Continuous variables should default to
# multi-line summaries showing mean (sd), median, Q1/Q3 and min/max;
# categorical variables to n (%).
#
# Note `type` stays NULL, exactly as in tbl_summary() — the continuous2
# default comes from the theme element instead, so an explicit `type =`
# from the caller still wins.

tbl_pharma_summary <- function(
    data,
    by = NULL,
    type = NULL,
    # TODO: replace NULL with the default statistics described above
    statistic = NULL,
    ...) {
  with_gtsummary_theme(
    # TODO: the element that makes continuous variables multi-line
    list("tbl_summary-str:default_con_type" = ),
    tbl_summary(
      data = data,
      by = {{ by }},
      type = type,
      statistic = statistic,
      ...
    )
  )
}

# B. Use it to summarize AGE and ETHNIC in adsl by ARM2.


# C. [*BONUS*] Call it again, overriding `type` so the continuous variables
# print on a single line.
