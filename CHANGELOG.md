# Changelog

All notable changes to this book are recorded here.

Format per entry: `<type>: <commit subject> (@who) <hash>`, newest commit first.
Sections are grouped by version (the pushed `vX.Y.Z` tag, minus the `v`), newest
version on top. Cutting a release is scripted — see [`prompt/release.md`](prompt/release.md).

The version-of-record for a release is this file's top `## X.Y.Z` heading plus the
matching git tag; the book itself carries no version string (the title page shows the
compile date, per the preface). While the book is pre-1.0 it stays in the `0.y` range.

## 0.2.1

- docs(setup): fill environment setup chapter (model API, runtime, MCP) (@isomoes) e4f6fb1

## 0.2.0

- docs(foundations): cite sources for LLM/agent/MCP claims and limitations (@isomoes) 79dda63
- docs(foundations): add global-map figure and three concept figures (@isomoes) ac8a610

## 0.1.0

- docs(foundations): quote 「像真的」/「是真的」in hallucination section (@isomoes) 36af7ba
- init: import ai4paper book as standalone repo (@isomoes) 01f5ec6
