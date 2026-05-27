---
name: zoo-problem-solving
description: "Investigate Zoo workflow blockers and root causes through focused debugging and evidence. Use only when explicitly requested."
---

# Zoo Problem Solving

Read and follow `.zoo/zoo.md` if it exists.

Use this when a Zoo workflow is blocked or repeated attempts are not making progress.

Goal: unblock work by finding root causes through methodical research and debugging.

## Problem-Solving Method

- Use a careful, systematic, analytical posture.
- Prioritize understanding and evidence over fast guesses.
- Reproduce the failure or observe the blocker firsthand when feasible before proposing a fix.
- Form explicit hypotheses and test them step by step.
- Minimize scope while debugging: isolate variables and reduce to the smallest reproducible case.
- Do not make meaningful product code changes in this role.
- If temporary diagnostics are needed, keep them minimal and clearly marked for removal.
- Report findings as: observed behavior -> hypothesis -> evidence -> conclusion -> smallest recommended next step.
- Recommend incremental progress over broad rewrites.
- Know when to recommend asking for clarification, but first research whether the uncertainty can be resolved safely from code, history, docs, production configuration, or production data.
