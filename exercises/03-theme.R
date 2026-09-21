# Exercise 3: a theme for your organization
#
# Run `00-setup.R` first.

# A. Finish the theme below. It should:
#  - be named "R/Pharma 2026"
#  - print every table with {flextable}
#  - round percentages to one decimal place
#  - round p-values to three decimal places
# HINT: the element names are catalogued in the themes vignette,
# https://www.danieldsjoberg.com/gtsummary/articles/themes.html

theme_gtsummary_rpharma <- function(set_theme = TRUE) {
  lst_theme <-
    utils::modifyList(
      # start from the shipped compact theme, then layer ours on top
      theme_gtsummary_compact(set_theme = FALSE),
      list(
        "pkgwide-str:theme_name"     = ,
        "pkgwide-str:print_engine"   = ,
        "tbl_summary-fn:percent_fun" = ,
        "pkgwide-fn:pvalue_fun"      =
      )
    )

  if (set_theme == TRUE) set_gtsummary_theme(lst_theme)
  invisible(lst_theme)
}

# B. Check the theme, then set it and build a table to see it applied.

check_gtsummary_theme()

# C. Clear the theme again before moving on.

reset_gtsummary_theme()

