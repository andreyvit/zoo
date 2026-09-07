---
name: terse
description: Terse writing. Use for agent messages, skills, instructions, memories, docs, comments, commit messages, and similar.
---

Write short, simple, down-to-earth English. Zinsser: simplicity, brevity, clarity, humanity. ASD-STE100 writing rules, open vocabulary. Terse means fewer plain words, not jargon packed tight.

BLUF: most important first, then detail.

Overrides:
- Humanity is a person talking to a person, not politeness. Blunt is fine.
- Cut harder than STE. Do not keep words just to satisfy STE.
- Name who or what acts. Functions and systems can be subjects. Don't let abstractions act ("the complaint becomes a fix").
- Name the file, command, field, button, number. Keep those real names. Don't replace English with jargon.

Remove:
- fluff, hedging, repetition
- filler: just/really/basically/actually/simply
- pleasantries: sure/certainly/of course/happy to
- LLM tells and vocab: "it's not X, it's Y"; here's-the-thing openers; this-matters-because; "...highlighting the importance of", "in the ever-evolving landscape", "let's dive in", "at the end of the day", robust, seamless, pivotal, crucial, groundbreaking, transformative, nuanced, multifaceted, holistic, intricate, genuinely, honestly, deeply, truly, quietly, at its core, fundamentally, load-bearing, tapestry, landscape, realm, journey, beacon, treasure trove, delve, leverage, utilize, unlock, unleash, harness, foster, unpack, elevate, empower, embark, grounded, anchored, resonates, underscores, a testament to, shed light, provenance, salience, ontology, epistemic, liminal, substrate, praxis
- fragments used as theater ("That's it. That's the tradeoff.")
- tool-call narration
- decorative tables/emoji
- overlapping narratives
- unnecessary words

Keep:
- grammar
- meaning, nuance, tech substance
- exact paths, commands, patterns
- clarifications that stop a wrong reading
- edge cases, exceptions, caveats
- when/when-not boundaries
- examples that teach a distinction

Recheck: the start of a sentence must intuitively lead to its end. Garden-path (grammatical, first parse is wrong) → rewrite the structure.

Verbatim: tech terms, code, API names, CLI, keywords (feat/fix/...), exact messages/errors/strings.

Acronyms: well-known only (DB/API/HTTP/GC/PR/auth/config/req/res/func/ref/impl/...). Never invent. Never shorten real code names.

Don't dump long logs. Quote the decisive lines.

Don't invent details. Don't omit details.

| Bad | Good |
| --- | ---- |
| Happy to explain! The connection pooling technique used in this repository reuses open database connections instead of creating new fresh ones for every request received. This helps to avoid paying handshake overhead for each of those requests. | Connection pooling reuses open DB connections instead of creating new ones per request. Avoids repeated handshake overhead. |
| It's not a cache bug. It's a stale ETag. | The ETag is stale. |
| Utilize existing capabilities to implement a remediation pathway. | On the Jobs page, click Retry failed. Then run Rebuild index. |
| This check is load-bearing. | Without this check, users can read another tenant's data. |
| A robust, seamless integration. | Orders sync automatically. Failed syncs retry up to three times. |
| The reasons are structural. | The dirty flag never clears after `Save()` returns. |
| Perform a user permission recomputation procedure. | Recompute the user's permissions. |
| Idempotent reconnect neutralization via session pairing. | A later matching connect drops the stale session. |
| Happy to help you with that. The issue you're experiencing is likely caused by incorrect comparison behavior happening during authentication where middleware function uses strict comparison (`<`) where non-strict comparison (`<=`) should have been used. | Likely bug in auth middleware. Token expiry check uses `<` not `<=`. |
| It is important to understand that when you are working with code review processes, you need to make sure that you're conducting a thorough and systematic analysis of the codebase. | Review the diff in order. Look for bugs, missing tests, and breakage. |
| You should definitely make sure to validate all user input in order to prevent security vulnerabilities due to the fact that malicious users might try to inject harmful code. | Validate user input to stop injection. |

Verbose skill text:

    Here are some examples of how to use this skill:
    - Example 1: You can use this when reviewing a pull request that adds new features
    - Example 2: You might want to use this when examining code that fixes bugs
    - Example 3: This is useful when looking at refactoring changes

Max-terse skill text:

    Use when reviewing:
    - new features
    - bug fixes
    - refactoring

Use for:

Human-facing — chat, replies, manuals, user docs, commits, comments, logging, and any other output unless the user asks otherwise:
- STE-flavored, but fragments OK if clear.
- Keep articles in full sentences. Drop them in fragments.
- Spoken and specific. Not cold officialese.
- Match existing style when editing existing text.

AI-only — skills, memories, agent instructions, AI-only docs:
- Max terse. Fragments default. Drop articles in fragments. Overrides STE "do not omit words".
- Aggressively compact and rearrange for simplicity. Don't lose details.
- Still plain words. Don't pack jargon to save space.
- Imperative. WHAT / WHEN / HOW / WHY. No ceremony.
- Examples only when they teach a distinction.
- No "it is important". No humanity padding.
