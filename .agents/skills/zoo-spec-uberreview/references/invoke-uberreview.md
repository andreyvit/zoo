Run the caller's PROMPT in other harness CLIs. Do not start the Zoo workflow. Do not call the current harness's CLI.

Agents:
1. Identify own harness (Claude Code, Codex, Grok, OpenCode). Never call its CLI.
2. Agent list, first that applies: list given by the user; `ZOO_UBERREVIEW_AGENTS` env var (comma/space separated CLI names, e.g. `ZOO_UBERREVIEW_AGENTS="codex grok claude"`); per-user instructions already loaded naming uber-review agents; else autodetect which of `claude`, `codex`, `grok` are in PATH. Drop own harness from the list.
3. macOS fallback when `codex` is not in PATH: `/Applications/ChatGPT.app/Contents/Resources/codex`. If PATH `codex` is a ChatGPT.app symlink, `codex-code-mode-host` must be a sibling symlink or tool calls fail closed.
4. OpenCode only when named by the user, `ZOO_UBERREVIEW_AGENTS`, or per-user instructions.
5. Nothing left: say so; caller uses own-harness result only.

Run:
- Assign PROMPT with single quotes. From the repo root. One-shot prompt mode, yolo permissions, no stored sessions where the CLI supports that. The prompt forbids changes; do not use special review modes (`codex exec review`, `claude ultrareview`). Reviews take minutes: run in background shells, wait, never kill early.
- Strongest model, `max` effort (`xhigh` where `max` does not exist). Codex: `gpt-6-astra` at `xhigh`. OpenCode: Gemini 3.8 Flash at `max`. Pins below current as of 2026-09; if a CLI rejects a model or effort, pick the newest from `claude --help`, `codex exec --help` + `~/.codex/models_cache.json`, `grok models`, or `opencode models google`.
- claude: `claude -p --no-session-persistence --dangerously-skip-permissions --model fable --effort max "$PROMPT"`
- codex: `codex exec --ephemeral --dangerously-bypass-approvals-and-sandbox -m gpt-6-astra -c 'model_reasoning_effort="xhigh"' "$PROMPT"` (stdout is a human event stream; the last `codex` block is the findings. `--json` if you want JSONL events. `ultra` adds auto-delegation, not needed)
- grok: `grok -p "$PROMPT" --yolo -m grok-4.6 --reasoning-effort xhigh` (no no-persist flag; the session stays)
- opencode with Gemini: `opencode run --auto --model google/gemini-3.8-flash --variant max "$PROMPT"` (default stdout is an event stream; the final assistant response is the findings)
- Read findings from command stdout. Codex's last `codex` block and OpenCode's final assistant response are the findings. Omit OpenCode `--thinking` and `--print-logs`.
- Agent out of tokens / requires re-authentication / other failure: show failure to the user, skip that agent by default, continue; if the user says resolved, rerun that agent only.
- Return per-agent findings to the caller.

`code_mode_host` is the bundled Codex tool runner (stable, on). The host binary lives next to `codex` in ChatGPT.app. A PATH symlink of `codex` alone makes tools look for `codex-code-mode-host` beside the symlink and fail closed; chat still works. Symlink the host next to PATH `codex`. `--disable code_mode_host` does not fall back to a normal shell.
