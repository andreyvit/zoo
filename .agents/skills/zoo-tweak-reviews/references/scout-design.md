# Scout reference design

Scout = repo script that scripts every Zoo review. Prints numbered questions, many pointing at changed `path:line`; reviewer answers each.

Example design for a Go repo. Other language: build scout in that language, adapt everything below.
- Keep: output format, CLI (review skills rely on it), diff slicing, changed-line filter, file-group gates, check kinds, question rules, test format.
- Port mechanics: go/analysis + go/types → the language's parser and type checker (e.g. TypeScript compiler API, Python `ast` + a type checker, Roslyn; tree-sitter when no types). Analysis facts rely on Go's acyclic imports → cross-module summaries with a fixpoint, or a whole-program pass. Test strings → the language's multiline literals; backtick placeholder only if they can't hold backticks.
- Names (`AskGo*`, `VerifyGo*`, `pass`, `Requires`) are Go-flavored; rename to fit.

## Goal

- Holds ALL review questions: plain ones per mode, gated ones only when matching code changed. Skill fallback lists only for repos without scout.
- Moves review knowledge into code: rules checked every gate, no reviewer reminding.
- Never runs agents, never calls LLM, never prints diffs. Deterministic, seconds, tested.

## Command line

`<scout> [-plan|-highlevel-plan] [-uber] [-since <ref>|upstream] [-v] [check names...]`

- Mode; registration asks `IsPlanning()`, `IsHighLevelPlan()`, `IsLowLevelPlan()`, `IsUber()`:
  - none: implementation review (zoo-code-review).
  - `-highlevel-plan` while building high-level plan, `-plan` from low-level plan on: zoo-spec-review. Exclusive.
  - `-uber` + plan flag: zoo-spec-uberreview. `-uber` alone: zoo-final-uberreview.
- Scope: default uncommitted + untracked (skip active task file; binary/huge files path-only). `-since <ref>`: everything since ref. `-since upstream`: all unpushed (`@{upstream}`, else merge-base with origin default branch).
- `-v`: stderr: changed file groups, spots per check. Check names: run only those.
- Output:
  ```
  Answer each item as:
  1. OK <short reason>
  2. NA <short reason>
  3. FAIL <reason>
  Use our question numbers. End with its [check-name] if any. OK = no fix needed, default choice, incl false positives. FAIL = fix needed.

  1. Plain question?
  2. a.go:12 - Violation? message [check]
  3. a.go:40 - Question at spot? [check]
  4. b.go:7 - same q
  ```
  Nothing: exactly `NO QUESTIONS`. Spotless items first, registration order. One check+text grouped, sorted by first `path:line`, later ones `same q`.
- Exit non-zero on errors (git failure, broken build, unknown check). Never print partial list as success.
- Repo's `.zoo/review.md` `Scout:` line documents command, modes, range options.

## Pipeline

Load diff → register checks (gates = plain booleans) → run spot sources → keep spots on changed lines → dedupe, group → print.

Layout: main (flags, mode); core (register, run, filter); output; plain questions; check registration files by kind (text violations, typed-code violations, spot questions); file groups + table test; utils (diff, git, AST/analyzer, shared matchers, test format). Design doc, agent rules, rejected-checks list next to scout.

Wiring:
- Registration funcs take the scout; checks are closures over it: diff, file reader, pushed reader. Tests stub all three. Never call git from inside a check.
- Package load (type-check) only when a non-deleted Go file in some analyzer check's `Files` changed; all analyzers run in one pass.
- Scout's own source holds fixtures that hit its checks: text and prod groups exclude the scout dir.

## Diff slicing

Parse unified diff: `git diff <base>` with wide context (e.g. `-U12`: diff checks see nearby lines like a migration header), untracked files as all-added. Pin format against user git config: `-c diff.noprefix=false -c diff.mnemonicprefix=false --no-color --no-ext-diff`. Model: file {path, old path, deleted, hunks}; hunk {lines: op ` `/`+`/`-`, text, old line, new line}.

Answers only two things:
1. Which file groups changed: `IsModified(globs)`: any changed file (new or old path, deleted included) matches. Cached per list, logged by `-v`. Always false in planning modes: planning has no code changes.
2. Which lines changed: per file, `+` line ranges ("added"), plus deletion anchors: each deletion-only change block anchors to next new-file line ("anchored"), so removing code re-asks nearby spots.

Spot survival:
- Text and analyzer diagnostics: `+` lines only.
- Region spots (node range, e.g. whole func): region overlaps anchored lines.
- Diff-func spots: trusted, built from the diff.

So checks scan whole files but report only on the change: old code never nags. Diagnostic at a decl's name: asks only for new/renamed decls. Region spot: re-asks on any edit inside.

- Change blocks: runs of `-`/`+` between context lines. Same words removed and re-added in one block = formatter realignment, not an edit (e.g. struct tags realigned when a longer field is added).
- Pushed reader: file at pushed ref (`git show <ref>:path`), error = not pushed. Unpushed code changes freely, so e.g. "migration edited in place" asks only if that migration is pushed.

File groups: glob list vars in one file, table-tested:
```go
var (
	goFiles     = []string{"**/*.go"}
	goTestFiles = []string{"**/*_test.go"}
	prodGoFiles = []string{"**/*.go", "!**/*_test.go", "!testkit/**", "!tools/scout/**"}
	// Migrations move Obsolete* fields elsewhere.
	nonMigrationGoFiles = without(prodGoFiles, "db/migrations/**")
)
```
- Globs: `**` spans dirs, `!` excludes, last match wins. Check-specific exception = own group, `without(base, excluded...)`.

## Checks

API:
- `Ask(q)`: plain question, no spot.
- `AskGo(name, files, q, run, tests...)`: q at each spot an analyzer run func finds. `AskGoAnalyzer`: full analyzer (shared, `Requires`, facts).
- `AskDiff(name, files, q, diffFunc, tests...)`: q at each spot from the diff.
- `VerifyGo`, `VerifyGoAnalyzer`, `VerifyText(name, files, content, tests...)`: `Violation? <msg>` per spot.

Rules:
- Order: spec questions under `IsPlanning()`; shared questions (every mode); `if IsUber() { return }`; change questions under `IsModified(anyFiles)`; code questions under `IsModified(anyCodeFiles)`; whole-change invariants (`Holds? <invariant>`) under narrow groups; detailed checks.
- Detailed check: `Files` required = gate. Runs only when `IsModified(Files)`, spots kept in those files. Never gate on mode.
- One call per check, code inline. Check-specific helpers: closures above call. Shared: utils.
- Question: one static line, no location, no check name (pointer and printer add them). Violation messages static, so repeats group: never repeat what the pointer or its line shows (file name, value on that line); add only what they don't (another line, decoded value, the fix).
- Precise spot sources first, broad last. Plain question only if every review of that mode should ask it; never restate a gated one.
- Disabled check: `if false { // Disabled: why }`.
- No suppression comments. False positive: reviewer answers OK with why; recurring ones fixed in check code: narrower matcher, file exclusion, recognized idiom, changed fields only (skip realigned lines), pushed-state check. Rejected check ideas: list next to scout.

Examples:

```go
if sc.IsPlanning() {
	sc.Ask("Does the plan cover legacy data and rollback?")
}
if sc.IsModified(permissionDefFiles) {
	sc.Ask("Holds? A new permission sits in the lowest correct role.")
}

// Text violation.
sc.VerifyText("no-secrets", secretsFiles,
	func(f *File, report func(line int, msg string)) {
		eachLine(f.Body, func(n int, line string) {
			if privateKeyRE.MatchString(line) {
				report(n, "file contains a likely secret")
			}
		})
	},
	`
		-- deploy/keys.pem --
		-----BEGIN PRIVATE KEY-----
		===
		deploy/keys.pem:1 - file contains a likely secret
	`,
)

// AST question: match by resolved callee, not by text.
sc.AskGo("no-debug-print", prodGoFiles,
	"Review the stdout print. Production code logs through the logger. FAIL if this is leftover debug output.",
	spotNodes(func(pass *analysis.Pass, file *ast.File, n ast.Node) bool {
		call, ok := n.(*ast.CallExpr)
		return ok && calleeFullName(pass, call) == "fmt.Println"
	}),
	`
		-- app/orders/x.go --
		package orders

		import "fmt"

		func f() {
			fmt.Println("debug")
		}
		===
		app/orders/x.go:6
	`,
)

// Typed violation: field selections only, compat funcs exempt.
compatFuncRE := regexp.MustCompile(`[mM]igrat|[lL]egacy|[cC]ompat([^i]|$)`)
sc.VerifyGo("obsolete-field-access", nonMigrationGoFiles,
	func(pass *analysis.Pass) (any, error) {
		for _, file := range pass.Files {
			for _, decl := range file.Decls {
				if fn, ok := decl.(*ast.FuncDecl); ok && compatFuncRE.MatchString(fn.Name.Name) {
					continue
				}
				ast.Inspect(decl, func(n ast.Node) bool {
					sel, ok := n.(*ast.SelectorExpr)
					if ok && strings.HasPrefix(sel.Sel.Name, "Obsolete") && isFieldSelection(pass, sel) {
						pass.Reportf(sel.Pos(), "Obsolete* fields are only for migration and compat code")
					}
					return true
				})
			}
		}
		return nil, nil
	},
	`
		-- app/obsolete/order.go --
		package obsolete

		type Order struct{ ObsoleteTotal, Total int }

		func total(o *Order) int { return o.ObsoleteTotal }

		func migrateLegacyTotal(o *Order) { o.Total = o.ObsoleteTotal }
		===
		app/obsolete/order.go:5 - Obsolete* fields are only for migration and compat code
	`,
)

// Diff question: removed lines, which the new file cannot show. Skips
// unpushed files and lines a formatter only realigned.
sc.AskDiff("stored-field-removed", modelFiles,
	"Review the removed stored field. FAIL if old records no longer decode.",
	func(d *Diff) []*Spot {
		var spots []*Spot
		for _, f := range d.Files {
			if _, err := sc.readPushedFile(cmp.Or(f.OldPath, f.Path)); err != nil {
				continue
			}
			for _, h := range f.Hunks {
				for _, block := range changeBlocks(h) {
					for _, l := range block {
						if l.Op == '-' && storedFieldRE.MatchString(l.Text) && !readded(block, l) {
							spots = append(spots, &Spot{File: f.Path, Line: max(l.NewLine, 1)})
						}
					}
				}
			}
		}
		return spots
	},
	`
		-- app/model/customer.go (diff) --
		 type Customer struct {
		-	Points int ‵msgpack:"p"‵
		 	Email string ‵msgpack:"e"‵
		 }
		===
		app/model/customer.go:2
	`,
	`
		-- app/model/customer.go (diff) --
		 type Customer struct {
		-	Points int ‵msgpack:"p"‵
		 	Email string ‵msgpack:"e"‵
		 }
		-- app/model/customer.go (pushed) --
	`,
	`
		-- app/model/customer.go (diff) --
		 type Customer struct {
		-	Points int ‵msgpack:"p"‵
		+	Points      int    ‵msgpack:"p"‵
		+	LoyaltyTier string ‵msgpack:"lt"‵
		 }
	`,
)
```

## Spot sources

- Builders: `spotNodes(match)`/`spotComments(match)` (region spots from AST), `DiffMatch{Added, Removed, Changed}`, added-line and changed-hunk spots, `changeBlocks`, `readded(block, line)` (same words back as `+` in block), `eachLine`, `calleeFullName`.
- Text: scan lines of changed files in group. Line 0 = whole file, moved to first changed line. Cheap; for patterns syntax cannot hide (keys, URLs, config).
- AST + types: go/analysis over whole type-checked repo (all syntax incl. tests; broken build fails run). Run func walks `pass.Files` (`ast.Inspect`); `pass.TypesInfo` resolves types, callees, selections, generic instances. Match semantics, not names: callee full name, receiver/arg types, field vs method, enclosing func.
  - Diagnostic (`pass.Reportf`): spot at position, `+` lines only.
  - Spots result: spot with region; re-asked on any change inside.
  - One analyzer serves several checks: diagnostic category names the check.
- Cross-package: analysis facts. Export per func (e.g. which tables it reads/writes), import from dependencies (import order, no cycles). In-package: fixpoint over local calls (cycles). Generic data-access library funcs export no facts: call site's type args decide. Func referenced as value counts as called.
- Analyzer code may read the diff too (e.g. skip a realigned line).
- Diff: hunks directly: removed lines, edited blocks, added headers.
- Other files: sibling file (e.g. clone code that must name each settings field), or pushed version.

## Tests

Trailing indented strings next to each check, parsed at registration, run through real pipeline (gating, changed-line filter):

```
-- path --           added file
-- path (diff) --    lines prefixed ' ', '+', '-'
-- path (pushed) --  file at pushed point; empty = not pushed
===
path:line            question spot
path:line - message  violation, prefix omitted
```

- Dedent by first line's indent. Placeholder char for backticks. No `===`: no items. File line exactly `===`: `(diff)` section as `+===`.
- Default pushed state: `(diff)` file's old side; added file not pushed.
- Analyzer tests: fixtures type-checked in one load against stubs of repo and dependency packages. Each test owns its package dirs. Stubs mirror real call shapes: empty stub bodies hide transitive behavior.
- Every check: at least one hit (enforced by a test), likely false positives, likely false negatives. Fixture that fails to type-check fails its test. No tests asserting only shape or question text.
- File groups: table test through `IsModified`.
