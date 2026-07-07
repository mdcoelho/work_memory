# Work Memory

## Mission

Build the fastest and simplest Work Memory application.

This repository is not for another project management tool. The product should help people capture what happened, recover context later, and keep work moving with minimal structure.

## Research phase

The current product documentation represents hypotheses, not validated facts.

Before turning any product statement into implementation, check the research documents under `/docs/research`. If evidence is missing, treat the statement as an assumption and ask a research question instead of making a product decision.

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

Before implementing anything, an AI agent must read the documentation under `/docs`, including research documents under `/docs/research` and review documents under `/docs/reviews`.

Use the documentation to understand the product direction, constraints, terminology, and planned behavior. If the documentation is incomplete or unclear, ask for clarification before writing code.

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
- Ask for clarification instead of making assumptions.

## Forbidden

- Do not invent features.
- Do not redesign UX.
- Do not introduce complexity without approval.
- Do not change architecture without documentation.
