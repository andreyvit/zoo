Focus on duplicated code and effort, both inside the new code, and where new code duplicates existing code.

Check for:
- Duplicated helpers across packages. (These go into fu package or similar.)
- Existing helpers that should have been used.
- Duplicated business logic, decision making or magic constants -- should be exactly ONE place where each business rule is implemented.

Ultrathink!
