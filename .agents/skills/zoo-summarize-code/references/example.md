Illustrative output; summarize only changes present in the diff.

### abc1234 — Configure polling intervals

**Packages:**

- Change `wowzie/foo`: configure invoice and catalog polling intervals.
- Add `wowzie/footesting`: `MockFoo` helper with polling options.
- Add `internal/pollingintervals`: `Interval` enum and form options.

**Production code:**

- Add and use interval settings.
  - Add `Settings.InvoiceRecoveryInterval`.
    - In `integration.Build`, pass resolved interval to `AddHook` for `PullOrders1` as `RepeatInterval`.
    - In `integration.BuildConfigurationForm`, add `forms.Select` with `pollingintervals.Options`.
    - Add field `foo.Settings.InvoiceRecoveryInterval` of type `pollingintervals.Interval`.
    - Add `Settings.invoiceRecoveryInterval`: `cmp.Or` field with `defaultInvoiceRecoveryInterval = pollingintervals.Hours12`.
  - Same for `Settings.CatalogInterval`; default `Hours24`, hook `PullCatalog1`.
  - Add enum `pollingintervals.Interval` as `int`.
    - `Unconfigured = 0`; values from `Seconds30` through `Hours24`.
    - `Interval.Duration()` returns corresponding `time.Duration`.
    - SURPRISE `Interval.String()` returns labels such as “24 hours” and “15 minutes”.
    - `pollingintervals.Options` defines `forms.Options`.

**Tests:**

- Add `TestInvoiceRecoveryInterval`: unset interval uses 12 hours; configured value overrides default.
- Add `MockFoo` helper: accepts polling options for integration tests.

**Tooling:**

- Change `cmd/poll-debug/main.go`: print resolved polling intervals.

**Docs:**

- Change `docs/polling.md`: explain interval settings and defaults.
