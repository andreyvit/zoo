Focus on debuggability and observability. We were smart enough to build this; will we be smart enough to debug it, investigate reported issues and validate/spot-check for correctness in production?

Check for ability to:
- preview major changes and migrations before they happen, if the result is not simple and 100% predictable.
- deploy gradually and roll back easily if problems arise.
- verify that code is behaving correctly in production, and to notice irregularities (via fault reporting, metrics, logging)
- limit impact of failures (in terms of data affected, features/blocks/pages affected,customers affected, tenants affected, and app not crashing in general)
- avoid data loss/corruption
- ability to recover data from invalid changes
- avoid catastrophic failures (e.g. crash-restart loops)

Imagine we deploy to production and things fail. Consider how we will:
- find that out?
- figure out the impact?
- disable or roll back changes?
- gather enough data to figure out the cause?
- re-enable after fixes (consider the data states that will be produced)

Some of the changes you need are beyond simple refactorings; feel free to propose larger improvements, projects or sweeping changes, with [user approval needed] marker, and also try to propose smaller changes as alternatives.

Ultrathink!
