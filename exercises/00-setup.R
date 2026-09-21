# Setup: run this first, before any exercise ----------------------------

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

