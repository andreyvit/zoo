Include task path and revision round in PROMPT, with instructions to emit `Zoo review session (<spec path>) rN` as a standalone chat line (unknown round: r?; no task: `(no spec) r?`). Preserve review ownership and historical receipts in compaction summaries; never emit task start/resume/switch receipts.

Pass file paths and the reviewed Git range, not full file contents or diffs; reviewers read them from the repository.

Run the caller's PROMPT in other harness CLIs. Do not start the Zoo workflow. Do not call the current harness's CLI.

Agents:
1. Identify own harness (Claude Code, Codex, Grok, OpenCode). Never call its CLI.
2. Agent list, first that applies: list given by the user; uber-review agents named in `$ZOO_LOCAL_MD`; per-user instructions already loaded naming uber-review agents; else autodetect which of `claude`, `codex`, `grok` are in PATH. Resolve this list before launching any reviewer. Own harness gets a subagent only if listed; remove it from the CLI list.
3. macOS fallback when `codex` is not in PATH: `/Applications/ChatGPT.app/Contents/Resources/codex`. If PATH `codex` is a ChatGPT.app symlink, `codex-code-mode-host` must be a sibling symlink or tool calls fail closed.
4. OpenCode reviewers are opt-in: Gemini, GLM, and DeepSeek only when individually named by the user/instructions.. A request for Gemini, GLM or DeepSeek selects that model through OpenCode; it does not add the other OpenCode models. Run each requested model separately and label findings by model.
5. No CLI reviewers left: use the listed own-harness subagent only. No selected reviewers: report that; do not add self as a fallback.

Run:
- Assign PROMPT with single quotes. From the repo root. One-shot prompt mode, yolo permissions, no stored sessions where the CLI supports that. The prompt forbids changes; do not use special review modes (`codex exec review`, `claude ultrareview`). Reviews take minutes: run in background shells, wait, never kill early.
- Use these model/effort pins: Claude Opus 5.5, Grok 4.7, and Codex `gpt-6-astra` at `xhigh`; OpenCode Gemini 3.8 Flash, GLM-5.3, and DeepSeek V4 Pro at `max`. Pins below current as of 2026-09; if a CLI rejects a model or effort, pick the newest from `claude --help`, `codex exec --help` + `~/.codex/models_cache.json`, `grok models`, or `opencode models <provider> --verbose` (`google`, `zai`, `deepseek`; includes supported variants). Keep replacements within the requested model family.
- claude: `claude -p --no-session-persistence --dangerously-skip-permissions --model claude-opus-5-5 --effort xhigh "$PROMPT"`
- codex: `codex exec --ephemeral --dangerously-bypass-approvals-and-sandbox -m gpt-6-astra -c 'model_reasoning_effort="xhigh"' "$PROMPT"` (stdout is a human event stream; the last `codex` block is the findings. `--json` if you want JSONL events. `ultra` adds auto-delegation, not needed)
- grok: `grok -p "$PROMPT" --yolo -m grok-4.7 --reasoning-effort xhigh` (full 4.7 review model, verified via `grok models` on 2026-09-30; use `grok-4.7-build-fast` only when requested; no no-persist flag, so the session stays)
- opencode with Gemini: `opencode run --auto --model google/gemini-3.8-flash --variant max "$PROMPT"` (default stdout is an event stream; the final assistant response is the findings)
- opencode with GLM (direct API): `opencode run --auto --model zai/glm-5.3 --variant max "$PROMPT"`
- opencode with DeepSeek (direct API): `opencode run --auto --model deepseek/deepseek-v4-pro --variant max "$PROMPT"`
- GLM Coding Plan: use the connected **Z.AI Coding Plan** provider's `glm-5.3` ID from `opencode models`, with `max` confirmed by `--verbose`. Do not silently use the paid `zai` API route when the user requested subscription billing. If unavailable, report the missing provider/model.
- Read findings from command stdout. Codex's last `codex` block and OpenCode's final assistant response are the findings. Omit OpenCode `--thinking` and `--print-logs`.
- Agent out of tokens / requires re-authentication / other failure: show failure to the user, skip that agent by default, continue; if the user says resolved, rerun that agent only.
- Return per-agent findings to the caller.

`code_mode_host` is the bundled Codex tool runner (stable, on). The host binary lives next to `codex` in ChatGPT.app. A PATH symlink of `codex` alone makes tools look for `codex-code-mode-host` beside the symlink and fail closed; chat still works. Symlink the host next to PATH `codex`. `--disable code_mode_host` does not fall back to a normal shell.
