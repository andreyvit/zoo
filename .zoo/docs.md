## Documentation Destinations

- Internal technical docs go in `_ai/`.
- User manual content for the configuration team and partners goes in `_readme/manual/`.
- API docs content lives in `apidocs/`; viewer code lives in `apidocviewer/`.
- Public API docs should focus on observable API behavior and avoid internal configurator details.
- API docs should prefer "coupons" or "coupon codes" over "discount codes".
- Validate API docs with `make apidocs`; preview with `go run ./cmd/firedocs`.

