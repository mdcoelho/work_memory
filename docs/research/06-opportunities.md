# Opportunities

## Research status

These are research opportunity areas, not product solutions.

No feature should be built from this document without evidence from users.

## Opportunity 1: Understand context loss in real time

The repository assumes context loss happens during interruptions and multitasking.

What to learn:

- When exactly context is lost.
- What kind of context is lost.
- Which losses create consequences.
- Which losses users ignore.

Questions:

- What was the last interruption that damaged work?
- What did the user forget?
- How did they recover?
- What was the cost?

## Opportunity 2: Understand the difference between tasks and memory

The repository repeatedly says the product is not a task manager.

What to learn:

- Whether users experience the pain as a task problem, memory problem, reporting problem, or coordination problem.
- Whether task tools already provide enough history for some users.
- Whether tasks need to appear only as context or as actionable objects.

Questions:

- When users say "I need to remember work," do they mean tasks, decisions, progress, conversations, or time?
- What do completed tasks fail to explain?
- What task-like behavior would be useful but dangerous?

## Opportunity 3: Understand Work Logs versus timers

The repository assumes Work Logs are more useful than timers.

What to learn:

- What users currently use timers for.
- Whether duration is important for billing, accountability, reflection, or reporting.
- Whether meaning without duration is enough.

Questions:

- What did the user need the last time they checked a timer?
- What did the timer fail to tell them?
- What would have made the record useful?

## Opportunity 4: Understand capture behavior

The repository assumes users will capture entries in seconds.

What to learn:

- Whether users will stop during interruption to capture.
- What makes capture feel too slow.
- What minimum information is enough for later recovery.

Questions:

- What would the user be willing to record in the moment?
- What would they postpone?
- What would they never capture?

## Opportunity 5: Understand organization after capture

The repository assumes classification can happen later.

What to learn:

- Whether users can retrieve unclassified entries.
- What structure they naturally add after the fact.
- Whether classification creates clarity or maintenance burden.

Questions:

- How would users look for an entry from last week?
- Would they search by person, topic, artifact, date, decision, task, or outcome?
- When does organization become bureaucracy?

## Opportunity 6: Understand AI trust

The repository assumes AI can reduce cognitive load if it does not interrupt.

What to learn:

- Which AI outputs users trust.
- Which AI outputs create review burden.
- Whether users want AI to summarize, classify, connect, or stay out of the way.

Questions:

- What would users allow AI to infer?
- What must AI never invent?
- How should uncertainty be shown?

## Opportunity 7: Understand privacy and ownership

The repository identifies privacy as a missing decision.

What to learn:

- What information users would hesitate to capture.
- Whether professional memory is personal, team-owned, or company-owned.
- Whether users expect export, deletion, and retention control.

Questions:

- What work context is too sensitive to save?
- Who should be able to see the memory?
- What would make the user trust the system?

## Assumptions moved out of product decisions

The following are not validated product decisions. They are assumptions to research.

| Assumption | Questions to answer before product decisions |
| --- | --- |
| Work Memory should be faster than Things 3. | Do target users know this benchmark? What capture speed feels meaningfully faster than current behavior? |
| The primary user is the context-switching knowledge worker. | Which user group has the most frequent and painful context loss? Which group is actively seeking a solution? |
| Entries are the right basic unit. | Do users naturally think in entries, notes, events, decisions, work sessions, people, or artifacts? |
| Work Logs are the right primary surface. | Do users want chronological recall, or do they recover work through people, topics, documents, or outcomes? |
| Classification should happen after capture. | Does later classification improve retrieval, or does it become cleanup work users avoid? |
| AI should summarize, classify, connect, or clarify. | Which AI assistance reduces effort without creating review burden or trust problems? |
| Offline first matters to users. | When do users need access without network? Does offline behavior influence trust or adoption? |
| Team workflows should be excluded by default. | Do users need private memory first, or does the pain only become valuable when shared? |
| Users want a separate professional memory system. | Would users add another tool, or do they expect this job to be solved inside existing tools? |

## What not to decide yet

- Final feature set.
- Technical architecture.
- Data schema.
- AI behavior.
- Offline behavior.
- Team or individual scope.
- Pricing or packaging.
- Integrations.
- Visual design.

## Research priority

Start with observed work, not opinions.

The most useful first study is a short diary or observation study where target users record interruptions, context switches, reconstruction moments, and end-of-day recall failures.
