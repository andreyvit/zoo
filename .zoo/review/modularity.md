Focus on ability to understand and reason about functions and packages in isolation, and ability to see that code is 'obviously correct'.

By now, we hope that every line of code is clear enough. But is the overall code as clear as it can be?

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
- Clear separation of responsibilities across functions in relation to data flow. Can you clearly answer 'which function is responsible for THIS state' and 'why is THIS function touching THAT state, and THAT function touching THIS state?'
- Emergent behavior, something that isn't clearly coded anywhere but is emergent property of the system. This should at least be documented and clearly spec'ed in tests. Ideally, though, all business rules/behaviors are implemented either as clear imperative code, OR clear declarative specifications executed by imperative code.

Ultrathink!
