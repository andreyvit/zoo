Focus on tests and coverage.

Check for:
- Testability, parts of code that are hard to test due to avoidable reasons
- Test coverage. Ideal coverage is 100% for any new or modified code. If we're below, do we have a very good unavoidable reason?
- Tests that are hard to read and can be made easier to understand.
- Tests as a spec: is there a set of tests that very clearly, concisely and comprehensively specifies the behavior of the code, that is so well written it can be used as a spec? If not, we should. We MAY of course have other tests that cover edge cases, variations, etc etc, but we SHOULD always primarily focus on tests that are good specs for the behavior.
- Are names of tests clear and reasonably concise?
- Are NON-notable things inside tests given concise names? (Say widget_frobulates tests should use w or wdgt or not frobulatingWidget. But if it has an unfrobulating widget too, maybe should call them frob and unfrob, or frobw and unfrob, or goodw and badw. No need for frobulatingWidget -- that just repeats the test name and adds noise.)
- Business logic not covered with tests comprehensively.
- Algorithms and computations not covered with tests comprehensively.

Check if we covered:
- Production scenarios (you can see production configs for real usage)
- Legacy data and migration scenarios (if we're introducing something, we often need a test that shows that old data plus new code produces expected behavior and clean migration path)

Ultrathink!
