## Product and Sources

- Bubblehouse is a loyalty platform for points, tiers, order earning, redemptions, subscription rewards, and related loyalty flows.
- When planning a change from one tenant's requirements, check how it affects other tenants and whether any tenant relies on present behavior. Do not flip a shared mapping, default, or importer rule for Native Path (or any one tenant) without a per-tenant setting or an explicit grandfather list.
- Shopify is native; Magento, WooCommerce, BigCommerce, HubSpot, Klaviyo, and custom systems integrate through APIs or integration packages.
- Linear issue context: `linearis issues read DEV-1499`; image embeds: `linearis embeds download <url> --output <path>`. See `_ai/linear.md`.
- Production reference configs live in `fire/integrationtests/rendertests/testdata/*.json`.
- Ordinary tests should inspect those configs, then encode only relevant fields through `Configure` and `ConfigureTenant`.

## Architecture

- Production is single-process and single-active-node. `bh301` is standby and its database is overwritten from the primary every few hours; do not model normal deploys as active-active or as old/new workers concurrently consuming the same production job queue.
- Job workers are goroutines in the active process. Deployment plans should reason about single-process restart, pending jobs, durable data compatibility, external callbacks, rollback, failover, and rebuild paths; only include multi-node mixed-version analysis when the task explicitly involves failover or confirmed concurrent serving.
- First-party dependencies under `github.com/andreyvit/*` are editable when all call sites are updated; repo/path source of truth is `automation/deps/deps.go`.
- Local dependency iteration: `go run ./cmd/fireman deps-replace` and `go run ./cmd/fireman deps-dropreplace`.
- `bm/` and `bm/m*/` must not use `fire.Context`; `fdb/` may.
- Shared controller/business logic belongs in `fire/core/core*`.
- Feature-specific business logic belongs in `fire/business/fire*` or the relevant feature package.
- Backoffice shared code belongs in `fire/business/backofficecommons/`; feature code belongs in `fire/business/backoffice/bo*/`.
- Fireback extraction usually means `*RC` -> `fire.Context`, `*App` -> `fire.App` only when needed, and `ApplyPageLayout` -> `ApplyPageLayout: true`.

## Settings, UI, Docs

- Schema-backed settings should keep prop initializers direct; if needed, attach UI behavior later with `Prop.SetupUIUpdater(...)`.
- New settings need `TenantSettings`, UI in `fireback/shop-settings-common.go`, and test configuration through `Configure` when needed.
- Translatable strings live in `fireback/strings.txt`.
- Specs for customer-visible frontend UI states must include theme/block styling support; customer-visible strings must be translatable.
- Backoffice pages should register through `bonav.Define()`; see `_ai/backoffice.md`.
- Dropdown, popover, disclosure, and select work should use Tailwind Plus Elements primitives.
- API docs content lives in `apidocs/`; viewer code lives in `apidocviewer/`; validate with `make apidocs`; preview with `go run ./cmd/firedocs`.
- Internal technical docs go in `_ai/`; user manual content goes in `_readme/manual/`.
- API docs should prefer "coupons" or "coupon codes" over "discount codes".
- If a setting must default to an insane / undesirably inconsistent value to maintain compatibility, but we'd like to move new stores to a saner default in the future; or if adding a behavior that defaults off but should default on in the future; or in similar situations -- add it to .proposals/FUTURE-ROLLOUT.md so that we don't forget.

## Domain-Specific Planning

- `CustomerStatsDaily` is deprecated.
- With `Processor`, stats should be looked up through `fdb.CustomerStatSchema.LookupOverall`; outside Processor, use `LoadOverall`.
- Prefer recording `CustomerChange` or older change records and letting record methods update stats.
- Migration IDs in `fireback/schema-migrations.go` must come from `curl https://app.bubblehouse.com/superadmin/x/newid/`.
