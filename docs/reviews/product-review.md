# Product Review

## Research status

This review predates the research phase.

It identifies documentation and product-risk issues, not validated user needs. Treat its product claims as assumptions unless they are supported by research.

## Review standard

This review assumes the product is being evaluated before a EUR 10M investment.

The standard is not whether the idea is interesting. The standard is whether the documentation is clear enough to prevent waste, product drift, and premature engineering.

## Overall assessment

The product has a real problem space: knowledge workers lose professional context during fragmented workdays.

The original documentation was directionally strong but incomplete. It repeated the same philosophy across several files while leaving major product questions blank.

The revised documentation is simpler and more decision-ready, but the product still needs validation before implementation.

## Document-by-document review

| Document | Critical finding | Action taken |
| --- | --- | --- |
| `README.md` | Weak: said only "Under construction." Missing: product purpose, boundary, and where to start. | Rewritten as a concise repository entry point. |
| `AGENTS.md` | Weak: good rules, but no shared terminology. Duplicated principles from Product DNA. Missing: review docs as source material. | Added core terminology and required reading of review docs. |
| `docs/00-product-dna.md` | Strong philosophy, but repeated problem and vision content. Missing: the product's basic unit. Unvalidated: that context loss is frequent enough to support a product. | Tightened wording and added `Entry` as a non-negotiable concept. |
| `docs/01-vision.md` | Strong ambition, but "faster than Things 3" was unvalidated. Potential contradiction: "personal and professional" blurred scope. | Kept the benchmark but labeled it unvalidated; clarified professional scope. |
| `docs/02-problem-statement.md` | Good framing, but lacked validation gaps. Duplicated Product DNA language. | Added validation gaps and aligned language with entries and Work Logs. |
| `docs/03-personas.md` | Personas were plausible but generic. Missing: validation status. Assumption: users will capture during interruptions. | Added validation gaps and replaced project-heavy language with workstream language. |
| `docs/04-mental-model.md` | Clear core loop, but task boundary was too loose. | Clarified that tasks may appear inside entries but are not managed as product objects. |
| `docs/05-user-flows.md` | Empty. This was a major source-of-truth failure. | Added five product-level flows focused on capture, recovery, reconstruction, organization, and AI assistance. |
| `docs/06-features.md` | Empty. Missing feature boundary created risk of uncontrolled scope. | Added allowed capabilities and explicit non-features. |
| `docs/07-data-model.md` | Empty. Missing conceptual model created risk of architecture drift. | Added product-level objects without defining a technical schema. |
| `docs/08-ai.md` | Empty. AI was mentioned elsewhere but not governed. | Added role, allowed assistance, forbidden assistance, and validation gaps. |
| `docs/09-roadmap.md` | Empty. Missing sequence could encourage premature building. | Added a learning roadmap, not a delivery plan. |
| `docs/10-glossary.md` | Empty. Terminology was not controlled. | Added canonical product terms. |

## Weak ideas found

- Defining the product mostly by what it is not.
- Treating "faster than Things 3" as a standard without validation.
- Mentioning AI without guardrails.
- Mentioning offline first without defining product meaning.
- Leaving half the documentation set empty while calling documentation the source of truth.

## Duplicated concepts found

- "Not a task manager" appeared in multiple forms.
- Context loss was explained repeatedly.
- ClickUp and Jira were used as repeated warnings.
- Capture-first language appeared in several docs without adding new decisions.

The duplication was reduced by making [Product DNA](../00-product-dna.md) the primary source and using other docs for specific decisions.

## Missing concepts found

- Basic unit of memory.
- Work Log definition.
- AI boundaries.
- User flows.
- Feature boundaries.
- Conceptual data model.
- Roadmap sequence.
- Glossary.
- Validation gaps.

## Unvalidated assumptions

- Users will capture entries during real interruptions.
- Fast capture is more valuable than structured organization.
- Work Logs are more useful than timers for the target users.
- AI assistance will reduce load rather than add review work.
- The primary persona is the strongest commercial entry point.
- Offline first is important enough to constrain future architecture.

## Product risk after review

The product should not move into implementation yet.

It should move into validation of the core loop: capture an entry, continue working, review the Work Log, and recover context.
