---
description: "Generate prompt packs for orchestrated execution"
agent: orchestrator-builder
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

# Prompt Pack Generator

Generate prompt files for orchestrated execution. Planning happens just-in-time during orchestration.

think hard

## Workflow

### Phase 1: Parse Requirements
- Extract core objective and components from user input
- Draft list of prompt files needed (title + one-line objective each)
- Order by dependencies

### Phase 2: User Confirmation
Present the proposed structure:
```
Proposed Prompts:
1. PROMPT-01-{title} — {objective}
2. PROMPT-02-{title} — {objective}
...

Say "go" to continue, or suggest changes.
```
Iterate on structure based on user feedback.
**Continue to Phase 3 only when user says "go".**

### Phase 3: Generate Prompt Files
Create in current working directory:
- `PROMPT-NN-{title}.md` — one per task (standalone, self-contained)

### Phase 4: Clarification Loop
For each prompt file, scan for ambiguity using reduced taxonomy:
1. **Scope Boundaries** — what's in/out of scope
2. **Types** — entities, fields, relationships
3. **Error Handling** — failure modes, recovery strategies
4. **Integration Patterns** — APIs, external dependencies
5. **Testing Expectations** — coverage approach, critical paths

Question rules:
- Ask up to 10 questions total (prefer ≤5)
- One question at a time
- Format each with recommended option:

**Recommended:** [X] — <reasoning>

**A:** <option description>
**B:** <option description>
**C:** <option description>
**Custom:** Provide your own answer

Reply with letter, "yes" for recommended, or custom answer.

After each answer, insert into the relevant prompt file under `# Clarifications`:
```
Q: <question>
A: <answer>
```

Stop when: all critical gaps filled, user says "done", or limit reached.

After clarification completes, present summary:
```
Clarification complete.

Please review the generated PROMPT-*.md files to see if anything else comes to mind.

Say "go" to generate the orchestrator index.
```

### Phase 5: Generate Orchestrator Index
Create `PROMPT-ORCHESTRATOR.md` in current working directory with:
- Overall objective
- Prompt list with dependencies and tests (difficulty set during orchestration)

### Phase 6: Hand Off to User
```
Ready for orchestration with @orchestrator primary mode/agent.
```

## Prompt File Format: `PROMPT-NN-{title}.md`

```markdown
# Mission
[1-2 sentence overall goal for this task]

# Objective
[What specifically needs to be achieved]

# Context
[Relevant background and current situation]

# Requirements
- [Specific, measurable requirements]
- [Expected behaviors and outcomes]

# Constraints
- [Technical constraints]
- [What to avoid]

# Success Criteria
- [How we'll know the objective is met]

# Scope
- IN: [what's in scope]
- OUT: [what's out of scope]

# Tests
basic|no

# Dependencies
None | depends on PROMPT-NN-...

# Clarifications
Q: <question>
A: <answer>

# Implementation Hints
- [Discovered patterns, library usage, existing code to reuse]
- [Actionable guidance for planner/coder]
```

## Orchestrator Index: `PROMPT-ORCHESTRATOR.md`

```markdown
# Orchestrator Index

Overall Objective: <short line>

## Prompts
- PROMPT-01-{title}.md — Objective: <short> — Dependencies: None — Tests: basic|no
- PROMPT-02-{title}.md — Objective: <short> — Dependencies: PROMPT-01 — Tests: basic|no
```

## Investigation Rules
Before creating any prompt:
- **Update/sync tasks**: fetch and compare; skip if already identical
- **Add/create tasks**: check it doesn't already exist
- **Fix tasks**: confirm the bug is real
- **Migration tasks**: compare current vs target; skip if compliant

## Constraints
- Be thorough; validate work is needed before creating prompts
- Drop any requirement where no change is needed
- Order prompts by dependency
- Each prompt must be standalone and self-contained
