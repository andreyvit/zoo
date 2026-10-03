## Documentation Destinations

- Internal technical notes and future-agent learnings go in `_ai/`.
- Durable developer/onboarding docs go in `_readme/`.
- User manual content for the configuration team and partners goes in `_readme/manual/`; omit internal implementation details and code references.
- Public/client RCAs go in `_readme/rca/`; read that folder's `AGENTS.md` and recent RCAs before writing.
- Client-specific integration guides live only in Notion under [Client API Guides](https://app.notion.com/p/3d623a1fd2e180bd8b3ce76391a85e38); use `api-guide` to read and write them. Keep source code and internal configuration names out of client prose.
- API docs content lives in `apidocs/`; viewer code lives in `apidocviewer/`.

## Update Scope

- For infrastructure, release, harness, workflow, and other core changes, consider every durable place that describes the affected behavior before deciding docs are done: root `README.md`, tracked subfolder `README.md` files, `_readme/`, `_ai/`, `.zoo/*.md`, `AGENTS.md`, relevant `.spec/*.md`, and command help text.
- Update only files whose current content becomes inaccurate, incomplete, or misleading because of the change. Do not churn broad docs just because a file mentions a nearby concept.
- Prefer `git ls-files '*README.md'` and targeted `rg` searches over filesystem-wide scans so dependency READMEs and ignored generated docs do not pollute the review.

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
