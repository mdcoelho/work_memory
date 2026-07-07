# Architecture Review

## Research status

This review predates the research phase.

It is useful as an audit of documentation risks, but it is not user evidence. Product claims in this review should be checked against [Research Opportunities](../research/06-opportunities.md).

## Scope

This review covers product architecture and documentation architecture.

No implementation architecture exists yet, so this review does not evaluate platforms, frameworks, storage, sync, security, or deployment.

## Investment verdict

The product direction is promising but was not investment-ready before this review.

The original documentation had a clear instinct: Work Memory should not become a task manager. That instinct was repeated often, but the repository lacked enough structure to make product decisions safely.

The main risk was not technical. The main risk was conceptual drift.

## Critical findings

### 1. The product had a strong negative definition but a weak positive model

The docs were clear about what Work Memory is not: Jira, ClickUp, Notion, CRM, wiki, or project management software.

They were less clear about the basic unit of the product. Without a shared object model, future contributors could turn the product into notes, tasks, folders, timers, or AI chat.

Fix applied: introduced `Entry`, `Work Log`, `Context`, `Classification`, and `Recovery` as product terms in [Glossary](../10-glossary.md) and [Data Model](../07-data-model.md).

### 2. Empty docs made the source of truth unreliable

Six numbered documents existed but contained no decisions.

That made the documentation look more mature than it was. Empty files for user flows, features, data model, AI, roadmap, and glossary created false confidence.

Fix applied: filled the empty docs with concise product-level decisions, not implementation detail.

### 3. AI was too broad

The original docs said AI should reduce cognitive load, but did not define what AI may or may not do.

That was dangerous. AI could easily become the product's center, interrupt capture, or generate false certainty.

Fix applied: [AI](../08-ai.md) now defines allowed assistance, forbidden assistance, and validation gaps.

### 4. Offline first was declared but unexplained

`AGENTS.md` stated offline first, but no product document explained what that means.

This remains an unresolved decision because defining offline behavior may require product, privacy, and technical choices.

Action required: decide what offline first means before technical architecture begins. See [Missing Decisions](missing-decisions.md).

### 5. The task boundary was ambiguous

The original mental model said the product may touch tasks when they naturally appear in context.

That was directionally correct but vague. It left room for task-manager drift.

Fix applied: tasks may appear inside entries as context, but they are not primary product objects and must not define workflows, statuses, or backlogs.

## Architecture principles after review

- The product model starts with entries, not tasks.
- The Work Log is the primary surface of memory.
- Classification is optional and happens after capture.
- AI is assistance, not a dependency.
- Technical architecture must not be designed until product decisions are validated.

## Remaining architecture risk

The repository still lacks implementation architecture by design.

That is acceptable now, but only because the product is still being defined. The next architecture step should happen after the missing decisions are answered, not before.
