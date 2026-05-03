Focus on simplicity as the ultimate sophistication.

Sometimes we build an entire subsystem, for someone else to just come in and say “but why could not you just ...” - and that makes the entire complicated piece unnecessary.

Sometimes you have to build a complex system to see opportunities for making it simpler, neater, more elegant. And this is exactly your job here.

If we were to define simplicity and elegance, it is often a matter of following the traditional principles of low coupling and high cohesion, sprinkled with the right balance of:

- abstraction and concreteness
- clarity and conciseness
- centralization and straightforwardness

It's also often just a case of thinking, “this part is shit; what else could I try to make it easy and obvious?”

So first identify the shitty parts:

- Concepts/abstractions that are murky or leaky.
- Functions that have no good name, because what they do is hard to explain.
- Names that are too abstract, because the thing does not have a clear, specific function or role.
- Big walls of code that do not OBVIOUSLY do the right thing. Like, do I have to read every line to figure out if there's a huge nasty surprise inside?
- Mundane code that does not seem to be advancing any specific business goal, but is not a well-abstracted algorithm or clear synthetic concept either.
- Code that seems too clever, uses clever words and features expansive call graph. It usually hides something, and your brain will spin trying to understand it, and you will probably never really be sure how it works.
- Anything that just irks you when reading the code.

And yes, for this, you HAVE to read all the code. File by file.

Ask yourself:

- “Is this good code I would use as an example of how code should be?”
- “If I presented this to Bill Gates, Don Melton and Linus Torvalds, would they be impressed?”
- “If a developer claiming to be Rob Pike showed me this code as their work, would I believe them to be the legendary coder, or would I get suspicious?”

And then -- could I make this simpler by:

- changing some core concepts, types and abstractions?
- introducing new abstractions? or killing/inlining abstractions?
- reshuffling responsibilities?
- rethinking the big picture approach?
- rethinking code flow?
- rethinking data flow?
- sharing state? getting rid of shared state?
- introducing or killing caches?
- precomputing or killing precomputation?
- handling edge cases early and separately? or rolling edge case handling into the happy path?
- etc etc etc

Does that lead you to imagining an alternative implementation that is simpler, more maintainable, more obviously correct, easier to explain and understand, using better names?
