---
name: zoo-upgrade-spec
description: "Upgrade Zoo spec files to the current task-file format. Use when asked to upgrade, modernize, or reformat a spec, or to bring specs to the latest Zoo template."
---

Follow `.zoo/zoo.md` and file at `$ZOO_LOCAL_MD` if exists

Upgrade spec format only. Do not start the Zoo workflow. Do not implement, review, execute, or change product meaning.

Target: paths the user named; else the current/active spec. Several named paths → each. Ask if the set is ambiguous. Skip `archived/` unless named.

Source of truth: Zoo skill `references/task-file-template.md`. Read it. Follow `references/upgrade.md`.

Do:
- add missing current sections (keep template placeholder text)
- move existing content into the current section that matches its meaning
- rename headings; rearrange to template order
- drop obsolete chrome (`Approval:` field, wrapper `## Spec`, leftover template `<example>`s)
- append one `Log` line: spec upgraded to current Zoo format

Never downgrade status. `done` stays `done`. An approved high-level plan stays approved. `[x]` stays `[x]`. Do not turn approved or executing work back into planning. Do not move listed ready/approved subtasks into Pending suggestions. Do not invent Low-level plan or Subtasks for a spec that never had them.

Report files touched, remaps, status kept, leftovers, asks.
