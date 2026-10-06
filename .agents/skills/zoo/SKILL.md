---
name: zoo
description: "Lightweight spec-driven workflow: collaborative spec, top-level TDD implementation, scripted review gate, one commit per subtask. Use only when explicitly requested."
---

# Zoo workflow: spec, research, subtasks, reviews

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Keep specs as brief as possible while retaining all necessary details. Plain, simple language; maximum terse format; as few sentences as needed to explain the plan. Spec subsections, including both plans: 0–2 introductory paragraphs, then optional grouped bullets, up to 7 items per list and 3 nesting levels; retain this format through revisions.

Spec metadata (preserve existing prose):
- Exactly one H1: 2–5 words describing the change, without date/ticket/status.
- `revision_round: 0`: increment only when a user revision reopens finished execution. Requests during planning/execution and routine review fixes keep the current round.
- `stage`: `INV` investigation, `HL` high-level planning, `LL` low-level planning, `EX` execution, `FIN` final review/closeout. Update on transitions.
- `stage_complete: false`: true when this stage’s work is finished, ready for review/approval/next action. Reset on entry/reopening. Keep prose `status` consistent.
- `tickets: []`: task tickets only. Derive counts from existing subtask/suggestion lists.
- Older spec format detected: run zoo-upgrade-spec on that spec before continuing.

On task start/resume/switch, emit `Zoo task start (.spec/example.md) r0`, `Zoo task resume (.spec/example.md) r0`, or `Zoo task switch (.spec/example.md) r0` as a standalone chat line with actual spec path/round. These identify this chat as the task owner. Pass both to subagents; reviewers emit `Zoo review session (.spec/example.md) r0`. No session-ID discovery. Unknown round: `r?`; no associated spec: `(no spec) r?`.

Compaction: preserve current ownership, round, and latest relevant receipts. Label prior tasks/receipts historical; never re-emit them as new events.

Task file `.spec/YYYYMMDD-<task>.md` = spec and memory. Status says exactly where work stopped, e.g. `investigating`, `investigation complete`, `building high-level plan`, `high-level plan approved, building low-level plan`, `executing subtask 2`, `completed subtask 5; awaiting decision on Pending suggestions`. Subtasks in the list are ready to run. Undecided work stays under `Pending suggestions`. Log task-work events as they happen. Do not log Zoo Squash, Zoo Rebase, or Zoo Push mechanics or outcomes; they only dirty a finished spec. Never commit task file without explicit request.

Research via subagents, orchestrator writes `.tasks/YYYYMMDD-<task>-research.md`, then everyone reads.

Two-stage planning. Sequence: high-level → spec review → (if `uberreviews: true`) spec uber-review once → low-level including subtasks → spec review → (if `uberreviews: true`) spec uber-review once. Do not write Low-level plan or Subtasks until the user explicitly approves the high-level plan.

If the user asks for uber-review, or the prompt says so: set spec frontmatter `uberreviews: true` and log it. Automatic uber-review is once per stage: one high-level spec uber-review, one low-level spec uber-review, one final uber-review when the whole task is done. Do not re-run after addressing findings. Extra reruns only if the user asks.

Keep `How it works`, `Scope`, `Report`, `High-level plan`, and `Low-level plan` current during planning and execution. After each subtask, update those sections plus that subtask's inline technical spec. Significant changes to the approved high-level plan or scope need user approval. During execution, record other significant changes under `Pending suggestions` → `Code changes` and wait for reapproval. User-requested revisions after spec approval: use zoo-revision.

Every change belongs to a subtask. Add a subtask before making changes. Batch a bunch of tiny user-requested updates into one subtask. Otherwise keep subtasks focused.

Split work into subtasks, after each: screenshots, scripted and visual reviews, commit. Put known refactorings and global/cross-cutting mechanisms in separate subtasks/commits. Keep feature subtasks narrow; never silently expand them.

Evidence dir `.tasks/YYYYMMDD-<task>-evidence/`:
- screenshots: good, real, representative, fully styled, never fabricate or fake, crop to relevant area plus context, enough to verify all UI changes, must show all affected UI in all states, must show all pages mentioned by ticket or user request
- input/output file examples if applicable

Workflow seq:

- references/intake.md
- references/research.md
- if investigate ask: references/investigate.md; continue only if code bug
- references/spec-with-user.md stage 1 (high-level)
- zoo-spec-review skill (high-level only); loop until addressed
- if `uberreviews: true` and no high-level Spec uber-review log yet: zoo-spec-uberreview once
- references/pending-suggestions.md (present each open item, ask, move decided out)
- iterate with user; record explicit high-level approval; status: `high-level plan approved, building low-level plan`
- references/spec-with-user.md stage 2 (low-level) + references/split-subtasks.md
- zoo-spec-review skill (low-level + subtasks); loop until addressed
- if `uberreviews: true` and no low-level Spec uber-review log yet: zoo-spec-uberreview once
- references/pending-suggestions.md (present each open item, ask, move decided out)
- Scope expansion and Spec improvements must be empty before execution
- references/approval.md
- while a remaining subtask can proceed:
  - set `stage: EX`, `stage_complete: false`; mark subtask `[>]`; set status: executing subtask N; emit `Zoo subtask N start (.spec/example.md) r0`
  - do `.zoo/subtask-start.md` if exists
  - if research insufficient, run zoo-researcher subagent with task, research file, subtask details, specific asks; merge back to research file
  - plan subtask: write/refine that subtask's technical spec; update How it works, Scope, Report, High-level plan, Low-level plan
  - read `.zoo/coding.md` and `.zoo/testing.md` if exist
  - implement, TDD when possible: stubs, tests, code
  - run focused tests for modified parts of code
  - if browser-flagged or need screenshots: run zoo-browser-verifier with task file, research file, subtask details, evidence dir
  - look at screenshots, identify gaps, UI/UX/styling issues, ways to improve; fix and repeat
  - run zoo-code-review skill
  - skip findings listed in `False positive or rejected review findings`; add new false positives or rejected findings there, not in source
  - fix findings that fit the active subtask and keep its commit cohesive; route others through references/change-or-suggestion.md; re-run until active work is clean and other findings are routed
  - update task file: the subtask (incl technical spec), How it works, Scope, Report, High-level plan, Low-level plan, anything relevant
  - run zoo-docs skill
  - commit code (use skill if exists)
  - mark subtask `[x]`; emit `Zoo subtask N finished (.spec/example.md) r0`; set EX `stage_complete: true` when all current subtasks are finished
  - do not amend/rewrite this commit for later-discovered work unless user explicitly asks or invokes Zoo Squash
- follow references/change-or-suggestion.md whenever considering work beyond the active subtask, even when it fits the overall task
- when no remaining subtask can proceed: open Pending suggestions => references/reapproval.md; none => if `uberreviews: true` and no Final uber-review log yet, zoo-final-uberreview once (brief all findings in chat first, then suggestions; accepted → subtasks); when still none, references/closeout.md. Do not auto-rerun final uber-review after those subtasks.

Channel Linus Torvalds and Don Melton for voice, code values and approach. "Is it right?" obsession for quality and tech. Agent chat, replies, report: blunt, terse, call out crap and garbage, swearing good, empty politeness and hedging bad.

Before Ask User tool, explain full context of the question in chat, add clickable link to task file, code snippets, pointers, screenshots, do not assume user familiar with spec, explain relevant parts of spec

After high-level approved:
- significant How it works / Scope / High-level plan change? get user approval; during execution follow references/change-or-suggestion.md
- work would broaden/mix the active subtask, change the overall task, or fix an unrelated bug? follow references/change-or-suggestion.md
- decision needed? research it; decide mundane calls within approved scope, otherwise follow references/change-or-suggestion.md

Run browser/computer use in zoo-browser-verifier subagent.
