# End Of Day Review

## Purpose

Reconstruct the day in under 2 minutes.

The review should help the founder classify rough captures, confirm changed contexts, and leave tomorrow's resume points clear.

## Trigger

The user opens review with `Ctrl+Shift+D`.

Review is not a screen the user lives in during the day.

## ASCII Wireframe

```text
+----------------------------------------------------------------------------+
| End Of Day Review                                            Done Esc       |
+----------------------------------------------------------------------------+
| Today: 12 captures, 5 contexts, 3 unclassified, 2 blockers                  |
+----------------------------------------------------------------------------+
| Needs attention                                                             |
| > 14:10 "supplier asked if drawing changed"      [link] [decision] [blocker]|
| > 11:20 "+2h BOM check mismatch unresolved"      [linked: Product A]        |
| > 09:40 "management asked status"                [report evidence]         |
+----------------------------------------------------------------------------+
| Contexts changed                                                            |
| Supplier packaging issue       blocker: missing drawing   resume: confirm   |
| Product A industrialization    BOM mismatch unresolved    resume: BOM check |
+----------------------------------------------------------------------------+
| Enter open   L link   D decision   B blocker   R report today   Esc done    |
+----------------------------------------------------------------------------+
```

## Under 2 Minutes

The review path is:

1. Show unclassified captures first.
2. Show changed contexts second.
3. Let the user link or mark only what matters.
4. Confirm resume points.
5. Exit.

No inbox grooming. No task planning. No dashboards.

## Information Shown

- Captures needing attention.
- Contexts changed today.
- Decisions.
- Blockers.
- Resume points for tomorrow.
- Evidence useful for reporting.

## User Actions

- Link capture to context.
- Mark decision.
- Mark blocker.
- Confirm resume point.
- Open context side panel.
- Start report for today.
- Finish review.

## Keyboard Shortcuts

- `Ctrl+Shift+D`: open review.
- `Enter`: open selected item.
- `L`: link to context.
- `D`: mark decision.
- `B`: mark blocker.
- `R`: report today.
- `Esc`: finish review.

## States

### Empty

```text
| No captures today. Nothing to review.                                       |
```

### Loading

```text
| Preparing today's changed contexts...                                      |
```

### Error

```text
| Review could not load. Captures are preserved. Retry.                       |
```

## Screen Decision

Standalone Review remains removed from daily navigation.

End-of-Day Review is a deliberate closing workflow inside the shared Review / Report surface, not a general screen.
