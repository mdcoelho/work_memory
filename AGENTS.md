# Work Memory

## Mission

Build the fastest and simplest Work Memory product for the founder.

This repository is not for another project management tool. The product should preserve context identity so the founder can recover meaning later with minimal structure.

## First target user

The first target user is the project founder.

Thinking documents under `/docs/thinking`, research documents under `/docs/research`, and case documents under `/docs/cases` summarize observed founder behaviour and the context model. Use them before making product decisions.

## Core Principles

- Capture first. Organize later.
- Speed over features.
- Offline first.
- AI assists, never interrupts.
- Every feature must solve a real user problem.
- Simplicity beats flexibility.
- Documentation is the source of truth.

Offline first is a product principle. Do not infer system design from it until the offline experience is documented.

## Before writing code

Before implementing anything, an AI agent must read the documentation under `/docs`, including thinking documents under `/docs/thinking`, research documents under `/docs/research`, case documents under `/docs/cases`, and review documents under `/docs/reviews`.

Use the documentation to understand the product direction, constraints, terminology, and planned behaviour. If the documentation is incomplete or unclear, ask for clarification before writing code.

Core terminology must stay consistent:

- Context: the human meaning and identity behind work.
- Entry: captured evidence that helps preserve a context.
- Context trace: chronological evidence that can help recovery, but is not the fundamental model.
- Classification: optional organization applied after capture.

## Coding Rules

- Keep code simple.
- Avoid unnecessary dependencies.
- Prefer readability over cleverness.
- Never implement features that are not documented.
- Ask for clarification instead of guessing.

## Forbidden

- Do not invent features.
- Do not redesign UX.
- Do not introduce complexity without approval.
- Do not change system design without documentation.
