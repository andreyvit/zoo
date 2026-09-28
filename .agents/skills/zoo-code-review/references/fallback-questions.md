Fallback code review questions, only for repos without a scout. Add legacy question sections of `.zoo/review.md` matching implemented code, if any (zoo-tweak-reviews moves them into a scout).

1. Is there a way to simplify this code while still meeting requirements?
2. Is there a large chunk of code, function, class, module, or package that is not obviously correct at a glance in isolation? If so, is there a way to rewrite it much more clearly?
3. Is there a business rule that is not implemented in one place, and is instead an emergent property of multiple spread-out parts? If so, is there a way to concentrate it?
4. Is there premature pessimization in code that might process many items, where a clearly cheaper algorithm or much lower memory, fewer allocations, or less boxing/copying would not be much harder to implement and understand?
5. Is a new helper, abstraction, type, enum, or interface duplicating an existing one that could be modified or extended within reason?
6. Are any of these changes unsafe to deploy in a way not acknowledged or accepted by the user?
7. Carefully review all modified code. Are there any other significant improvements you can suggest?
