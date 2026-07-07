# Review

## Screen Status

Removed as a standalone MVP screen.

Review is a mode of Home because the user only needs to review today's context evidence before reporting or resuming.

## Purpose

Answer: "What changed today?"

The review behaviour helps the user prepare a report and notice unresolved context before the day ends.

## ASCII Wireframe

```text
+----------------------------------------------------------------------------+
| Work Memory                                        Today Review      Done   |
+----------------------------------------------------------------------------+
| Today changed                                                               |
|                                                                            |
| Context                         Change                         Resume       |
| Supplier packaging issue        decision waiting confirmation  drawing chk  |
| Product A industrialization     BOM still uncertain           BOM check     |
| Management update               reported blocker              follow-up     |
+----------------------------------------------------------------------------+
| Decisions / blockers                                                        |
| - Keep previous supplier for now                                             |
| - Missing drawing blocks answer                                              |
+----------------------------------------------------------------------------+
| Actions: C capture  Enter open context  R report today  Esc home            |
+----------------------------------------------------------------------------+
```

## Information Shown

- Contexts touched today.
- Meaningful changes.
- Decisions.
- Blockers.
- Resume points.
- Evidence needed for report confidence.

## User Actions

- Open context.
- Capture more evidence.
- Start report for today.
- Return Home.

## Keyboard Shortcuts

- `D`: open Today Review from Home.
- `C`: capture.
- `Enter`: open selected context.
- `R`: report today.
- `Esc`: Home.

## Navigation

- Home -> Review mode: `D`.
- Review mode -> Context: select context.
- Review mode -> Report: `R`.
- Review mode -> Home: `Esc` or Done.

## Empty State

```text
| No captured context today.                                                  |
| Capture the smallest useful memory before reviewing.                        |
```

## Loading State

```text
| Loading today's context evidence...                                         |
```

## Error State

```text
| Today review could not load.                                                |
| Capture still works. Retry review.                                          |
```

## MVP Review

Review is not a separate final MVP screen.

It stays as a Home mode because a standalone Review screen would duplicate Home and Report.
