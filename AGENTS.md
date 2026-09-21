# Enterprise {gtsummary} — R/Pharma 2026 workshop

Quarto website + a single revealjs deck for the "Enterprise {gtsummary}:
Themes, ARDs, and Custom Extensions for Pharma" workshop at R/Pharma 2026.
Rendered output goes to `docs/`, which is gitignored and published to
`gh-pages` by CI — never hand-edit or commit it.

The slide content is adapted from the posit::conf(2026) pharmaverse workshop
(<https://github.com/posit-conf-2026/pharmaverse>), CC BY 4.0.

## Slide layout

There is **one** deck: `slides/workshop/index.qmd`. It carries the
`format: revealjs` front matter and pulls in every section via
`{{< include >}}`; the included `.qmd` files have no front matter of their own.
To live-preview with reload-on-save, target `slides/workshop/index.qmd`, not an
included file.

Section content stays grouped by topic in sibling folders:

- `slides/ard/` — `intro_to_ards.qmd`, `cards.qmd`
- `slides/gtsummary/` — `00-setup.qmd` … `09-summary.qmd`

Shared assets sit one level up, in `slides/`:

- `slides/images/` — every image, referenced as `../images/<file>`
- `slides/save_flex_docx/` — the Word/PDF example, as `../save_flex_docx/<file>`
- `slides/slides.scss` and `slides/title-slide.html` — theme and title partial

**Quarto resolves relative paths in an included file against the *including*
document, not the included file.** That is why assets live in `slides/` and are
written `../images/…`: the path is correct from `slides/workshop/index.qmd`.
Writing `images/…` inside a fragment will render a broken link, not an error.

The title partial takes the hero logo from a `hero-logo` metadata field rather
than hard-coding it.

`_quarto.yml` uses an explicit `render:` allowlist rather than globs — adding a
page means adding it there, or it will not be rendered. `slides/images/**` and
`slides/save_flex_docx/**` are listed under `project: resources:` so they are
copied even when a reference lives in a template partial or raw HTML.

**Never start a chunk label with `tbl-`, `fig-` or `lst-`.** Quarto reads those
prefixes as cross-reference targets, wraps the output in a float and prints an
auto-numbered "Table 1" caption above the slide's table. Use underscores
(`tbl_roche_summary`) or a plain topic name instead.

## R style

- Tidyverse first — dplyr/tidyr/stringr/lubridate. No data.table.
- Native pipe `|>` for new code.
- `<-` for assignment, never `=` or `->`.
- Two-space indent; keep code lines under ~80 characters.
- `snake_case` for R objects; UPPERCASE for CDISC variables (`SAFFL`,
  `AEDECOD`, `TRTSDTM`).
- Namespace explicitly (`dplyr::filter()`, `cards::ard_tabulate()`) even when
  the package is attached — this repo does so deliberately, so a participant
  reading one slide knows where a function came from.
- Multi-line calls: one named argument per line, trailing comma, closing
  paren on its own line.
- Spaces around operators: `SAFFL == "Y"`, not `SAFFL=="Y"`.

## Data and packages

- Data comes from the pharmaverse packages — `pharmaverseadam::adsl`,
  `pharmaverseadam::adae`, `pharmaverseadam::adlb` — not from local files.
- Dummy data in teaching examples uses the pilot-study `USUBJID` format
  `"01-701-10XX"` (e.g. `"01-701-1015"`), never `"P01"` or bare numbers.
- Packages are managed by `renv` (`renv.lock`, R 4.6.0). Adding a package
  means `renv::snapshot()` *and* adding it to `install.R`, which is what
  participants run on their own machines.
- `renv.lock` is inherited from the upstream pharmaverse workshop and pins a
  superset of what these two decks need. Pruning it (a full `renv::restore()`
  + `renv::snapshot()` cycle) is optional cleanup, not a blocker.
- `{rtables}` is not used for building tables here; it appears only in the
  package-landscape slide (`slides/gtsummary/01-background.qmd`).

## Exercises

Participant scripts are `exercises/<NN-topic>.R`. Solutions are
`exercises/answers/<NN-topic>-answer.R` and are identical to the exercise
except the blanks are filled in.

Blanks are empty named arguments so the skeleton still parses:

    ard_stack_hierarchical(
      data = ,
      variables = ,
    )

Tasks are lettered `# A.`, `# B. [*BONUS*]`, with `# HINT:` comments that
become "We used ..." in the answer. Adding or renaming an exercise means
editing **three** places: the exercise, the answer, and both the `# Exercises`
and `# Solutions` sections of `exercises/exercises.qmd`.

## Skills

Detailed, task-specific procedures live in `.agents/skills/` — one folder per
skill, folder name matching the `name:` frontmatter. Consult the relevant one
before writing pharmaverse code: `ard-creation`, `gtsummary-tables`. See
`.agents/README.md` for the conventions.

Two slides read a skill file at render time — renaming or deleting either
breaks the site build:

- `slides/ard/cards.qmd` reads `.agents/skills/ard-creation/SKILL.md`
- `slides/gtsummary/08-coding-agents.qmd` reads
  `.agents/skills/gtsummary-tables/SKILL.md`
