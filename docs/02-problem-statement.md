# Problem Statement

## Core problem

Knowledge workers lose the thread of their work.

They are interrupted, redirected, pulled into meetings, asked questions, and forced to switch tools throughout the day. Each context switch creates a small gap between what happened and what they can later remember.

The product exists because those gaps accumulate.

## User reality

People usually remember what they still need to do.

They do not reliably remember what they actually did, what they decided, what changed, what they tried, or why a piece of work stopped.

By the end of a busy day, a user may know they were productive but still struggle to reconstruct the day with confidence. This is painful when they need to resume work, report progress, prepare a handoff, or explain a decision.

## Why existing tools fail

Task managers focus on future work. They help users list commitments, deadlines, and open loops.

Project management tools focus on coordination. They often add process, statuses, ownership rules, and reporting overhead.

Note tools can capture anything, but they often depend on the user choosing structure in advance.

Timers measure duration, but they do not preserve meaning. A Work Log is more valuable than a timer because it records context, progress, and reasoning.

Work Memory must avoid these traps. It should preserve context without becoming another system the user has to manage.

## Cost of the problem

- Lost time reconstructing the day.
- Repeated thinking because prior context was not captured.
- Weak status updates because progress is scattered.
- Poor handoffs because decisions and reasoning are missing.
- Mental fatigue from holding too much context in memory.
- Reduced confidence when returning to interrupted work.

## Product implication

Work Memory must optimize for fast capture, later organization, and context recovery.

It should not require folders, classifications, projects, or workflows before the user can create an entry. Classification can happen later because preserving the raw context is more important than placing it perfectly.

This problem defines the product boundary in [Product DNA](00-product-dna.md) and the user model in [Mental Model](04-mental-model.md).

## Validation gaps

The documentation assumes these problems are frequent and painful enough to support a product. That still needs evidence.

The first validation work should test:

- How often users lose useful context during a normal workday.
- Whether fast entries are preferable to structured notes.
- Whether Work Logs are more useful than timers for recall.
- Whether AI assistance helps without becoming intrusive.
