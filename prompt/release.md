# Release prompt

Cut a new release of the AI4Paper book. Follow this exactly.

## How releases work (context)

A release is driven entirely by pushing a `vX.Y.Z` git tag. There is **one** GitHub
Action, `.github/workflows/release.yml`, triggered by the tag. It:

1. Installs Source Han Serif (the CJK fallback font) and Typst.
2. **Compiles the book** — `typst compile --root . ai4paper.typ build/ai4paper-vX.Y.Z.pdf`.
   This is the build gate: if the Typst source doesn't compile, the job fails here and
   **no Release is created**.
3. **Builds the release notes** — pulls the `## X.Y.Z` block out of `CHANGELOG.md`
   (everything up to the next `## `). If that section — or the file — is missing, it
   falls back to notes auto-generated from `git log` since the previous tag.
4. **Publishes a GitHub Release** named `Release vX.Y.Z` with those notes as the body and
   the compiled `ai4paper-vX.Y.Z.pdf` attached.

Unlike a code package, this book ships no version file: the tag plus the top `## X.Y.Z`
heading in `CHANGELOG.md` *is* the version-of-record (the title page shows only the
compile date). So the agent's job is only: decide the bump, write the changelog section,
verify it compiles, commit, tag, push.

> Requires **Typst** locally (same version family as CI: `typst --version`). The only
> package dependency, `theorion`, is fetched from the Typst registry on first compile.

## Steps

Let `X.Y.Z` be the new version. Decide the bump from the commits since the last release
(the book is pre-1.0, so stay in `0.y.z`):

- **new chapter / section / substantial new material** (`feat`) → minor (`0.Y+1.0`)
- **edits, fixes, docs, figures, chore** (`fix`/`docs`/`chore`/…) → patch (`0.y.Z+1`)

1. **Find the baseline.** The last release is the top `## a.b.c` heading in `CHANGELOG.md`;
   its bottom entry carries that release's starting commit hash. List commits since it:
   ```
   git log <last-version-hash>..HEAD --pretty=format:'%h %an %s'
   ```
   _First release / no versioned section yet:_ list the full history
   (`git log --pretty=format:'%h %an %s'`) — the seeded `## 0.1.0` section already covers it.

2. **Add a `## X.Y.Z` section to `CHANGELOG.md`** directly above the previous version
   section. One line per commit, newest first:
   ```
   - <type>: <commit subject> (@who) <hash>
   ```
   This repo uses **plain conventional commits** (`docs(foundations): …`, `init: …`) — no
   emoji — so the line is essentially the commit subject as-is, plus `(@who)` and the short
   hash. If a commit *does* carry an emoji prefix, strip the emoji and keep the type word.
   Skip purely-mechanical commits (merge/formatting noise) if they add nothing — use judgement.

3. **Gate on a local compile** (CI compiles the same source; catch breakage before tagging):
   ```
   typst compile --root . ai4paper.typ
   ```
   Fix any error before continuing. (The output PDF is git-ignored — don't commit it.)

4. **Commit** the changelog (and any release-prep edits) together, plain-conventional style:
   ```
   git add -A
   git commit -m "chore: release X.Y.Z"
   ```

5. **Tag** (annotated) and **push** the commit, then the tag:
   ```
   git tag -a vX.Y.Z -m "vX.Y.Z"
   git push origin main
   git push origin vX.Y.Z
   ```

6. **Confirm** the workflow ran and the Release appeared:
   ```
   gh run list --limit 5
   gh release view vX.Y.Z   # once the run finishes
   ```
   Optionally `gh run watch <id>` and report any failure. Common causes: a Typst compile
   error (the gate), the font download flaking, or the `## X.Y.Z` changelog section
   missing/misnamed (the run still succeeds but the notes fall back to the git-log summary).

## If a release needs to be re-cut (the workflow failed after the tag push)

If the run fails, the tag exists but there is no Release (and no PDF asset). Because this
book publishes to nowhere but GitHub, reusing the same version is fine — fix the cause,
then move the tag onto the fix:
```
git commit ...                                     # the fix (e.g. a Typst error)
git push origin :vX.Y.Z && git tag -d vX.Y.Z       # drop the remote + local tag
git tag -a vX.Y.Z -m vX.Y.Z                        # re-tag on the fixed commit
git push origin main && git push origin vX.Y.Z     # re-triggers the workflow
```
(Skipping to the next patch version instead is equally valid — a gap in numbers is harmless.)

## Notes

- Don't build or commit the PDF locally — producing and attaching it is the workflow's job.
  `*.pdf` is git-ignored (except the `figures/chapter-map.pdf` build *input*).
- The tag is the source of truth for the version. Keep the `## X.Y.Z` heading in
  `CHANGELOG.md` exactly equal to the tag minus its `v` — the workflow matches them
  literally to find the notes; a mismatch silently falls back to auto-generated notes.
- Keep releases in the `0.y.z` range until the book is declared formally published (the
  preface currently marks it *尚未正式发布*). Reaching `1.0.0` is the "first edition" signal.
