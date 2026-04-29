## App Harness

- Agent harness command: `go run ./cmd/fireback -agent -fresh <scenario>`.
- Tunnel mode command for Shopify App Proxy, OAuth, webhooks, or other externally reachable callbacks: `go run ./cmd/fireback`.
- Before tunnel mode, run `ps -axo pid,command | grep '[f]ireback'`; if another non-agent fireback is running, stop and ask before replacing it.
- Agent-mode fireback processes from other checkouts are not a conflict.
- Use tunnel/external-callback mode only when the flow requires a real external callback.
- Use `_ai/browser-testing.md` for URLs, scenarios, credentials, ports, and process handling.
- Use `_ai/debugging-tools.md` for local or production data inspection while debugging app behavior.

## App-Specific UI

- Dropdown, popover, disclosure, and select work should use Tailwind Plus Elements primitives: `el-dropdown`, `el-menu`, `el-popover`, `el-disclosure`, `el-select`.
- Verify the relevant web mode: iframe/outside iframe and Shopify/BigCommerce proxy contexts can change behavior.
- Redirect messages often appear through `bh-popup` query parameters; verify the visible message flow.

## Production Repro

- Production-like browser scenarios are registered in `fire/harness/reg-scenarios.go`.
- Production JSON copies live in `fire/integrationtests/rendertests/testdata/*.json` and must be loaded only through the sanitizing path in `fire/harness/prod_repro.go`.
