# Enterprise {gtsummary} — R/Pharma 2026
# Workshop exercises — solutions


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

# A. Calculate the number and percentage of *unique* subjects with at least
# one AE:
#  - By each SOC (AESOC)
#  - By each Preferred term (AEDECOD) within SOC (AESOC)
# By every combination of treatment group (ARM)

ard_stack_hierarchical(
  data = adae,
  variables = c(AESOC, AEDECOD),
  by = ARM,
  id = USUBJID,
  denominator = adsl
)

# B. [*BONUS*] Modify the code from part A to include overall number/percentage
# of subjects with at least one AE, regardless of SOC and PT

ard_stack_hierarchical(
  data = adae,
  variables = c(AESOC, AEDECOD),
  by = ARM,
  id = USUBJID,
  denominator = adsl,
  over_variables = TRUE
)


# Exercise 2: a demography table with {gtsummary} -------------------------

# A. Use tbl_summary() to summarize AGE, AGEGR1, SEX, RACE, ETHNIC, BMI,
# HEIGHT, WEIGHT by TRT01A

tbl <-
  df_gtsummary_exercise |>
  # ensure the age groups print in the correct order
  mutate(AGEGR1 = factor(AGEGR1, levels = c("18-64", ">64"))) |>
  tbl_summary(
    by = TRT01A,
    include = c(AGE, AGEGR1, SEX, RACE, ETHNIC, BMI, HEIGHT, WEIGHT),
    # all continuous variables should be summarized as multi-row
    type = all_continuous() ~ "continuous2",
    # change the statistics for all continuous variables
    statistic = all_continuous() ~ c("{mean} ({sd})", "{median} ({p25}, {p75})", "{min}, {max}"),
    label = list(AGEGR1 = "Age Group"), # add a label for AGEGR1
  )

tbl

# extract the ARD from the table
gather_ard(tbl)


# B. [*BONUS*] Add the header "**Active Treatment**" over the 'Xanomeline'
# treatments. We used `show_header_names()` to know the column names.

tbl |>
  modify_spanning_header(c(stat_2, stat_3) ~ "**Active Treatment**")


# Exercise 3: a theme for your organization -------------------------------

# A. Finish the theme below.

theme_gtsummary_rpharma <- function(set_theme = TRUE) {
  lst_theme <-
    utils::modifyList(
      # start from the shipped compact theme, then layer ours on top
      theme_gtsummary_compact(set_theme = FALSE),
      list(
        "pkgwide-str:theme_name"     = "R/Pharma 2026",
        "pkgwide-str:print_engine"   = "flextable",
        "tbl_summary-fn:percent_fun" = scales::label_number(scale = 100, accuracy = 0.1),
        "pkgwide-fn:pvalue_fun"      = label_style_pvalue(digits = 3)
      )
    )

  if (set_theme == TRUE) set_gtsummary_theme(lst_theme)
  invisible(lst_theme)
}

# B. Check the theme, then set it and build a table to see it applied.

check_gtsummary_theme(theme_gtsummary_rpharma(set_theme = FALSE))

theme_gtsummary_rpharma()

adsl |>
  tbl_summary(by = ARM2, include = c(AGE, ETHNIC)) |>
  add_p()

# C. Clear the theme again before moving on.

reset_gtsummary_theme()


# Exercise 4: tbl_pharma_summary() ----------------------------------------

# A. Finish the wrapper below.

tbl_pharma_summary <- function(
    data,
    by = NULL,
    type = NULL,
    statistic = list(
      all_continuous() ~ c("{mean} ({sd})", "{median}",
                           "{p25}, {p75}", "{min}, {max}"),
      all_categorical() ~ "{n} ({p}%)"
    ),
    ...) {
  with_gtsummary_theme(
    list("tbl_summary-str:default_con_type" = "continuous2"),
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

adsl |>
  tbl_pharma_summary(
    by = ARM2,
    include = c(AGE, ETHNIC)
  )

# C. [*BONUS*] Call it again, overriding `type` so the continuous variables
# print on a single line.

adsl |>
  tbl_pharma_summary(
    by = ARM2,
    include = AGE,
    type = all_continuous() ~ "continuous",
    statistic = all_continuous() ~ "{median} ({p25}, {p75})"
  )
