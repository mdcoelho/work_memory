# Documentation Review

## Research status

This review predates the founder-observation rewrite and is now historical.

It remains useful only as an audit of documentation risks. Current product discovery should be read from [Observed Patterns](../research/07-observed-patterns.md) and [Real Day](../cases/01-real-day.md).

## Scope

This review covers documentation risks that can distort product direction.

## Critical findings

### 1. The product had a strong negative definition but a weak positive model

The docs were clear about what Work Memory is not: Jira, ClickUp, Notion, CRM, wiki, or project management software.

They were less clear about the basic unit of the product. Without a shared object model, future contributors can turn the product into notes, tasks, folders, timers, or AI chat.

Fix applied: introduced `Entry`, `Work Log`, `Context`, `Classification`, and `Recovery` as product terms in [Glossary](../10-glossary.md) and [Data Model](../07-data-model.md).

### 2. Empty docs made the source of truth unreliable

Six numbered documents existed but contained no decisions.

That made the documentation look more mature than it was. Empty files for user flows, features, data model, AI, roadmap, and glossary created false confidence.

Fix applied: filled the empty docs with concise product-level decisions.

### 3. AI was too broad

The original docs said AI should reduce cognitive load, but did not define allowed and forbidden AI behaviour.

That was dangerous. AI can become the product's center, interrupt capture, or generate false certainty.

Fix applied: [AI](../08-ai.md) now defines allowed assistance, forbidden assistance, and evidence gaps.

### 4. Offline first was declared but unexplained

`AGENTS.md` stated offline first, but no product document explained what that means.

This remains an unresolved product decision.

Action required: decide what offline first means for the founder's capture and recovery behaviour. See [Missing Decisions](missing-decisions.md).

### 5. The task boundary was ambiguous

The original mental model said tasks can appear when they naturally belong to context.

That was directionally correct but vague. It left room for task-manager drift.

Fix applied: tasks may appear inside entries as context, but they are not primary product objects and must not define workflows, statuses, or backlogs.

## Product principles after review

- The product model starts with entries, not tasks.
- The Work Log is the primary surface of memory.
- Classification is optional and happens after capture.
- AI is assistance, not a dependency.
- Product decisions must stay grounded in the founder's observed behaviour.

## Remaining risk

The remaining risk is conceptual drift: turning Work Memory into tasks, notes, folders, timers, or AI chat instead of preserving the founder's professional memory.
