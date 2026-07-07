# Quick Capture

## Purpose

Capture must happen while the founder is already working elsewhere.

The main window should stay closed.

## Behaviour

Global shortcut opens a small capture overlay above the current work.

The user writes the smallest useful memory, saves, and returns to the previous work.

Target: under 3 seconds.

## ASCII Wireframe

```text
+----------------------------------------------------------+
| Work Memory Capture                              Esc      |
+----------------------------------------------------------+
| What should not be lost?                                |
| [supplier asked if drawing changed; confirm before reply]|
+----------------------------------------------------------+
| Enter save   Shift+Enter newline   Tab later context     |
+----------------------------------------------------------+
```

## Under 3 Seconds

The capture path is:

1. Press global capture shortcut.
2. Type one sentence.
3. Press `Enter`.

No classification. No project. No context picker. No window switching.

## Adding 2 Hours To Existing Context

The user should not start a timer.

The user records a work session as context evidence:

```text
+----------------------------------------------------------+
| Work Memory Capture                                      |
+----------------------------------------------------------+
| +2h Product A BOM check; found mismatch with latest drw  |
+----------------------------------------------------------+
| Enter save   Tab choose context if needed                |
+----------------------------------------------------------+
```

If the typed phrase matches an existing context, the overlay shows the best match. The user can accept it with `Tab` or ignore it and save raw evidence.

## Classification Later

Quick Capture stores raw evidence first.

Later classification happens from Search, Context side panel, or End-of-Day Review.

## Keyboard Shortcuts

- Global capture: `Ctrl+Space`.
- Save: `Enter`.
- Newline: `Shift+Enter`.
- Accept suggested context: `Tab`.
- Cancel: `Esc`.

## States

### Empty

```text
| What should not be lost?                                |
```

### Saving

```text
| Saved. Returning to work...                             |
```

### Error

```text
| Could not save. Text is preserved. Enter retry.          |
```

## Screen Decision

Quick Capture replaces the old full Home capture area.

The product should not require opening the main window to capture.
