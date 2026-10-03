Scout: `go run ./cmd/fire-scout [-plan|-highlevel-plan] [-uber] [-since <ref>|upstream]` scripts every Zoo review. Prints numbered questions, many with `path:line`, or `NO QUESTIONS`. Design and checks: `_ai/fire-scout.md`.
- Mode: no flag = implementation review; `-highlevel-plan` / `-plan` = spec review; `-uber` = cross-agent uber review, with a plan flag or alone for the final one.
- Range: default uncommitted changes plus untracked files; `-since <ref>` for a committed range; `-since upstream` for all unpushed work.
- Check wrong: proposal to fix it.
