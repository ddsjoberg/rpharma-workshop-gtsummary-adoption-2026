# Exercise 1 solution: ARDs with {cards}
#
# Run `00-setup.R` first.

# Calculate the number and percentage of *unique* subjects with at least
# one AE:
#  - By each SOC (AESOC)
#  - By each Preferred term (AEDECOD) within SOC (AESOC)
# By every combination of treatment group (ARM)

ard_stack_hierarchical(
  data = adae,
  variables = c(AESOC, AEDECOD),
  by = ARM,
  id = USUBJID,
  denominator = adsl
)


