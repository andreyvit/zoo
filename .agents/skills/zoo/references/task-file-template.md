---
revision_round: 0
stage: HL
stage_complete: false
tickets: []
status: building high-level plan
---

# <Short change title>

<fill in as you go, and fully reconsider and clean up after ending>

## User request

<verbatim-ish user ask + ticket content; update whenever the user steers>

## What happened

<clearly explain WHAT undesirable behavior is happening, WHY/HOW it is happening, impact, is it a regression or was it always broken, WHO and WHY and WHEN introduced a change that broke it and/or affected it; say whether this is a code bug or a configuration/human/usage error>

## How it works

<Very high level overview of our technical approach, dev-facing explanation, the kind Joel Spolsky would give to Bill Gates. Keep short: 1–3 introductory paragraphs plus 0–8 bullet points with the most important details. Highlight controversial, counter-intuitive, or unusual choices. Other details belong in High-level plan or Low-level plan.>

## Scope

### Scenarios that must work

- <realistic usage scenarios, edge cases and variations that we support>

### Out of scope

- <edge cases, variations and complications we choose to NOT support to simplify code and avoid overengineering>

### Bonus scope

- <highlight changes that are not part of user request, but will be / was implemented additionally>


## Report

### Status

<overall task status>

<list of subtasks with their statuses>

### Screenshots

<after execution, a strong set of real screenshots showing any new or modified UIs in all relevant states, cropped to focus on relevant areas, inlined in Markdown as images>

### Remaining work

<what was not done, proposals written for the future, what cleanup steps should be taken later and where they've been recorded, and similar>

### Quick guide to publish in the ticket

<write a brief guide to user-visible product-level changes, to post in the ticket targeting ticket opener; include exact screens and labels/names; add QA checklist and deployment/configuration/rollout checklist; do not go code-level, focus on user-visible and product-level changes, but do consider the entire rollout and configuration story>


## Code Summary

<fill via zoo-summarize-code skill when all commits done>


## Pending suggestions

### Scope expansion

<itemized list of anything outside user request that user might want to include in the scope of the task>

### Spec improvements

<spec review adds itemized, simple, human-readable, high-level descriptions of suggested material changes to scope and implementation strategy that need user approval; clear explanations with enough detail and context to decide without reading the rest of the plan; approved/rejected move to Decisions; should be processed to empty prior to execution>

### Code changes

<record itemized work delayed for a decision because it needs a separate subtask for reviewability, overall task changes/extensions, cross-cutting work, and unrelated bugs immediately on discovery; accepted items become real subtasks ready to run; rejected summarize in Decisions; later means write a proposal file -- for each item, explain what is proposed, why it is needed, when/how it was discovered, what alternatives are, and consequences of doing nothing; use clear simple language>


## High-level plan

<Update this spec after every subtask, especially after the entire task. Keep subsections max terse: 0–2 introductory paragraphs, then grouped bullets, up to 7 items per list and 3 nesting levels. Add a Details subsection for details with no other home.>

### Persisted data changes

<all changes to on-disk/in-database data>

### Model changes

<all model changes not covered under Persisted Data Changes>

### UI changes

<all changes to UI grouped by area and screen, with exact texts and labels>

### Public API/endpoint changes

<all changes to our publicly accessible contracts/interfaces/endpoints used by external systems, vendors and clients>

### Private API/endpoint changes

<all changes to our contracts/interfaces/endpoints used across separately deployed parts/units/servers/environments of our own system>

### Backwards-incompatible changes

<contracts or compatibility guarantees this change breaks: APIs, stored data, integrations, supported clients; affected users/consumers and required migration or coordination. Say none if none.>

### Dependency changes

<list of all changes outside of this repository, and dependencies added/upgraded, if any>

### Surprises

<list everything that might be surprising about our implementation to someone who only knows the initial user request>

### Risky changes

<list of the most risky modifications made that could cause deployment issues, performance slowdowns, break specific configurations, or otherwise highest-risk areas, to guide user's reviewing efforts>

### Deployment process and risks

<explain how this should be deployed safely, what risks exist -- code, migrations, effect on existing users, legacy configurations, preexisting data; explain what you did to mitigate those risks, and what still needs to be done to ensure safety>

### Product changes

<detailed contract of observable behaviors: top-to-bottom behavior, grouped by area, most visible first>

### Functionality regressions

<existing behavior or UX that becomes worse or unavailable; affected users/scenarios, tradeoffs, mitigations, and remaining actions. Say none if none.>

### Responsibilities

<software architecture -- who does what, who knows what and what details are hidden from whom in new/updated code>


## Low-level plan

<Keep subsections max terse: 0–2 introductory paragraphs, then grouped bullets, up to 7 items per list and 3 nesting levels. Add a Details subsection for details with no other home.>

### Naming

<all names, identifiers, keys that we introduce/change in code, and clear simple description of each, plus alternative names considered for each>

### By package/dir

<overview of code changes, grouped by package/directory, most extensive changes first>

### Code API changes

<all changes to code-level contracts/interfaces within the deployment unit we're working on>

### Performance regressions

<slowdowns or increased resource use versus current behavior; affected workloads, expected/measured impact, mitigations, and remaining actions. Say none if none.>

### Performance

<remaining performance characteristics not covered above: surprises, non-linear behavior, memory usage, tradeoffs, algorithmic complexity>

### Limits and validations

<deep analysis of any numeric limits, validation rules and other constraints the code will apply -- in UI, API, and internal processing>

### Error handling

<error handling strategy, which errors we handle specifically/generically, what we leave unhandled, what we crash on, how we report failures>

### Tests

<cohesive testing strategy: integration/scenario/edge-case/unit tests; what we test and what we skip; which details are locked down by tests and which details are hidden from tests; which tests best serve as human-readable specs on what we are building>

### Logging

<cohesive logging strategy, full list of situations to log, which details to include>

### Metrics

<any changes to metrics, spans and similar>

### Helpers and abstractions

<helpers/abstractions to introduce or modify>

<helpers/abstractions to use>

### Tooling and harness

<changes to tools, build process, scripts, harness and similar>

### Docs

<which doc files, instructions and resources to update>



## Subtasks

<a detailed split into meaningful, self-contained, small subtasks, each ending in a compact reviewable commit; keep broad/cross-cutting changes separate; split unrelated features and clean incremental steps unless Decisions records a good reason; avoid micro-subtasks; use [ ] / [>] / [x] for execution; every subtask here is ready to run; undecided work stays under Pending suggestions; keep that subtask's technical spec under it, not in a separate section>

<example>
1. [x] Do this and that

    Do this in corethis and implement thatutil.That. <The instructions specific to this subtask, as you're going to use to guide implementation.>

    Technical spec:

    - <detailed itemized spec of internals after implementation; update during implementation>

2. [>] Change these and those to those and these

    Technical spec:

    - <detailed itemized spec of target internals, planned when starting a subtask>

3. [ ] Frubbernate all of those

    Technical spec:

    - <rough itemized spec of future internal changes; detailed planning waits until subtask start, but outline exists now>
</example>


## False positive or rejected review findings

<list all review findings to ignore here, to avoid re-considering them every time>


## Decisions

<itemized list; product first, then technical; mark user calls with (USER)>


## Log

<log everything that happens, one line per event, newest last, written as it happens: research done, What happened filled, classified code bug or not, high-level spec review, pending-suggestion decisions, high-level plan approved, low-level spec review, user go to execute, subtask started/done (commit hash + gate result), code-change suggestion discovered/resolved, review round failed and why, validation failed, user steering, decision changed, blocker hit and resolved, mention details>

<example>
- User request recorded
- Research done: .tasks/YYYYMMDD-<task>-research.md
- What happened filled; classified as code bug
- High-level plan drafted
- High-level spec review: fixed uncontroversial omissions; Spec improvement recorded: <one-line>
- Spec improvement accepted; Scope expansion rejected
- High-level plan approved
- Low-level plan and subtasks written
- Low-level spec review passed
- User go to execute
- Subtask 1 “Do this and that” planning done
- Subtask 1 “Do this and that” coding done
- Subtask 1 “Do this and that” browser testing done: .tasks/YYYYMMDD-<task>-evidence/001-that.png
- Subtask 1 “Do this and that” scripted review failed: foo, fubar
- Subtask 1 “Do this and that” fixes done
- Subtask 1 “Do this and that” scripted review passed
- Subtask 1 “Do this and that” visual review flagged issue: <issue description>
- Subtask 1 “Do this and that” fixes done
- Subtask 1 “Do this and that” visual review passed
- Subtask 1 “Do this and that” committed: <commit>
- Code change recorded from subtask 1 review: <one-line finding>
- Code change accepted as subtask 5; another Code change written as a proposal
</example>
