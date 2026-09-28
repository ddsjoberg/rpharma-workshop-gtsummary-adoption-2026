# Exercise 1: ARDs with {cards}
#
# Run `00-setup.R` first.

# A. Calculate the number and percentage of *unique* subjects with at least
# one AE:
#  - By each SOC (AESOC)
#  - By each Preferred term (AEDECOD) within SOC (AESOC)
# By every combination of treatment group (ARM)

ard_ae <-
  ard_stack_hierarchical(
    data = ,
    variables = ,
    by = ,
    id = ,
    denominator =
  )

ard_ae

# B. Using the ARD you just built, report the rate of subjects who
# experienced fatigue in each treatment group.
# HINT: `filter()` the ARD down to the rows you need, and
# `apply_fmt_fun()` formats the statistics for reporting
