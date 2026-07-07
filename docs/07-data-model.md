# Data Model

## Scope

This is a conceptual product model, not a database schema or technical architecture.

The purpose is to keep product language consistent before implementation decisions exist.

## Core objects

### Entry

An entry is one captured piece of work memory.

An entry should preserve:

- What happened.
- Why it mattered, if known.
- What changed, if anything changed.
- What the user may need when returning later.

An entry is valid even if it is incomplete.

### Work Log

A Work Log is the chronological record of entries.

The Work Log is the user's evidence of what actually happened during work. It should be useful for recall, status updates, handoffs, and resuming after interruptions.

### Context

Context is the meaning that makes an entry useful later.

Context can include decisions, reasoning, blockers, open questions, progress, and the state of unfinished work.

### Classification

Classification is optional organization applied after capture.

Classification may help with retrieval, but it is not the product's primary value. The primary value is preserving context before it is lost.

## Non-objects

The following should not be treated as primary product objects:

- Task.
- Project.
- Sprint.
- Status.
- Ticket.
- Pipeline stage.
- Folder.

They may appear inside entries as context, but they must not define the product model.
