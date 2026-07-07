# Work Memory

## Mission

Build the fastest and simplest Work Memory application for the founder.

This repository is not for another project management tool. The product should help the founder capture what happened, recover context later, and keep work moving with minimal structure.

## First target user

The first target user is the project founder.

Research documents under `/docs/research` and case documents under `/docs/cases` summarize observed founder behaviour extracted from the repository. Use them before making product decisions.

## Core Principles

- Capture first. Organize later.
- Speed over features.
- Offline first.
- AI assists, never interrupts.
- Every feature must solve a real user problem.
- Simplicity beats flexibility.
- Documentation is the source of truth.

Offline first is a product principle. Do not infer technical architecture from it until the offline experience is documented.

## Before writing code

Before implementing anything, an AI agent must read the documentation under `/docs`, including research documents under `/docs/research`, case documents under `/docs/cases`, and review documents under `/docs/reviews`.

Use the documentation to understand the product direction, constraints, terminology, and planned behaviour. If the documentation is incomplete or unclear, ask for clarification before writing code.

Core terminology must stay consistent:

- Entry: one captured piece of work memory.
- Work Log: the chronological record of entries.
- Context: the meaning that makes an entry useful later.
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
- Do not change architecture without documentation.
