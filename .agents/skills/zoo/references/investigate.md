Use when the user asked to investigate a bug or client problem (investigate, look into, why, repro, client ticket). Not for implement/add/feature asks. Examples, not a closed list.

Primary work: deep investigation of cause and scope. Research is the main step, not a prelude to a plan.

Fill `What happened`: bad behavior, mechanism, impact, regression vs always-broken, who/when if knowable, scope. Classify: code bug vs configuration / human / usage error. Record the class in What happened and Decisions.

In chat: full What happened, then the class. Link the task file.

- Code bug → `status: building high-level plan`, `stage: HL`, `stage_complete: false`; continue to spec-with-user stage 1. Do not wait for a second go-ahead.
- Not a code bug → do not invent a code plan. `status: investigation complete`, `stage: INV`, `stage_complete: true`. Present findings; emit `Zoo task finished (.spec/example.md) r0` for the completed investigation and stop. Wait if they want a mitigation or docs anyway.
- Unclear → ask; do not guess a plan.

Do not implement from this step. Do not skip What happened.
