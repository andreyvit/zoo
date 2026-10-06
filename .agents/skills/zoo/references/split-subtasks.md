Only after the high-level plan is approved.

Split into subtasks:

- small but not trivial
- self-contained
- one reviewable commit each
- use multiple subtasks for cleanly separable incremental feature buildup
- identify every refactoring and global/cross-cutting mechanism change needed by the feature
- prefer ordering refactoring and global-change subtasks before the main feature work
- put each known change in a separate subtask; make it a prerequisite when dependent work cannot safely use the planned design
- keep feature subtasks narrow; extract broad prerequisites instead of expanding a feature commit
- keep late fixes separate when they would significantly broaden or mix the active subtask, even when it introduced the gap
- put that subtask's technical spec under it; no separate Subtask Technical Specs section
- every High-level plan / Scope item has a home
- every change belongs to a subtask; add a subtask before making the change
- batch a bunch of tiny user-requested updates into one subtask; otherwise keep each subtask focused

Red flags:
- change with no subtask
- unrelated features combined
- clean steps merged without good recorded reason
- micro-subtasks with no meaningful functionality step
- wrong order
- late refactoring/global change silently added to an in-progress subtask
- broad prerequisite work hidden inside a feature subtask
- hidden deps
- missing browser-impact flags
- earlier subtasks relying on later outputs
- spec items uncovered
- low-level split that quietly changes the approved high-level plan or scope

Orchestrator runs zoo-spec-review on Low-level plan + Subtasks after the split.

Late discoveries follow `references/change-or-suggestion.md` immediately. After independent remaining work, batch decisions through `references/reapproval.md`.
