## Documentation Destinations

- Internal technical notes and future-agent learnings go in `_ai/`.
- Durable developer/onboarding docs go in `_readme/`.
- User manual content for the configuration team and partners goes in `_readme/manual/`; omit internal implementation details and code references.
- Public/client RCAs go in `_readme/rca/`; read that folder's `AGENTS.md` and recent RCAs before writing.
- Client-specific API guides go in `_clientguides/`; never mention source code or internal configuration names.
- API docs content lives in `apidocs/`; viewer code lives in `apidocviewer/`.

## API Docs

- Validate API docs with `make apidocs`; preview with `go run ./cmd/firedocs`.
- Follow `apidocs/AGENTS.md` for JSON paragraph wrapping, shared refs, and renderer behavior.
- File naming: `f-MethodName.json`, `t-TypeName.json`, `te-EnumName.json`.
- Public API docs should focus on observable API behavior and avoid internal configurator details.
- Prefer "coupons" or "coupon codes" over "discount codes".

## Audience Boundaries

- `_ai/` can mention implementation details, package names, and repo-specific lessons.
- `_readme/manual/` is for Bubblehouse configuration and business teams, not merchants or end users; use third-person phrasing such as "the store", "the merchant", and "the customer".
- `_readme/rca/` should stay technically correct while avoiding private company, staffing, client, and infrastructure details.
