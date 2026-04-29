## Product and Sources

- Bubblehouse is a loyalty platform for points, tiers, order earning, redemptions, subscription rewards, and related loyalty flows.
- Shopify is native; Magento, WooCommerce, and custom systems integrate through APIs.
- Linear issue context: `linearis issues read DEV-1499`; image embeds: `linearis embeds download <url> --output <path>`. See `_ai/linear.md`.
- Production reference configs live in `fire/integrationtests/rendertests/testdata/*.json`.
- Ordinary tests should inspect those configs, then encode only relevant fields through `Configure` and `ConfigureTenant`.

## Architecture

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
- Backoffice pages should register through `bonav.Define()`; see `_ai/backoffice.md`.
- Dropdown, popover, disclosure, and select work should use Tailwind Plus Elements primitives.
- API docs content lives in `apidocs/`; viewer code lives in `apidocviewer/`; validate with `make apidocs`; preview with `go run ./cmd/firedocs`.
- Internal technical docs go in `_ai/`; user manual content goes in `_readme/manual/`.
- API docs should prefer "coupons" or "coupon codes" over "discount codes".

## Domain-Specific Planning

- `CustomerStatsDaily` is deprecated.
- With `Processor`, stats should be looked up through `fdb.CustomerStatSchema.LookupOverall`; outside Processor, use `LoadOverall`.
- Prefer recording `CustomerChange` or older change records and letting record methods update stats.
- Migration IDs in `fireback/schema-migrations.go` must come from `curl https://app.bubblehouse.com/superadmin/x/newid/`.
