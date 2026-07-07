# Report

## Screen Status

Primary MVP screen.

Report is required because answering date-range questions is part of launch.

## Purpose

Answer: "What did you do between these dates?"

The report should organize work by context, not by container, timer, or raw activity.

## ASCII Wireframe

```text
+----------------------------------------------------------------------------+
| < Home        Report                                                        |
+----------------------------------------------------------------------------+
| Date range                                                                  |
| From [2026-06-24]  To [2026-07-24]                         Generate (G)     |
+----------------------------------------------------------------------------+
| Summary                                                                     |
| Between Jun 24 and Jul 24, 8 contexts moved. Main work: supplier issue,     |
| Product A industrialization, management reporting, and unresolved BOM check.|
+----------------------------------------------------------------------------+
| Contexts with meaningful progress                                           |
| 1. Supplier packaging issue                                                  |
|    Changed: answer blocked by missing drawing confirmation                  |
|    Decision: keep previous supplier for now                                 |
|    Resume: confirm drawing, then answer                                     |
|                                                                            |
| 2. Product A industrialization                                               |
|    Changed: BOM uncertainty remains                                         |
|    Blocker: latest decision not fully reflected                             |
+----------------------------------------------------------------------------+
| G generate  E edit wording  C capture  / search evidence  Esc home          |
+----------------------------------------------------------------------------+
```

## Information Shown

- Date range.
- Period summary.
- Contexts touched.
- Meaningful progress.
- Decisions and outcomes.
- Blockers and unresolved questions.
- Resume points.
- Supporting evidence.
- Gaps where context is incomplete.

## User Actions

- Set date range.
- Generate report.
- Review report.
- Edit report wording.
- Open source context.
- Search supporting evidence.
- Return Home.

## Keyboard Shortcuts

- `R`: open Report.
- `G`: generate report.
- `E`: edit wording.
- `/`: search evidence.
- `Enter`: open selected context.
- `Esc`: Home.

## Navigation

- Home -> Report: `R`.
- Context -> Report: `R`.
- Review mode -> Report: `R`.
- Report -> Context: open selected context.
- Report -> Home: `Esc`.

## Empty State

```text
| Choose a date range to generate a report.                                   |
| No report exists until a range is selected.                                 |
```

## Loading State

```text
| Generating report from preserved context...                                 |
| Showing contexts as soon as they are available.                             |
```

## Error State

```text
| Could not generate report.                                                  |
| Retry   Change date range   Search evidence manually                        |
```

## MVP Review

Report remains in the final MVP.

It is the only place for date-range reporting. No analytics, dashboards, or export screens are required.
