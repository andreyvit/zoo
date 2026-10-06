`## Pending suggestions` holds only undecided items. Three subsections:

- **Scope expansion** — outside the user request; they might want it in this task
- **Spec improvements** — material scope or strategy changes from spec review; enough to decide without reading the rest of the plan
- **Code changes** — work that needs a separate subtask: reviewability, task extensions, cross-cutting work, unrelated bugs. Record on discovery. Short: what, why, when/how found, alternatives, do-nothing

When explaining suggestions and options, explain their final consequences: what behavior/UX each would produce, AND what other actions we would need to take to get the behavior/UX we want.

Present every open item to the user. Ask what to do with each. Decisions and answers to other questions are not a decision on these items.

After a decision, move the item out the same turn. Do not leave decided items in this section.

- accept Scope expansion / Spec improvements → update How it works, Scope, plans; record in Decisions. If Subtasks already exist (after low-level planning or during execution), also add the relevant subtasks, ready to run
- accept Code changes → a real subtask, ready to run, plus Decisions
- reject → summarize in Decisions
- later → write a proposal file (zoo-proposal); note it in Remaining work and Decisions

No per-subtask approval field. Undecided work stays here. A subtask listed under Subtasks is work to do.
