# AI4Paper — A Practical Guide to Writing AI/ML Research Papers

A book on how to plan, run, write, submit, and revise AI/ML research papers,
organized along the research lifecycle and typeset with
[Typst](https://github.com/typst/typst).

## Structure

```
book/
├── ai4paper.typ                 # Main file: title page, TOC, preface, includes, bibliography
├── common.typ                   # Shared theorem environments, colors, and text helpers
├── references.bib               # Bibliography (IEEE-style)
├── chapters/                    # One file per chapter, in research-lifecycle order
│   ├── 01-foundations.typ
│   ├── 02-setup.typ
│   ├── 03-find-problem.typ
│   ├── 04-experiments.typ
│   ├── 05-data-figures.typ
│   ├── 06-writing.typ
│   ├── 07-submit.typ
│   ├── 08-revision.typ
│   └── 09-after-acceptance.typ
└── figures/                     # CeTZ figure sources + compiled PDFs (embedded as images)
    ├── chapter-map.typ
    └── chapter-map.pdf
```

Every chapter starts with `#import "../common.typ": *` and is included from
`ai4paper.typ` in order.

## Building

### Prerequisites

- [Typst](https://github.com/typst/typst) (latest version)
- Source Han Serif (CJK fallback font — the text is mixed English/Chinese)

The only package dependency is [`theorion`](https://typst.app/universe/package/theorion),
fetched automatically from the Typst package registry on first compile.

### Local compilation

```bash
typst compile --root . ai4paper.typ
```

The compiled `ai4paper.pdf` is **not tracked** — it is a build artifact.

### Automated releases

The PDF is built by GitHub Actions, not committed. Pushing a version tag
(e.g. `v1.0.0`) triggers `.github/workflows/release.yml`, which:

1. Installs Source Han Serif and Typst
2. Compiles `ai4paper.typ`
3. Publishes a GitHub Release with the PDF attached as `ai4paper-v1.0.0.pdf`

To cut a release:

```bash
git tag v1.0.0
git push origin v1.0.0
```

## Authoring with Claude Code

`.claude/skills/` vendors the two skills used to write this book, pinned by
`skills-lock.json`:

- **creating-figures** — publication-quality CeTZ figures for the `figures/` directory
- **isomoes-writing** — objective, narrative-driven technical prose

## License

Licensed under the MIT License. See [LICENSE](LICENSE) for details.
