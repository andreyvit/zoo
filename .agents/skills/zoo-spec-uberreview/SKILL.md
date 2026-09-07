---
name: zoo-spec-uberreview
description: "Cross-agent spec review: zoo-spec-review plus run same questions in other agents via CLI. Use only when explicitly requested."
---

Follow `.zoo/zoo.md`, `.zoo/planning.md`, `.zoo/planreview.md` if exists.

Load zoo-spec-review skill and follow it in full; its subagent review covers your own harness. In addition, run the same prompt in the CLIs of the other harnesses, then act on the combined findings (subagent + CLIs) as that skill says. Do not start impl/full workflow.

Agents:
1. Identify your own harness (Claude Code, Codex, Grok, OpenCode). Never call its CLI: the zoo-spec-review subagent already covers it.
2. Agent list, first that applies: list given by the user; `ZOO_UBERREVIEW_AGENTS` env var (comma/space separated CLI names, e.g. `ZOO_UBERREVIEW_AGENTS="codex grok claude"`); per-user instructions you already loaded (user-level agent config or a repo per-user file) naming uber-review agents; else autodetect which of `claude`, `codex`, `grok` are in PATH. Drop your own harness from the list.
3. macOS fallback when `codex` is not in PATH: `/Applications/ChatGPT.app/Contents/Resources/codex`. If PATH `codex` is a ChatGPT.app symlink, `codex-code-mode-host` must be a sibling symlink or tool calls fail closed.
4. Nothing left: say so; zoo-spec-review alone is the result.

Run:
- Write the questions file per zoo-spec-review (temp markdown file outside the repo). `PROMPT` = the zoo-spec-review prompt with paths filled in (assign with single quotes); same prompt as the subagent gets.
- Run every CLI in parallel with the subagent, from the repo root. Read findings from command stdout. One-shot prompt mode, yolo permissions, no stored sessions where the CLI supports that. The prompt forbids changes; do not use special review modes (`codex exec review`, `claude ultrareview`). Reviews take minutes: run in background shells, wait, never kill early.
- Strongest model, `max` effort (`xhigh` where `max` does not exist). OpenCode's requested pin is Gemini 3.8 Flash at `max`. Pins below are current as of 2026-09; if a CLI rejects a model or effort, pick the newest from `claude --help`, `codex exec --help` + `~/.codex/models_cache.json`, `grok models`, or `opencode models google`.
- claude: `claude -p --no-session-persistence --dangerously-skip-permissions --model fable --effort max "$PROMPT"`
- codex: `codex exec --ephemeral --dangerously-bypass-approvals-and-sandbox -m gpt-5.6-sol -c 'model_reasoning_effort="max"' "$PROMPT"` (stdout is a human event stream; the last `codex` block is the findings. `--json` if you want JSONL events. `ultra` adds auto-delegation, not needed)
- grok: `grok -p "$PROMPT" --yolo -m grok-4.6 --reasoning-effort xhigh` (no no-persist flag; the session stays)
- opencode with Gemini: `opencode run --auto --model google/gemini-3.8-flash --variant max "$PROMPT"` (default stdout is an event stream; the final assistant response is the findings; only use when explicitly requested)
- Recognize when agent out of tokens / requires re-authentication / other failure. MUST show failure to user, skip that agent by default, continue; if user says resolved, rerun that agent only.
- Note agents and results (N findings recorded, K skipped / specific error) in single spec log row, MUST show summary to user.

Combine: merge subagent and CLI findings; dedupe; keep which agents raised each; verify every finding against code (external agents share none of your context and can be wrong). Then act per zoo-spec-review: fix, Pending suggestions, ask user, false positives. Log `Spec uber-review (<agents>): ...` in `## Log`. Loop per zoo-spec-review.
