If rebase reports that local `go.mod` changes would be overwritten, run `go run ./cmd/fireman deps-dropreplace` and retry. `deps-replace` marks `go.mod` assume-unchanged, so stash may not capture it.

Do NOT run the scout during rebase/push flows.
