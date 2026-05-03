---
name: zoo-uberreview
description: Run a super-comprehensive review based on the repository instructions.
---

Launch separate reviewer subagents for every file under .zoo/review/, provide those instructions to the reviewers. Ask for a VERY thorough review. Want: refactorings, fixes, improvements, omissions, changes. Respect the spirit and hard constraints of the user's request, but ok to question specific decisions if problematic. Categorize by P1 critical blockers (nothing else matters until fixed), P2 important/foundational changes (do first), P3 normal (do last). You're the final line of defense, do not miss anything.

When reviewing code, ask agents to also read and follow `.zoo/coding.md`, `.zoo/testing.md` and `.zoo/codereview.md` if exists.

When reviewing plans, ask agents to also read and follow `.zoo/planning.md` and `.zoo/planreview.md` if exists.

Uberreview is part of the same task as the work being reviewed. All review reports should have review-smt suffixes.

After reviewers complete, analyze, combine and prioritize the findings into a single report.
