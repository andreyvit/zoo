---
name: zoo-final-uberreview
description: "Cross-agent production-safety review: zoo-ensure-safe-deploy in every uber-review agent. After the whole Zoo task is done when the spec has uberreviews: true, or when explicitly requested."
---

Follow `.zoo/zoo.md`, `.zoo/review.md` and file at `$ZOO_LOCAL_MD` if exists

Do not start impl except through Zoo subtasks after user approval. Do not treat this as closeout.

Scout (`Scout:` line in `.zoo/review.md`): run with `-uber` over the reviewed scope (the range option `.zoo/review.md` documents; default all unpushed work). Unless `NO QUESTIONS`, add its output to every agent's prompt, own harness included. Non-zero exit: fix or report, never read it as no questions. No scout: no questions.

If the spec is not `uberreviews: true`, set that frontmatter key and log the mark.

Load zoo-ensure-safe-deploy. Own harness: run that skill in a subagent. No production-implementation edits. Other harnesses: read `zoo-spec-uberreview/references/invoke-uberreview.md`; PROMPT is zoo-ensure-safe-deploy's full instructions plus task file, research file, scoped changes, scout output if any, and "findings only; do not modify files or implement."

Combine: merge subagent and CLI findings; dedupe; keep which agents raised each; verify every finding against code (external agents share none of your context and can be wrong). Drop only findings that are false about the code; list those under `False positive or rejected review findings`.

Every remaining finding becomes a Pending suggestion (Code changes, or Scope expansion / Spec improvements if that is the width). Do not auto-fix.

In chat, list and explain every remaining finding with recommendations, before asking about any item. Include a clustered deeper-flaw reading and wide/narrow alternatives only when a deeper spec or approach flaw is confirmed. Then ask per Zoo skill `references/pending-suggestions.md`. Where a deeper flaw was confirmed, each ask includes the recommended width and the narrower alternative(s). User must decide each item. Accepted items become real Zoo subtasks ready to run; execute them through the normal subtask loop. Rejected go to Decisions or False positive or rejected review findings.

Log `Final uber-review (<agents>): ...` in `## Log`. Note agents and results (N findings recorded, K skipped / specific error) in that row; show the summary to the user. Status `final uber-review` while running; after findings, `awaiting decision on Pending suggestions` if any remain.

Do not re-run this pass after addressing findings. Offer the user a rerun; never start one automatically.

If no findings remain, caller may close out.
