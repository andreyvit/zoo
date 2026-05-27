## Code Conventions

- See `_ai/enums.md` for enum conventions; `forms.Select` options belong in enum files, not inline UI code.
- Production code should use enum semantic methods, such as `status.IsPending()`, instead of direct equality checks.
- Prefer `reg-*.go` files for registration patterns, such as API calls in `reg-apicalls.go`.
- Use stdlib `slices`/`maps`, built-in `min`/`max`, `cmp.Or`, and `optional.ValueOrZero`.
- Pass larger structs by pointer; if a struct is larger than roughly three `int64` fields, functions and methods should take `*T` unless value-copy semantics are intentional.
- IDs are `bubbleflake.ID`; `mcom` aliases document domain-specific ID meanings.
- Name behaviors and general feature flags after the product behavior, not the first integration that implements it. Integration-specific jobs, clients, and API calls may name the integration when they only apply there.

## Domain Objects

- Resolve IDs, API names, and form params into real domain objects at the edge, then pass the domain object through core code.
- Do not introduce `Resolved*`, `*Target`, `*Ref`, or similar wrapper types when they only copy fields from an existing model struct. If behavior branches on fields already present on the model, pass the model.
- If code constructs a partial model such as `&mentities.EntitySet{ID: id}` just to satisfy a function, fix that caller to load the actual model or change the function to accept the ID at that boundary. Do not add a wrapper to make partial structs seem valid.
- Before adding a wrapper around an existing model type, grep for partial constructors and stale call patterns first. The default fix is to remove the partial callers, not to normalize around them.

## Renames and Compatibility

- When renaming an internal symbol, update all callers in the same change. Do not leave compatibility aliases such as `OldName = NewName` for ordinary internal code.
- Compatibility shims need an actual external or persisted compatibility boundary, a clear removal plan, and a comment explaining that boundary. Convenience for avoiding call-site updates is not a valid boundary.
- If a renamed symbol now has narrower semantics, make every caller choose the explicit new name that matches its behavior. For example, callers should say whether they mean a primary-set index or a secondary-set index instead of going through a generic alias.

## Dependencies and Packages

- First-party dependencies under `github.com/andreyvit/*` are editable when all call sites are updated.
- Dependency repo/path source of truth: `automation/deps/deps.go`.
- Local dependency iteration: `go run ./cmd/fireman deps-replace` and `go run ./cmd/fireman deps-dropreplace`.
- `bm/` and `bm/m*/` must not use `fire.Context`.
- `fdb/` may use `fire.Context`.
- Shared controller-level logic belongs in `fire/core/core*`.
- Shared business logic belongs in core, not highest-level business packages.
- Feature-specific business logic belongs in `fire/business/fire*` or the relevant feature package.
- Backoffice shared code belongs in `fire/business/backofficecommons/`; individual backoffice features belong in `fire/business/backoffice/bo*/`.

## Fireback Extraction

- Replace `*RC` with `fire.Context`.
- Replace `*App` with `fire.App` only when app access is still needed; prefer `rc.FireApp()` when an RC/context is available.
- Former `*App` methods taking `rc *RC` often should become freestanding functions and drop the app parameter.
- Replace `ApplyPageLayout` calls with `ApplyPageLayout: true` on `ViewData`.

## Database

- Stored structs need `msgpack` tags; top-level IDs use `msgpack:"-"`, nested IDs use `msgpack:"#"`; most stored structs need `TenantID`.
- Use `omitempty` for fields that can be zero, especially times.
- Avoid transient `msgpack:"-"` fields in database models unless strongly justified.
- Writes go through `rc.MustWrite(...)`; keep write transactions short and never hold them across blocking HTTP calls.
- In tests, prefer `edb.Get[T](ta, id)` over `edb.Get[T](ta.RC(), id)`.
- Use `edb.Reload` with the existing pointer and assign it back: `customer = edb.Reload(ta, customer)`.
- Verify tenant ownership with `fdb`/`load` helpers; add helpers when needed.

## Settings and Web

- Schema-backed settings props should stay as direct `var X = mconf.NewProp(...)` initializers when possible.
- If an init cycle appears, keep the prop initializer and attach UI behavior later with a narrow setter such as `Prop.SetupUIUpdater(...)`.
- Do not add hidden extras on `UICtx`, prop-specific callbacks, prop-name string constants, duplicated raw string-key reads, or register-wrapper sentinels to work around settings plumbing.
- New settings need `TenantSettings`, UI in `fireback/shop-settings-common.go`, and test configuration through `Configure` when needed.
- Translatable strings live in `fireback/strings.txt`.
- Backoffice pages should register through `bonav.Define()`; see `_ai/backoffice.md`.
- Dropdown, popover, disclosure, and select work should use Tailwind Plus Elements primitives.

## Docs, Money, Stats, Migrations

- API docs content lives in `apidocs/`; viewer code lives in `apidocviewer/`; validate with `make apidocs`; preview with `go run ./cmd/firedocs`.
- Internal technical docs go in `_ai/`; user manual content goes in `_readme/manual/`.
- API docs should prefer "coupons" or "coupon codes" over "discount codes".
- `monetary.Invalid` marks empty/invalid monetary input; zero is a valid amount.
- JavaScript-to-Go monetary values must be strings using `.toFixed(6)`.
- Apply multipliers to monetary amounts before converting to points.
- `CustomerStatsDaily` is deprecated; prefer change records and let record methods update stats.
- With `Processor`, use `fdb.CustomerStatSchema.LookupOverall`; outside Processor, use `LoadOverall`.
- Migration IDs in `fireback/schema-migrations.go` must come from `curl https://app.bubblehouse.com/superadmin/x/newid/`.
