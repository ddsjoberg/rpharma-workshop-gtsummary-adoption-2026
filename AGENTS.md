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
(`tbl_merge`) or a plain topic name (`roche-summary`) instead.

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

Attendees do **not** clone the repo — they get the code from the published
exercises page, so every exercise slide deep-links to an anchor on it.

One file per exercise, plus one shared setup:

    exercises/00-setup.R          run once, before any exercise
    exercises/01-ard.R            ... 04-wrapper.R
    exercises/answers/01-ard-answer.R   ... 04-wrapper-answer.R

`exercises/exercises.qmd` renders each file under a heading with an
**explicit** id — `{#setup}`, `{#exercise-1}` … `{#exercise-4}`, and
`{#solution-1}` … `{#solution-4}`. The ids are explicit so the slide links
keep working when heading text changes. Adding or renaming an exercise means
touching four things: the exercise file, the answer file, the section in
`exercises.qmd`, and the slide that links to it.

Blanks are empty named arguments so the skeleton still parses:

    ard_stack_hierarchical(
      data = ,
      variables = ,
    )

**That style does not parse everywhere.** `list("key" = )` and a bare missing
argument are fine, but R rejects an empty default in a function signature
(`function(x = )`) and an empty formula right-hand side
(`all_continuous() ~ ,`). Where a blank would land in one of those, use a
placeholder that parses — `statistic = NULL` — with a `# TODO:` comment saying
what to put there. Exercise 4 does both.

Tasks are lettered `# A.`, `# B. [*BONUS*]`, with `# HINT:` comments that
become "We used ..." in the answer.

Always `parse()` every script after editing; they are never executed at render
time, so a syntax error would otherwise surface only in front of the room:

    Rscript -e 'for (f in list.files(c("exercises","exercises/answers"), pattern="[.]R$", full.names=TRUE)) parse(file=f)'

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
