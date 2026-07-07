# Monthly Report

## Purpose

Prepare a monthly report in under 30 seconds.

The report answers: "What did you do between these dates?"

## Trigger

The user opens report with `Ctrl+Shift+R`.

Default range should be the last 30 days.

## ASCII Wireframe

```text
+----------------------------------------------------------------------------+
| Monthly Report                                               Esc            |
+----------------------------------------------------------------------------+
| Range: [Jun 24] to [Jul 24]                         Generate Enter         |
+----------------------------------------------------------------------------+
| Draft answer                                                                 |
| 1. Supplier packaging issue                                                  |
|    Progress: answered supplier after drawing confirmation                    |
|    Blocker: confirmation delayed response                                    |
|                                                                            |
| 2. Product A industrialization                                               |
|    Progress: 2h BOM check, mismatch unresolved                               |
|    Resume: verify BOM against latest drawing                                 |
+----------------------------------------------------------------------------+
| G regenerate   E edit   Enter open context panel   Copy report   Esc close  |
+----------------------------------------------------------------------------+
```

## Under 30 Seconds

The report path is:

1. Press report shortcut.
2. Confirm or adjust date range.
3. Read draft answer organized by context.
4. Edit only if needed.
5. Copy or use the answer.

## Information Shown

- Date range.
- Contexts touched.
- Meaningful progress.
- Decisions.
- Blockers.
- Work sessions.
- Resume points.
- Evidence gaps.

## User Actions

- Generate report.
- Adjust date range.
- Edit wording.
- Open context side panel.
- Copy report.
- Close report.

## Keyboard Shortcuts

- `Ctrl+Shift+R`: open report.
- `Enter`: generate or open selected context.
- `G`: regenerate.
- `E`: edit wording.
- `C`: copy report when report is focused.
- `Esc`: close.

## States

### Empty

```text
| Choose a date range or press Enter for last 30 days.                        |
```

### Loading

```text
| Building report from context evidence...                                    |
```

### Error

```text
| Report could not be prepared. Evidence is preserved. Retry.                 |
```

## Screen Decision

Monthly Report remains as a mode of the shared Review / Report surface because it is a deliberate reporting task.

It does not require the main daily window.
