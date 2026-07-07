# Capture

## Screen Status

Primary MVP transient screen.

Capture can appear as the focused state of Home, but it is documented separately because speed is the core product behaviour.

## Purpose

Capture context in less than 5 seconds.

The user should save the smallest useful memory and return to work.

## ASCII Wireframe

```text
+--------------------------------------------------------------+
| Capture context                                      Esc close|
+--------------------------------------------------------------+
| What should not be lost?                                     |
|                                                              |
| [supplier asked if Product A drawing changed; need confirm   |
|  latest decision before answering; resume at drawing check]  |
|                                                              |
+--------------------------------------------------------------+
| Save Ctrl+Enter                                      No fields|
+--------------------------------------------------------------+
```

## Information Shown

- One plain-language capture area.
- Save shortcut.
- Close shortcut.
- No required classification.
- No project, folder, status, priority, timer, or assignment fields.

## User Actions

- Write memory.
- Save capture.
- Cancel capture.
- Return to Home automatically after save.

## Keyboard Shortcuts

- `C`: open capture from anywhere.
- `Ctrl+Enter`: save.
- `Esc`: cancel and return.

## Navigation

- Capture -> Home: save or cancel.
- Capture -> Context: not automatic; connecting to context happens after capture.

## Empty State

```text
| What should not be lost?                                     |
| [ ]                                                          |
| Hint: write what changed, why it matters, or where to resume.|
```

## Loading State

Capture should not block on loading.

```text
| Saving...                                                    |
| Keep this visible only long enough to confirm save.          |
```

## Error State

The capture remains visible and editable.

```text
| Could not save. Your text is still here.                     |
| Retry Ctrl+Enter                                             |
```

## MVP Review

Capture remains in the final MVP.

It is deliberately smaller than a note editor. If it asks for anything beyond the memory text, it has become too heavy.
