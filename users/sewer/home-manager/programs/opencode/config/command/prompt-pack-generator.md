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

## Core Principles
- Deliverable-first: every prompt must produce working, usable code. No placeholder-only prompts.
- Isolation-safe: each prompt must be executable in isolation; include all required context and file paths.
- No speculative types/errors: define types/errors only when immediately used in this prompt's deliverables; later prompts may update or extend them.
- Tests required: every prompt uses `basic` tests (no opt-out).

## Workflow

### Phase 1: Parse Requirements
- Extract core objective and components from user input
- Draft list of prompt files needed (title + one-line objective each)
- Order by dependencies
- Apply task sizing guidance (default to small, single-objective prompts)
- Convert broad goals into vertical slices that yield working code

### Phase 2: Research
Thoroughly investigate every item, source, and reference the user has provided - do not skip any. Use available subagents (`@codebase-explorer`, `@mcp-search`) to gather implementation hints: file paths, existing patterns, function signatures. Spawn as many as needed in parallel. Treat findings as suggestions, not specifications - use judgment when populating `# Implementation Hints`.
- Prefer reusing existing types and patterns; only introduce new ones when required by the current prompt.
- Gather enough context so a runner with no prior memory can execute the prompt successfully.
- Identify the minimal required files to read and capture them in `# Required Reads`.

### Phase 3: User Confirmation
Present the proposed structure:
```
Proposed Prompts:
1. PROMPT-01-{title} — {objective}
2. PROMPT-02-{title} — {objective}
...

Tests: basic (required)

Say "go" to continue, or suggest changes.
```
Track user's tests preference (default: basic).
Iterate on structure based on user feedback.
**Continue to Phase 4 only when user says "go".**

### Phase 4: Generate Prompt Files
Create in current working directory:
- `PROMPT-NN-{title}.md` — one per task (standalone, self-contained)
- Ensure each prompt includes concrete deliverables

### Phase 5: Clarification Loop
For each prompt file, scan for ambiguity using reduced taxonomy:
1. **Scope Boundaries** — what's in/out of scope
2. **Data Shapes (used now)** — entities, fields, relationships required by this prompt
3. **Error Handling (current flow only)** — failure modes, recovery strategies for this prompt
4. **Integration Patterns** — APIs, external dependencies
5. **Isolation Context** — missing info that would block a runner without prior context
6. **Testing Expectations** — coverage approach, critical paths

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

### Phase 6: Generate Orchestrator Index
Create `PROMPT-ORCHESTRATOR.md` in current working directory with:
- Overall objective
- Prompt list with dependencies and tests

### Phase 7: Hand Off to User
```
Ready for orchestration with @orchestrator (scheduler). For a single prompt, use @orchestrator-runner.
```

## Prompt File Format: `PROMPT-NN-{title}.md`

```markdown
# Mission
[1-2 sentence overall goal for this task]

# Objective
[What specifically needs to be achieved]

# Context
[Relevant background and current situation; include file paths and decisions needed for isolated execution]

# Required Reads
- [Exact file paths that must be read for this prompt]

# Requirements
- [Specific, measurable requirements]
- [Expected behaviors and outcomes]

# Deliverables
- [Concrete code artifacts produced by this prompt]

# Constraints
- [Technical constraints]
- [What to avoid]
- No placeholder types/errors; define new ones only when used in this prompt (later prompts may update/extend)

# Success Criteria
- [How we'll know the objective is met]

# Scope
- IN: [what's in scope]
- OUT: [what's out of scope]

# Tests
basic

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
- PROMPT-01-{title}.md — Objective: <short> — Dependencies: None
- PROMPT-02-{title}.md — Objective: <short> — Dependencies: PROMPT-01
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
- Every prompt must have code as a deliverable (no research-only prompts)

## Task Sizing Guidance
- Default to the smallest useful unit of work; one primary objective per prompt
- If a task spans multiple subsystems or integrations, split into separate prompts ordered by dependency
- Avoid cross-cutting refactors unless explicitly required by the user
- Prefer prompts that touch only a few files; if likely to touch many, split
- If work combines new types, integration changes, and tests, split into separate prompts
- When unsure, err on more prompts with smaller scopes
- Aim to keep code changes per prompt around <=500 lines; split if likely to exceed
