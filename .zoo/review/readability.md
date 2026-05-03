Focus on ability to read and understand the code.

By now, I hope that every line of code is clear enough. But is the overall code clear?

Check for:
- Murky states that can be simplified / split / separated / made clearer in other way.
- Extract helpers that make code easier to read, following the ladder of abstraction.
- Clear roles of all data and state, separation of old and new state
- Clear data flows with no murky 'this value could be modified in 10 different places before reaching this code'
- Edge cases must be clear and outstanding
- If an edge case does not need to be handled separately, it should not
- Simplify function signatures where possible
- Avoid mixing of different types of code (algorithmic, glue, integration aka API use, business) in substantial quantities
- Refactorings that reduce mutability or concentrate mutations (separate mutation from computation)
- Overabstracted functions that don't do much themselves and whose effect is unclear due to excessive delegation
- Repeating core business logic in multiple places

Ultrathink!
