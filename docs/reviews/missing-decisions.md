# Missing Decisions

## Research status

This document predates the founder-observation rewrite and has been updated to use the founder as the first target user.

The missing decisions listed here should be answered before they become product decisions.

## Purpose

This document lists decisions that remain open after the review.

They are not defects. They are decisions that should not be guessed by an AI agent or engineer.

## Founder-behaviour decisions

### Primary user

Decision made: The first target user is the project founder.

Remaining decision: Which founder scenario should anchor the first product experience: reporting, Fusion recovery, supplier follow-up, management questions, or Odoo checks?

Why it matters: solving all founder scenarios at once can still dilute the product.

### Capture-speed threshold

Decision needed: What does "capture in seconds" mean in practice?

Why it matters: "fast" is not a product requirement until it has a measurable threshold.

### Work Log value

Decision needed: What founder reporting or recovery moment proves that a Work Log is more useful than a timer?

Why it matters: the founder values meaning over duration, but the product must make that value concrete in behaviour.

## Product boundary decisions

### Offline first

Decision needed: What founder experience must work offline?

Why it matters: offline first can affect product scope, data ownership, and trust. It should not be interpreted casually.

### Task relationship

Decision needed: Should Work Memory ever create, export, or track tasks, or only capture tasks as context inside entries?

Why it matters: this is the highest-risk path toward becoming another task manager.

### Classification depth

Decision needed: How much structure is useful after capture?

Why it matters: too little structure may hurt recovery; too much structure will make the product bureaucratic.

## AI decisions

### AI trust boundary

Decision needed: How should the founder review, accept, reject, or ignore AI suggestions?

Why it matters: AI must reduce cognitive load, not create a second review workload.

### AI availability

Decision needed: What product value must remain when AI is unavailable?

Why it matters: Work Memory should not depend on AI to justify its core loop.

## Data and user-control decisions

### Privacy posture

Decision needed: What privacy expectations does a professional memory product make explicit?

Why it matters: the founder captures sensitive client, company, supplier, and personal work context.

### Export and portability

Decision needed: Can the founder export entries and Work Logs?

Why it matters: professional memory should not become a locked-in black box.

### Retention

Decision needed: Does Work Memory preserve everything forever, or does the founder control retention?

Why it matters: memory products need a clear stance on accumulation, deletion, and trust.

## Go-forward rule

Do not implement product functionality until the decision it depends on is documented.
