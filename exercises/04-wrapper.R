# Exercise 4: tbl_pharma_summary()
#
# Run `00-setup.R` first.

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
