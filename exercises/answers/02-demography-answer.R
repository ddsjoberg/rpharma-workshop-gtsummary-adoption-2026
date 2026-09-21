# Exercise 2 solution: a demography table with {gtsummary}
#
# Run `00-setup.R` first.

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

