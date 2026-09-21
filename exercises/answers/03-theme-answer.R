# Exercise 3 solution: a theme for your organization
#
# Run `00-setup.R` first.

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

