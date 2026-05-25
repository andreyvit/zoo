Please explore existing implementation and document in _ai/:
$ARGUMENTS

1. Find and read ALL the relevant files.
2. Find and read the relevant tests.
3. Figure out the big picture.
4. Anything sticks out as surprising, unusual or particularly important detail in our implementation? Figure out all the details.
5. What do you think the likely future changes in this area will be? E.g.: more integrations of the same kind, more kinds of rewards/conditions/objects, customization options?
6. What would be the gotchas and challenges those future implementors will encounter? Any tips from the code you can give to help them?

We want to write docs in CLAUDE.md single-line facts style, without code blocks if at all possible. AI will be able to read the code, so focus on providing code pointers to base future research on, no need for elaborate examples.

Most values parts of docs:

- high-level details
- gotchas, brief facts on overcoming stumbling blocks
- common pitfalls (and what to do about it)
- code pointers to read
- brief summary of the info that's hard to find
- facts on how parts of the system interact
- brief facts that are hard to quickly grasp from code

We prefer files in _ai/ to be one file per large functional area, e.g. integrations.md, forms.md, etc.

Ultrathink: what's the best way to structure the docs?

Write the docs.
