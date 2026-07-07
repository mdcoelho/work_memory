# Search

## Screen Status

Removed as a standalone MVP screen.

Search is a mode available from Home, Context, and Report.

## Purpose

Help the user find preserved context evidence when they remember a phrase, person, product, supplier, problem, or date but not the context name.

## ASCII Wireframe

```text
+----------------------------------------------------------------------------+
| Search preserved context                                             Esc    |
+----------------------------------------------------------------------------+
| / packaging drawing supplier                                               |
+----------------------------------------------------------------------------+
| Results                                                                    |
| > Supplier packaging issue                                                  |
|   Match: "drawing confirmation before supplier answer"                      |
|   Resume: confirm drawing, then answer                                      |
|                                                                            |
| > Product A industrialization                                               |
|   Match: "BOM still uncertain"                                             |
|   Resume: BOM check                                                         |
+----------------------------------------------------------------------------+
| Enter open context   Ctrl+Enter capture with search text   Esc close        |
+----------------------------------------------------------------------------+
```

## Information Shown

- Search phrase.
- Matching contexts.
- Matching evidence snippets.
- Resume point for each result when available.
- Date of matching evidence.

## User Actions

- Search by phrase.
- Open a context.
- Capture new evidence using the current phrase.
- Close search and return to previous screen.

## Keyboard Shortcuts

- `/`: open search from any primary screen.
- `Enter`: open selected result.
- `Ctrl+Enter`: capture using current search phrase.
- `Esc`: close search.

## Navigation

- Home -> Search mode: `/`.
- Context -> Search mode: `/`.
- Report -> Search mode: `/`.
- Search mode -> previous screen: `Esc`.
- Search mode -> Context: `Enter`.

## Empty State

```text
| Search preserved context                                                    |
| /                                                                          |
| Type any phrase, person, product, supplier, problem, or date.               |
```

## Loading State

```text
| Searching preserved context...                                              |
```

## Error State

```text
| Search failed.                                                              |
| Retry or return to previous screen.                                         |
```

## MVP Review

Search is not a separate final MVP screen.

It stays as a mode because a standalone Search screen adds navigation without adding core value.
