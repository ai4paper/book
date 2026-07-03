# AI4Paper Book — Organization Guide

A tutor book teaching AI tools across the full paper lifecycle (选题 → 实验 → 写作 →
投稿 → 修回 → 发表). Structure follows the `think-isomo` Typst book template. The
course plan lives in `outline.md`; chapters implement it.

## File Structure

```
ai4paper/
├── ai4paper.typ          # Main file: title page, TOC, preface, includes, bibliography
├── common.typ            # Shared library: theorion, colors, redt()/bluet()/greent()
├── references.bib        # Bibliography (IEEE style)
├── outline.md            # Course plan (source of truth for scope)
├── figures/              # Standalone CeTZ figures + compiled pdfs (included as images)
└── chapters/             # One file per chapter, numbered by phase order
    ├── 01-foundations.typ
    ├── ...
    └── 09-after-acceptance.typ
```

## Conventions

- Every chapter file starts with `#import "../common.typ": *` followed by its
  `= Chapter title` (level-1 heading = chapter).
- Chapter files are numbered `NN-name.typ` in research-lifecycle order; the include
  list in `ai4paper.typ` must match.
- If a chapter grows too long, split sections into a folder
  (`chapters/06-writing/style.typ`, ...) — only the first file keeps the `=` chapter
  heading; the rest start at `==` (same merge rule as think-isomo).
- Content style: Chinese narrative with English technical terms (matches the talks in
  `../paper/`). Each chapter (03–09): research basics of the phase first, then AI
  tools, then a hands-on 练习 tied to the running example.
- Cross-reference the Module-0 map with `@foundations:map`.

## Build

```bash
typst compile ai4paper.typ
```
