# Inconsistencies

## Research status

This review predates the founder-observation rewrite.

It explains documentation inconsistencies. Read it with [Observed Patterns](../research/07-observed-patterns.md).

## Review result

The original documentation had no fatal contradiction, but it had several ambiguity risks that can become contradictions during product design.

The main problem was repeated philosophy without controlled terminology.

## Issues found and resolved

### Task boundary

Issue: The docs said Work Memory is not a task manager, but also said the product may touch tasks.

Resolution: Tasks may appear inside entries as context. They are not primary product objects and must not drive backlogs, statuses, or workflows.

### Product unit

Issue: The docs used capture language but did not name what was being captured.

Resolution: Introduced `Entry` as the basic unit of Work Memory.

Why introduced: contributors need one shared word for the thing the founder creates.

### Work Log versus timer

Issue: Work Logs were said to be more important than timers, but Work Log was not defined.

Resolution: Introduced `Work Log` as the chronological record of entries.

Why introduced: the product needs a positive alternative to timers.

### Classification

Issue: "Organize later" and "classification can happen later" appeared without a clear term boundary.

Resolution: Defined `Classification` as optional organization after capture.

Why introduced: classification must be separated from capture so it cannot block speed.

### AI scope

Issue: AI was described as helpful but not constrained.

Resolution: AI is now optional, non-interruptive assistance that may summarize, classify, connect, or clarify entries.

Why introduced: without explicit AI boundaries, the product can become an AI workflow tool instead of a memory system.

### Project language

Issue: Some docs used project language, which could pull the product toward project management.

Resolution: Replaced project-heavy wording with workstream or context language where appropriate.

Why removed: the product should not be shaped around projects, tickets, or workflows.

### Empty source-of-truth files

Issue: Empty numbered docs contradicted the rule that documentation is the source of truth.

Resolution: Added concise product-level content to each empty document.

Why introduced: decisions must be visible before product work begins.

## Remaining unresolved tension

### Offline first

`AGENTS.md` says offline first, but the product docs do not yet define the offline experience.

This is not fixed because defining it would require a real product decision. It is listed in [Missing Decisions](missing-decisions.md).

### Things 3 benchmark

The docs preserve "faster than Things 3" because it is an important experience signal.

The wording now states that it is the documented benchmark for the founder's capture experience.

## Terminology after review

Use these terms consistently:

- Work Memory
- Entry
- Work Log
- Context
- Capture
- Classification
- Recovery

Avoid these as primary product terms:

- Task
- Project
- Ticket
- Sprint
- Status
- Folder
- Pipeline
