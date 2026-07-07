# Features

## Research status

This document lists capability assumptions.

It is not a feature commitment. Each item needs evidence from [Opportunities](research/06-opportunities.md) before it can become a product decision.

## Product boundary

This document defines allowed product capabilities. It is not a PRD and does not describe implementation.

Any future feature should be tested against one of three hypothesized outcomes:

- Capture context quickly.
- Recover context later.
- Reduce the cognitive load of remembering work.

## Capability assumptions

### Fast entry capture

Hypothesis: the user needs to create an entry before the thought disappears.

Hypothesis: this is the primary product capability and the standard against which other capabilities should be judged.

### Work Log

The user needs a chronological record of entries.

The Work Log is more important than timers because it preserves meaning, not only duration.

### Context recovery

Hypothesis: the product should help the user recover what happened, why it mattered, and where to resume.

Recovery is the reason capture has value.

### Later classification

The product may support classification after capture.

Hypothesis: classification should not be required before an entry exists.

### AI assistance

AI may summarize, classify, connect, or clarify entries when it reduces cognitive load.

Hypothesis: AI should not become a required step in capture.

## Boundary assumptions

Boundary hypothesis: Work Memory should not include these by default:

- Boards.
- Sprints.
- Status workflows.
- Task assignment.
- Team permission systems.
- CRM pipelines.
- Wiki spaces.
- Mandatory timers.
- Complex folder structures.
- Process dashboards.

These exclusions exist to prevent task-manager drift.
