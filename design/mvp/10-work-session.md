# Work Session

## Purpose

A work session records meaningful effort added to an existing context.

It is not a timer.

It answers: "I spent 2 hours on this context; what did that time mean?"

## Context Side Panel

Context should be a side panel, not a full screen.

The user is usually inside another work container and should not lose that place.

## ASCII Wireframe

```text
Current work remains visible behind or beside this panel.

+----------------------------------------------+
| Context: Product A industrialization   Esc    |
+----------------------------------------------+
| Resume                                       |
| Check BOM mismatch against latest drawing.   |
+----------------------------------------------+
| Add work session                             |
| [2h BOM check; mismatch still unresolved]    |
|                                              |
| Context: Product A industrialization         |
| Enter save   Tab change context              |
+----------------------------------------------+
| Recent evidence                              |
| Today 14:10 supplier asked for confirmation  |
| Today 09:40 decision waiting drawing check   |
+----------------------------------------------+
```

## Adding 2 Hours

Fastest path:

1. Press Search / Recovery shortcut.
2. Type context phrase.
3. Press `Enter` to open side panel.
4. Type `2h` and what changed.
5. Press `Enter`.

This records effort as context evidence.

## Classify Work Later

Later classification means:

- Link raw capture to an existing context.
- Rename context.
- Mark evidence as decision, blocker, question, or resume point.
- Split evidence into a new context if needed.

Classification must never be required during Quick Capture.

## Keyboard Shortcuts

- `Ctrl+Shift+Space`: search context.
- `Enter`: open selected context or save session.
- `Tab`: change matched context.
- `B`: mark blocker.
- `D`: mark decision.
- `Q`: mark open question.
- `Esc`: close side panel.

## States

### Empty

```text
| No session text yet.                         |
| Add what changed or where work stopped.      |
```

### Saving

```text
| Saving session evidence...                   |
```

### Error

```text
| Could not save. Session text is preserved.   |
```

## Screen Decision

Full Context screen is removed.

Context becomes a side panel opened from Search or Report.
