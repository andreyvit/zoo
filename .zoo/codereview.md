## Architecture

- `bm/` and `bm/m*/` must not use `fire.Context`; `fdb/` may.
- Shared controller/business logic should be in `fire/core/core*`, not duplicated in highest-level business packages.
- Backoffice shared code belongs in `fire/business/backofficecommons/`; feature code belongs in `fire/business/backoffice/bo*/`.
- For fireback extraction, verify `*RC` became `fire.Context`, unnecessary app parameters were removed, and `ApplyPageLayout` became `ApplyPageLayout: true`.
- Challenge workarounds around `github.com/andreyvit/*` and `github.com/prairiegroupinc/*`; check whether the first-party dependency should have been fixed instead.

## Data and Settings

- Check database `msgpack` tags: top-level IDs `msgpack:"-"`, nested IDs `msgpack:"#"`; most stored structs need `TenantID`.
- Flag unjustified transient `msgpack:"-"` fields on database models.
- Verify tenant ownership checks on data access paths.
- Check write transactions are not held across blocking HTTP calls.
- For settings UI, flag hidden `UICtx` extras, prop-specific callbacks, duplicated raw string-key reads, and register-wrapper/sentinel patterns.
- New settings should update `TenantSettings`, `fireback/shop-settings-common.go`, and relevant test configuration.

## UI, Tests, Docs

- `forms.Select` options belong in enum files; see `_ai/enums.md`.
- Backoffice pages should use `bonav.Define()` unless there is a clear exception.
- Dropdown, popover, disclosure, and select UI should use Tailwind Plus Elements primitives unless the plan approved an exception.
- Tests should live beside the relevant package; `fire/integrationtests/` is only for full-stack HTTP handler cross-feature tests.
- Backoffice page tests must use `ta.Invoke`.
- Tests should not load broad copied production configs from `fire/integrationtests/rendertests/testdata/*.json`; encode relevant fields through `Configure`/`ConfigureTenant`.
- Validation should include `make fmt`, package-level `go test ./path/...`, and `make quicktest` before commit.
- API docs belong in `apidocs/` and validate with `make apidocs`.
- Migration IDs must come from `curl https://app.bubblehouse.com/superadmin/x/newid/`.
