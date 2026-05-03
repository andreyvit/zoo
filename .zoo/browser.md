## App Harness

- Prefer agent mode for localhost browser work: `go run ./cmd/fireback -agent -fresh <scenario>`.
- Common default scenario: `base`; current production-like scenarios are listed in `_readme/development.md` and registered in `fire/harness/reg-scenarios.go`.
- Agent mode derives the port from `AGENT_INDEX` or the checkout suffix; base port is `3001`, so checkout `back7` uses `http://localhost:3071/`.
- Agent mode creates `super@bubblehouse.com` with password `3141Super` and uses tenant slug `harness-main` for `base`.
- Tunnel mode is plain `go run ./cmd/fireback`; use it only for Shopify App Proxy, OAuth, webhooks, or other externally reachable callbacks.
- Before tunnel mode, run `ps -axo pid,command | grep '[f]ireback'`; if another non-agent fireback is running, stop and ask before replacing it.
- Agent-mode fireback processes from other checkouts are not a conflict.
- Use `_ai/browser-testing.md` for URLs, scenarios, credentials, ports, and process handling.
- Use `_ai/debugging-tools.md` for local or production data inspection while debugging app behavior.

## App-Specific UI

- Verify the relevant web mode: iframe/outside iframe and Shopify/BigCommerce proxy contexts can change behavior.
- Redirect messages often appear through `bh-popup` query parameters; verify the visible message flow.
- In backoffice tests and browser debugging, POST settings forms with `NewAnalyticsArea` may need `toptab=manage`.
- Go code changes require server restart; templates reload at runtime.
- When browser testing exposes a non-styling issue, move debugging into an automated test before iterating further.

## Production Repro

- Production-like browser scenarios load copied render-test JSON only through `fire/harness/prod_repro.go`, which sanitizes production-only secrets and keeps integration HTTP blocked.
- Do not clone integration settings into ordinary local or automated-test setup.
