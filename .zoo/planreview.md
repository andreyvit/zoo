## Architecture Checks

- Enforce package boundaries: `bm/` and `bm/m*/` cannot use `fire.Context`; `fdb/` may; shared business logic belongs in `fire/core/core*`.
- Backoffice shared code belongs in `fire/business/backofficecommons/`; feature code belongs in `fire/business/backoffice/bo*/`.
- For fireback extraction, check `*RC` -> `fire.Context`, app parameters are justified, and `ApplyPageLayout` became `ApplyPageLayout: true`.
- For `github.com/andreyvit/*` dependencies, require consideration of fixing the first-party dependency before carrying a workaround locally.
- Reject plans that put aggregation, derivation, or business decisions in presentation-only code when the result should be testable/exportable without rendering.

## Repo-Specific Plan Checks

- Settings changes should cover `TenantSettings`, runtime/default behavior, UI in `fireback/shop-settings-common.go` or schema props, translations in `fireback/strings.txt` when relevant, and test configuration through `Configure`.
- Schema-backed settings props should stay as direct `mconf.NewProp(...)` initializers where possible; init-cycle fixes should use narrow setters like `Prop.SetupUIUpdater(...)`.
- Backoffice plans should mention `bonav.Define()` route/nav registration or document why direct route registration is needed.
- Tests should read `_readme/tests-and-helpers.md`, live beside the relevant package, and reserve `fire/integrationtests/` for full-stack HTTP handler cross-feature tests.
- Backoffice page tests should use `ta.Invoke`; direct handler calls do not render HTML.
- Validation should include `make fmt`, full package-level `go test ./path/...` without `-short`/`-vet=off`, and `make quicktest` before commit.
- Production config references should be encoded narrowly through `Configure`/`ConfigureTenant`, not loaded wholesale from copied JSON.
- API docs should live in `apidocs/` and validate with `make apidocs`.
- Migration IDs should come from `curl https://app.bubblehouse.com/superadmin/x/newid/`.
