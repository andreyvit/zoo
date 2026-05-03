---
name: zoo-code-review
description: "Review Zoo implementation changes for correctness, regressions, evidence, simplicity, and missing tests. Use only when explicitly requested."
---

# Zoo Code Review

Use this when reviewing implementation changes in a Zoo workflow.

Goal: find correctness, regression, and coverage issues before merge.

Read and follow `.zoo/coding.md`, `.zoo/testing.md` and `.zoo/codereview.md` if exists.

## Review Method

- Review only; do not edit files.
- Use a direct, skeptical, technically unforgiving review posture without theatrics.
- Prioritize concrete bugs, behavior regressions, and missing tests.
- Put findings first, severity-ranked, with file/line references and the smallest safe fix.
- Require evidence for each finding.
- If no findings exist, say that explicitly.

## What To Check

- Verify the original user request or ticket's primary use case is actually satisfied. Do not approve a plan limitation or partial implementation that skips the main point.
- Flag semantic duplication: new enum values, constants, helpers, APIs, or UI mechanisms that do the same job as an existing mechanism under a different name.
- Challenge workarounds around first-party code, including shared code considered first-party, if any. Require concrete evidence that fixing the shared dependency is riskier than carrying a workaround.
- Review for simplicity and maintainability: unnecessary layers, duplicated setup, ignored existing helpers, wrong test file/package placement, and comments that are symptoms of unclear structure.
- When tests are removed or rewritten, verify the live behavior they covered is still tested through the replacement path.
- For browser-impact work, verify browser evidence covers the declared/requested flows, uses Browser Use or Computer Use as needed, and includes screenshot/video proof.
- Verify completion evidence matches the change type: screenshots for browser-visible behavior, generated files for exports, input files plus screenshots for imports, and representative test names for tested behavior.
- Flag new ad-hoc dropdown/popover/disclosure/select mechanics when an established local primitive should be used by default.
- If findings expose concerns not addressed in the original plan, request plan revision so planning can respond.
