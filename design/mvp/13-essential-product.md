# Essential Product

## Reset

Work Memory is built by one engineer in 90 days.

The founder is the only user.

The application is usually closed.

The smallest useful product is not a suite of screens. It is one global command overlay that captures, searches, reviews, and reports context evidence without pulling the founder away from current work.

## Absolute Minimum Product

One global overlay.

One memory stream.

One search box.

One copyable date-range memory.

No main window required for daily use.

## The Daily Problem It Must Solve

The founder changes context all day and later cannot reliably answer:

- What did I do?
- Why did it matter?
- Where did work stop?
- What should I report?

If the product only solves this, it is useful.

If it does anything else first, it is too large.

## Core Behaviour

```text
Global shortcut opens overlay

+----------------------------------------------------------+
| Work Memory                                              |
+----------------------------------------------------------+
| > supplier asked if drawing changed; confirm before reply|
+----------------------------------------------------------+
| Enter save   / search   today   report Jun24 Jul24   Esc |
+----------------------------------------------------------+
```

The same overlay supports four behaviours:

1. Capture a memory.
2. Search memory.
3. Show today.
4. Produce a date-range report.

## Capture

Capture is the product.

Path:

1. Press global shortcut.
2. Type one sentence.
3. Press `Enter`.
4. Return to work.

Target: under 3 seconds after typing begins.

There is no required context selection, classification, timer, status, project, folder, or review step.

## Adding 2 Hours To Existing Context

This is not a feature.

It is a capture format:

```text
> +2h Product A BOM check; mismatch still unresolved
```

The founder writes the time and meaning in the same sentence.

The product saves it as evidence. Search and reports can find it later.

## Classifying Work Later

Structured classification is not MVP.

The minimum later classification is editing the text.

If a capture says `supplier drawing`, the founder can later change it to `Product A supplier drawing decision`.

That is enough for the founder-only MVP.

## Reconstructing The Day Under 2 Minutes

The founder types:

```text
today
```

The overlay shows today's memory stream.

```text
+----------------------------------------------------------+
| Today                                                    |
+----------------------------------------------------------+
| 09:14 supplier asked if drawing changed                  |
| 10:05 confirmed old drawing still valid                  |
| 11:20 +2h Product A BOM check; mismatch unresolved       |
| 15:40 management asked for monthly work summary          |
+----------------------------------------------------------+
| Copy   Search within today   Esc                         |
+----------------------------------------------------------+
```

No separate review screen.

No required cleanup.

No automatic grouping.

No marking decisions, blockers, or resume points unless the founder wrote them.

## Monthly Report Under 30 Seconds

The founder types:

```text
report Jun 24 Jul 24
```

The overlay returns copyable date-range memory based on captured evidence.

```text
+----------------------------------------------------------+
| Report Jun 24 - Jul 24                                  |
+----------------------------------------------------------+
| Jun 24                                                   |
| - supplier asked if drawing changed                      |
| - confirmed old drawing still valid                      |
|                                                          |
| Jul 02                                                   |
| - +2h Product A BOM check; mismatch unresolved           |
|                                                          |
| Jul 24                                                   |
| - management asked for monthly work summary              |
+----------------------------------------------------------+
| Copy   Edit text   Esc                                  |
+----------------------------------------------------------+
```

The answer can be rough.

A rough answer in 30 seconds is better than a polished report that requires a workflow.

## Recovery From Search

Recovery happens from search.

The founder types whatever he remembers:

```text
drawing supplier
```

The overlay returns matching captures.

There is no context side panel in MVP.

Opening a result only expands the surrounding captures before and after it.

## Necessary Windows

One.

The global overlay is the only required surface.

The founder should not need a main window for the MVP.

## Why This Is Enough

If Quick Capture disappeared, the founder would stop using the product.

If searchable memory disappeared, the founder would stop using the product.

If date-range reporting disappeared, the product would not solve the management reporting problem.

Everything else can disappear and the founder can still get value.

## KEEP

- Global command overlay.
- Plain-text capture.
- Save with `Enter`.
- Automatic timestamp.
- Search captured memory.
- `today` view from captured memory.
- `report date date` copyable memory from captured evidence.
- Copy report text.
- Edit captured text.
- Preserve failed capture text on save error.

## REMOVE

- Main Home screen.
- Standalone Capture screen.
- Context side panel.
- Full Context screen.
- Standalone Search screen.
- Standalone End-of-Day Review screen.
- Monthly Report screen.
- Settings screen.
- Multiple global shortcuts.
- Context naming.
- Context renaming.
- Context objects.
- Automatic context matching.
- Automatic semantic grouping.
- Structured classification.
- Decision markers.
- Blocker markers.
- Question markers.
- Resume-point fields.
- Work-session screen.
- Timer behaviour.
- Dashboards.
- Reports with complex sections.
- AI-generated plans.
- AI suggestions during capture.
- Integrations.
- Collaboration.
- Notifications.
- Reminders.
- Attachments.
- Voice capture.
- Mobile-specific behaviour.

## LATER

- Context objects, if raw memory becomes hard to search.
- Context side panel, if search results are not enough for recovery.
- Structured decisions and blockers, if reports become too vague.
- End-of-day review, if unreviewed captures become untrustworthy.
- Rich monthly report formatting, if copied text is not enough.
- Automatic grouping, if chronological memory becomes too slow to edit.
- Multiple shortcuts, if one overlay becomes too slow.
- Attachments, if text cannot preserve enough evidence.
- Voice capture, if typing is still too much friction.
- Integrations, only after manual capture proves daily value.
- AI summaries, only after the raw captured memory is reliable.

## Final Product Shape

Work Memory MVP is a keyboard-first memory overlay.

It is closer to Spotlight than to Things 3.

It does not manage work.

It remembers enough that the founder can recover and report work without reconstructing the day from scratch.
