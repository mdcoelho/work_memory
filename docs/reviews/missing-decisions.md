# Missing Decisions

## Research status

This document predates the founder-observation rewrite but remains relevant.

The missing decisions listed here should be answered before they become product or architecture decisions.

## Purpose

This document lists decisions that remain open after the review.

They are not defects. They are decisions that should not be guessed by an AI agent or engineer.

## Product validation decisions

### Primary user

Decision needed: Which persona has the strongest pain and should be served first?

Why it matters: the current personas are hypotheses. Building for all of them would dilute the product.

### Capture-speed threshold

Decision needed: What does "capture in seconds" mean in practice?

Why it matters: "fast" is not a product requirement until it has a measurable threshold.

### Work Log value

Decision needed: What evidence proves that Work Logs are more useful than timers for the target user?

Why it matters: this is a central product belief and must be validated.

## Product boundary decisions

### Offline first

Decision needed: What user experience must work offline?

Why it matters: offline first can affect product scope, data ownership, sync expectations, and architecture. It should not be interpreted casually.

### Task relationship

Decision needed: Should Work Memory ever create, export, or track tasks, or only capture tasks as context inside entries?

Why it matters: this is the highest-risk path toward becoming another task manager.

### Classification depth

Decision needed: How much structure is useful after capture?

Why it matters: too little structure may hurt recovery; too much structure will make the product bureaucratic.

## AI decisions

### AI trust boundary

Decision needed: How should users review, accept, reject, or ignore AI suggestions?

Why it matters: AI must reduce cognitive load, not create a second review workload.

### AI availability

Decision needed: What product value must remain when AI is unavailable?

Why it matters: Work Memory should not depend on AI to justify its core loop.

## Data and user-control decisions

### Privacy posture

Decision needed: What privacy expectations does a professional memory product make explicit?

Why it matters: users may capture sensitive client, company, or personal work context.

### Export and portability

Decision needed: Can users export their entries and Work Logs?

Why it matters: professional memory should not become a locked-in black box.

### Retention

Decision needed: Does Work Memory preserve everything forever, or does the user control retention?

Why it matters: memory products need a clear stance on accumulation, deletion, and trust.

## Go-forward rule

Do not implement product functionality until the decision it depends on is documented.
