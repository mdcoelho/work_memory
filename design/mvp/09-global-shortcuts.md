# Global Shortcuts

## Purpose

The MVP should feel closer to Spotlight than to a task manager.

The founder should be able to capture, recover, and report from the keyboard while staying inside current work.

## Required Shortcuts

| Shortcut | Behaviour |
| --- | --- |
| `Ctrl+Space` | Quick Capture |
| `Ctrl+Shift+Space` | Search / Recovery |
| `Ctrl+Shift+D` | End-of-Day Review |
| `Ctrl+Shift+R` | Monthly Report |
| `Esc` | Close overlay or side panel |

## Search / Recovery Overlay

```text
+----------------------------------------------------------+
| Work Memory Search                              Esc       |
+----------------------------------------------------------+
| / packaging drawing supplier                            |
+----------------------------------------------------------+
| > Supplier packaging issue           Resume: confirm drw |
| > Product A industrialization        BOM mismatch        |
| > July supplier report               blocker mentioned   |
+----------------------------------------------------------+
| Enter open side panel   C capture   R report context     |
+----------------------------------------------------------+
```

## How Many Windows Are Necessary?

Final MVP needs three surfaces:

1. Global overlay for Quick Capture and Search / Recovery.
2. Context side panel.
3. Review / Report surface.

The main window is not a daily requirement.

Home is removed as a required MVP screen.

Settings is removed.

Standalone Search is removed.

Standalone Review is removed.

## Can Capture Exist Without Opening The Application?

Yes.

Capture must exist without opening the main window.

If capture requires switching away from current work, it fails the MVP.

## Can Recovery Happen From Search?

Yes.

Search is the primary recovery path.

The founder often remembers a phrase, person, supplier, product, date, or problem before remembering a context name.

## Keyboard Rules

- Every global action must close back to the previous work with `Esc`.
- Capture must save with one key.
- Search must open a context side panel without opening a full main window.
- Report and review share one larger surface because they happen less often.

## Screen Decision

Global shortcuts replace the old Home-first navigation model.
