# Context

## Screen Status

Primary MVP screen.

The Context screen is used for recovery, correction, and continuing work.

## Purpose

Answer: "What is going on here, and where should I resume?"

This screen exists for returning after 30 minutes, tomorrow, or three weeks.

## ASCII Wireframe

```text
+----------------------------------------------------------------------------+
| < Home        Product A industrialization                        Report (R) |
+----------------------------------------------------------------------------+
| Summary                                                                    |
| Supplier question exposed a possible drawing/BOM mismatch. Need confirm     |
| latest decision before answering and before production follow-up.           |
+----------------------------------------------------------------------------+
| Resume point                                                               |
| Check final drawing decision, then answer supplier with confirmed state.    |
+----------------------------------------------------------------------------+
| Decisions                         Open questions / blockers                 |
| - Keep previous supplier for now  - Is BOM aligned with latest drawing?     |
| - Do not answer until confirmed   - What changed after last meeting?        |
+----------------------------------------------------------------------------+
| Evidence                                                                    |
| Today 09:42 blocked by missing drawing                                      |
| Today 09:10 decision: keep old supplier                                     |
| Yesterday meeting changed priority                                          |
+----------------------------------------------------------------------------+
| Actions: C add evidence  E edit  N rename  R report  / search  Esc home     |
+----------------------------------------------------------------------------+
```

## Information Shown

- Context name.
- Current summary.
- Resume point.
- Decisions.
- Open questions.
- Blockers.
- Recent evidence.
- Supporting evidence ordered by relevance before chronology.

## User Actions

- Add captured evidence.
- Edit context name.
- Edit summary, resume point, or evidence.
- Search within preserved evidence.
- Start report from this context.
- Return Home.

## Keyboard Shortcuts

- `C`: add capture.
- `E`: edit selected evidence or field.
- `N`: rename context.
- `/`: search.
- `R`: report.
- `Esc`: Home.

## Navigation

- Context -> Home: `Esc` or back.
- Context -> Capture: `C`.
- Context -> Report: `R`.
- Context -> Search mode: `/`.

## Empty State

```text
+----------------------------------------------------------------------------+
| < Home        Untitled context                                             |
+----------------------------------------------------------------------------+
| No summary yet.                                                             |
| Add the smallest useful memory: what this is, why it matters, or where it   |
| should resume.                                                              |
+----------------------------------------------------------------------------+
```

## Loading State

```text
| Loading context...                                                          |
| Show name and latest known resume point as soon as available.               |
```

## Error State

```text
| Context could not load.                                                     |
| Retry   Back to Home                                                        |
| Preserve any unsaved capture text.                                          |
```

## MVP Review

Context remains in the final MVP.

It is the only recovery screen. No separate project, folder, artifact, task, or timeline screen is needed.
