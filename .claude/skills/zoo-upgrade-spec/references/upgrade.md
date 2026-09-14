Find specs:
- user paths win
- else dirty `.spec/*.md` (not `archived/`)
- else one obvious non-`done` spec
- else ask

Copy template section order and placeholder instructions. Kill `<example>` blocks. Keep all unique existing content.

Heading remaps (by meaning, not a closed list):

| Old | Current |
| --- | --- |
| Request, User Input | User request |
| What Happened | What happened |
| How Its Gonna Work (top-level or under Spec) | How it works |
| Product Spec, Product Changes, Product Contract | High-level plan → Product changes; Scope if it is scenarios |
| Spec (wrapper) | unwrap; park children in How it works / Scope / High-level plan |
| High Level Technical Spec | How it works if approach; else Low-level plan → By package/dir |
| Pending Changes | Pending suggestions (Scope expansion / Spec improvements / Code changes) |
| Decision log | Decisions |
| Execution memory | Log |
| Subtask Technical Specs | that subtask's Technical spec |

Report used to hold How it works / Bonus scope / Surprises / Risky / deps. Those live in Scope and High-level plan now. Report keeps Status, Screenshots, Remaining work, Quick guide. Move, do not drop.

Unknown extra sections: nearest current home. Do not delete unique text.

Subtasks:
- strip `Approval:`
- `Approval: approved` / `[x]` stay in Subtasks
- `Approval: pending` and never approved → Pending suggestions → Code changes (it was never approved)
- `Approval: rejected` → Decisions
- ready `[ ]` / `[>]` with no pending Approval stay in Subtasks

Status (never weaker than the file already claims):

- keep `done`
- keep any status that already says `approved`, `executing`, `completed`, `paused`, `investigating`, `investigation complete`, or `done`
- old `planning high-level approach` / `planning` with no approval evidence → `building high-level plan`
- same, but log/user text says high-level approved, or Low-level plan / Subtasks are real (not leftover placeholders) → at least `high-level plan approved, building low-level plan`
- in-progress checkboxes → `executing subtask N` unless already stronger
- if current status is already a current exact value, keep it

Do not fill empty Low-level plan or Subtasks just to look complete. Placeholders only.

Keep extra YAML frontmatter keys (e.g. `uberreviews: true`). Do not add `uberreviews` unless the spec already had it or the user asked.

Do not rewrite product/technical substance. Rename and place.

Append Log. Do not rewrite Log history. Do not commit.
