Pass current task path and revision round to research agents; preserve this association on resume without emitting task start/resume/switch receipts.

- launch 1–6 parallel zoo-researcher subagents with specific research areas
- write research file from findings
- for follow-up research, point agents at existing research file so they return only new info
- quote enough code that later steps avoid rereading most involved files
