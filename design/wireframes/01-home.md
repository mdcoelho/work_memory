# Home

## Screen Status

Primary MVP screen.

Home absorbs day review and simple search entry so the product stays small.

## Purpose

Answer: "Where is my work memory right now?"

The user should be able to open the product, understand recent context, capture immediately, and return to work.

## ASCII Wireframe

```text
+----------------------------------------------------------------------------+
| Work Memory                                      / Search       Report (R)  |
+----------------------------------------------------------------------------+
| Capture context...                                          Save: Ctrl+Enter|
| [What changed? What should not be forgotten? Where should work resume?]     |
+----------------------------------------------------------------------------+
| Today                                                                       |
|                                                                            |
| Active contexts                         Recent evidence                     |
| > Supplier packaging issue              09:42 blocked by missing drawing    |
|   Resume: confirm final drawing         09:10 decision: keep old supplier   |
|                                                                            |
| > Product A industrialization           08:55 resume at BOM check           |
|   Open question: cost impact            08:30 meeting changed priority      |
|                                                                            |
| Decisions / blockers                                                         |
| - Supplier answer waiting for technical confirmation                         |
| - Product A BOM still uncertain                                             |
+----------------------------------------------------------------------------+
| Shortcuts: C capture  / search  D today  R report  Enter open  Esc clear    |
+----------------------------------------------------------------------------+
```

## Information Shown

- Immediate capture field.
- Active contexts from today.
- Recent captured evidence.
- Resume points.
- Decisions and blockers from today.
- Report entry point.
- Search entry point.

## User Actions

- Capture new context.
- Open a context.
- Review today's context evidence.
- Search preserved context evidence.
- Start a date-range report.
- Clear current search or selection.

## Keyboard Shortcuts

- `C`: focus capture.
- `Ctrl+Enter`: save capture.
- `/`: search.
- `D`: return to today.
- `R`: start report.
- `Enter`: open selected context.
- `Esc`: clear search, close transient surfaces, or return to Home.

## Navigation

- Home -> Capture: focus capture field or press `C`.
- Home -> Context: select a context and press `Enter`.
- Home -> Report: press `R`.
- Home -> Search mode: press `/`.

## Empty State

```text
+----------------------------------------------------------------------------+
| Work Memory                                      / Search       Report (R)  |
+----------------------------------------------------------------------------+
| Capture context...                                          Save: Ctrl+Enter|
| [Start with the smallest useful memory.]                                    |
+----------------------------------------------------------------------------+
| No context captured today.                                                  |
|                                                                            |
| Capture what is happening, why it matters, or where work should resume.     |
+----------------------------------------------------------------------------+
```

## Loading State

Home should show the capture field first.

Recent context can load below it.

```text
| Capture context...                                                          |
|                                                                            |
| Loading recent context evidence...                                          |
```

## Error State

The user must still be able to capture.

```text
| Capture context...                                                          |
|                                                                            |
| Recent context could not load. Capture still works. Retry recent evidence.  |
```

## MVP Review

Home remains in the final MVP.

It is the default surface for opening, capturing, reviewing today, and entering search.
