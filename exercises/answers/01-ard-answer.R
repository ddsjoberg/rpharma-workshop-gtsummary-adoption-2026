# Exercise 1 solution: ARDs with {cards}
#
# Run `00-setup.R` first.

# A. Calculate the number and percentage of *unique* subjects with at least
# one AE:
#  - By each SOC (AESOC)
#  - By each Preferred term (AEDECOD) within SOC (AESOC)
# By every combination of treatment group (ARM)

ard_ae <-
  ard_stack_hierarchical(
    data = adae,
    variables = c(AESOC, AEDECOD),
    by = ARM,
    id = USUBJID,
    denominator = adsl
  )

ard_ae

# B. Report the rate of subjects who experienced fatigue in each treatment
# group. We used `filter()` to keep the fatigue rows, and `apply_fmt_fun()`
# to format the statistics.

ard_ae |>
  filter(variable == "AEDECOD", variable_level == "FATIGUE") |>
  apply_fmt_fun()
