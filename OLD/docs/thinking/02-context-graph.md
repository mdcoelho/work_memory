# Context Graph

## Definition

Contexts relate as a graph, not as folders.

The founder's work is not a clean hierarchy. A customer can connect to several products. A product can connect to several suppliers. A supplier issue can create a design decision. A meeting can affect multiple workstreams. A record can belong to one system but matter to a different context.

## Nodes

The graph can include many kinds of nodes:

- Customer.
- Project.
- Supplier.
- Product.
- Meeting.
- Decision.
- Problem.
- BOM.
- Drawing.
- Fusion model.
- Odoo record.
- Email.
- Phone call.
- Person.
- Constraint.
- Deadline.
- Open question.

None of these alone define the context.

## Why no node is enough

A customer is too broad. One customer can have several unrelated contexts active at the same time.

A project is too formal. Work can happen before the project name exists or after the project label stops being accurate.

A supplier is too narrow. A supplier issue can be caused by design, production, commercial pressure, quality, or missing information.

A product is too broad. One product can contain unrelated design, supply, industrialization, production, and reporting contexts.

A meeting is too temporary. The context usually exists before the meeting and continues after it.

A decision is too small. A decision matters because of the problem, constraints, people, and consequences around it.

A problem is too unstable. Problems split, change names, or merge with other problems as understanding improves.

A BOM is evidence of structure, not the whole reason behind the work.

A drawing is evidence of design state, not the business, supplier, or decision context.

A Fusion model is an artifact, not the context. It can participate in several contexts at once.

An Odoo record is an artifact, not the context. It can show state without explaining why that state matters now.

An email is a trace of communication, not the context. It can trigger work without containing the full situation.

A phone call is an event, not the context. It can change the context without preserving the previous reasoning.

## Edges

The meaning lives in the relationships:

- A supplier question affects a product.
- A product issue changes a drawing.
- A drawing change affects a BOM.
- A BOM issue triggers a production question.
- A production question creates a management update.
- A meeting changes a decision.
- A decision changes what matters in the next supplier reply.

The founder is often trying to remember these edges, not the individual nodes.

## Context as a graph path

A context is the active path through the graph.

The founder does not need every connected node at once. The founder needs the relevant path: what this work is about, how it got here, what changed, and where it should continue.

## Why folders fail

Folders force one location.

Contexts need many relationships.

The same artifact can matter to different contexts for different reasons. Putting it in one folder does not preserve the reason it mattered in each situation.

## Why container names fail

Containers group artifacts by storage or activity boundary.

Contexts group meaning by human continuity.

The founder can be in the same container and change context completely. The founder can move across several containers and still be inside the same context.
