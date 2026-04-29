## Architecture

- `bm/` and `bm/m*/` must not use `fire.Context`; `fdb/` may.
- Shared controller/business logic should be in `fire/core/core*`; feature-specific logic belongs in the relevant business package.
- Backoffice shared code belongs in `fire/business/backofficecommons/`; feature code belongs in `fire/business/backoffice/bo*/`.
- For fireback extraction, check `*RC` -> `fire.Context`, app parameters are justified, and `ApplyPageLayout` -> `ApplyPageLayout: true`.
- For `github.com/andreyvit/*` and `github.com/prairiegroupinc/*`, require consideration of fixing the first-party dependency before carrying a workaround.

## Repo-Specific Plan Checks

- Settings changes should cover `TenantSettings`, `fireback/shop-settings-common.go`, translations in `fireback/strings.txt` when relevant, and test configuration through `Configure`.
- Backoffice pages should use `bonav.Define()` unless the plan records a reason not to.
- Dropdown, popover, disclosure, and select work should use Tailwind Plus Elements primitives unless the plan records an exception.
- Tests should read `_readme/tests-and-helpers.md`, live beside the relevant package, and reserve `fire/integrationtests/` for full-stack HTTP handler cross-feature tests.
- Backoffice page tests should use `ta.Invoke`.
- Validation should include `make fmt`, package-level `go test ./path/...`, and `make quicktest` before commit.
- Production config references should be encoded narrowly through `Configure`/`ConfigureTenant`, not loaded wholesale from `fire/integrationtests/rendertests/testdata/*.json`.
- API docs should live in `apidocs/` and validate with `make apidocs`.
- Migration IDs should come from `curl https://app.bubblehouse.com/superadmin/x/newid/`.
