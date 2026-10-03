Agent mistake log: `_ai/MISTAKES.md`. Use `record-agent-mistake` when the user corrects an agent decision. During Zoo Squash, Zoo Rebase, or Zoo Push, skip routine corrections. Log only unusually serious, reusable mistakes and include them in a relevant commit before finalization.

Future cleanups and rollouts log: `.proposals/FUTURE-ROLLOUT.md`

Use `make quicktest` aka `go test -vet=off -short ./...` during development. Use `make uitest` for the Playwright/frontend UI suite. Before final validation, run both in parallel. go test: never pass `-timeout` or `-count=1` unless running one test.
