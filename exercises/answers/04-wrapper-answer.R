# Exercise 4 solution: tbl_pharma_summary()
#
# Run `00-setup.R` first.

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
