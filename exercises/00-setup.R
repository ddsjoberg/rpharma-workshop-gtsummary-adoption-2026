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
