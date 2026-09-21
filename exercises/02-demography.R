# Exercise 2: a demography table with {gtsummary}
#
# Run `00-setup.R` first.

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

