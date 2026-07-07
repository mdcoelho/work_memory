# Product Review

## Research status

This review predates the founder-observation rewrite and is now historical.

It identifies documentation and product-risk issues from an earlier stage. Current product discovery should be read from [Observed Patterns](../research/07-observed-patterns.md) and [Real Day](../cases/01-real-day.md).

## Review standard

This review assumes the product is being evaluated before a EUR 10M investment.

The standard is not whether the idea is interesting. The standard is whether the documentation is clear enough to prevent waste, product drift, and premature engineering.

## Overall assessment

The product has a real problem space: the founder loses professional context during fragmented workdays.

The original documentation was directionally strong but incomplete. It repeated the same philosophy across several files while leaving major product questions blank.

The revised documentation is simpler and more decision-ready, but product design must now stay grounded in the founder's observed workday.

## Document-by-document review

| Document | Critical finding | Action taken |
| --- | --- | --- |
| `README.md` | Weak: said only "Under construction." Missing: product purpose, boundary, and where to start. | Rewritten as a concise repository entry point. |
| `AGENTS.md` | Weak: good rules, but no shared terminology. Duplicated principles from Product DNA. Missing: review docs as source material. | Added core terminology and required reading of review docs. |
| `docs/00-product-dna.md` | Strong philosophy, but repeated problem and vision content. Missing: the product's basic unit. | Tightened wording and added `Entry` as a non-negotiable concept. |
| `docs/01-vision.md` | Strong ambition, but "faster than Things 3" needed clearer status as an experience benchmark. Potential contradiction: "personal and professional" blurred scope. | Kept the benchmark and clarified professional scope. |
| `docs/02-problem-statement.md` | Good framing, but lacked concrete founder scenarios. Duplicated Product DNA language. | Added founder-specific context scenarios and aligned language with context identity. |
| `docs/03-personas.md` | Personas were plausible but generic. The founder-observation rewrite removed invented persona expansion. | Rewritten as a founder profile with behavioural modes. |
| `docs/04-mental-model.md` | Clear core loop, but task boundary was too loose. | Clarified that tasks may appear inside entries but are not managed as product objects. |
| `docs/05-user-flows.md` | Empty. This was a major source-of-truth failure. | Added five product-level flows focused on capture, recovery, reconstruction, organization, and AI assistance. |
| `docs/06-features.md` | Empty. Missing feature boundary created risk of uncontrolled scope. | Added allowed capabilities and explicit non-features. |
| `docs/07-data-model.md` | Empty. Missing conceptual model created risk of product drift. | Added product-level concepts without defining a storage model. |
| `docs/08-ai.md` | Empty. AI was mentioned elsewhere but not governed. | Added role, allowed assistance, forbidden assistance, and evidence gaps. |
| `docs/09-roadmap.md` | Empty. Missing sequence could encourage premature building. | Added a learning roadmap, not a delivery plan. |
| `docs/10-glossary.md` | Empty. Terminology was not controlled. | Added canonical product terms. |

## Weak ideas found

- Defining the product mostly by what it is not.
- Treating "faster than Things 3" as a standard without tying it to founder behaviour.
- Mentioning AI without guardrails.
- Mentioning offline first without defining product meaning.
- Leaving half the documentation set empty while calling documentation the source of truth.

## Duplicated concepts found

- "Not a task manager" appeared in multiple forms.
- Context loss was explained repeatedly.
- ClickUp and Jira were used as repeated warnings.
- Capture-first language appeared in several docs without adding new decisions.

The duplication was reduced by making [Product DNA](../00-product-dna.md) the primary source and using other docs for specific decisions.

## Missing concepts found during the review

- Basic unit of memory.
- Context trace definition.
- AI boundaries.
- User flows.
- Feature boundaries.
- Conceptual data model.
- Roadmap sequence.
- Glossary.
- Founder scenarios.

## Product risks

- The founder will capture entries during real interruptions only if capture is faster than the interruption cost.
- Fast capture is more valuable than structured organization.
- Context traces must prove more useful than timers during reporting and recovery.
- AI assistance will reduce load rather than add review work.
- Founder-specific design can still drift into generic productivity systems.
- Offline first is important but still needs a product-level experience definition.

## Product risk after review

The product should not move into broad build work yet.

It should move through the founder's behavioural cases until the core loop feels inevitable: preserve context, continue working, review context evidence, and recover context.
