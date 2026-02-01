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

Generate prompt files for orchestrated execution. Planning happens during orchestration.

think hard

## Core Principles
- Deliverable-first: each prompt must produce working code. No placeholder-only prompts.
- Isolation-safe: each prompt must run in isolation; include all required context and file paths.
- No speculative types/errors: define types/errors only when used in this prompt; later prompts may extend.
- Tests required: every prompt uses `basic` tests.

## Workflow

### Phase 1: Parse Requirements
- Extract core objective and components from user input
- Draft prompt list (title + one-line objective)
- Order by dependencies
- Apply task sizing guidance (default to small, single-objective prompts)
- Convert broad goals into vertical slices that yield working code

### Phase 1.5: Build Requirements Inventory
- Create `PROMPT-PRD-REQUIREMENTS.md` in the current working directory
- Extract every discrete requirement from the user input/PRD
  - Use stable IDs: `REQ-001`, `REQ-002`, ... (zero-padded, sequential)
  - Tag each with scope: `IN`, `OUT`, or `POST_INIT`
  - Record source section (e.g., Key Goals, Features > Remapping & Bindings)
  - Write a short acceptance note per requirement (what evidence would satisfy it)
- Do not drop requirements; mark out-of-scope or post-init explicitly
- Prefer per-requirement headings to reduce tokens in inventory files

### Phase 2: Research
- Review every item, source, and reference from the user input; do not skip.
- Use subagents as needed:
  - `@mcp-search` for external library/API specifics
  - `@codebase-explorer` for codebase search and pattern discovery
- Default to parallel subagent calls; only serialize when a dependency requires it.
- Treat findings as suggestions, not specs; use judgment when populating `# Implementation Hints`.
- Prefer reusing existing types and patterns; only introduce new ones when required by the current prompt.
- Gather enough context so a runner with no prior memory can execute the prompt.
- Identify the minimal required files to read and capture them in `# Required Reads` with brief relevance notes.
- Log findings per prompt in `PROMPT-FINDING-<prompt-stem>-NN.md` (relevant details only) and add a one-line entry in the prompt's `# Findings`.
- Include other research discoveries the same way; keep findings prompt-scoped (duplication across prompts is OK).

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
Iterate on structure based on user feedback.
**Continue to Phase 4 only when user says "go".**

### Phase 4: Generate Prompt Files
Create in current working directory:
- `PROMPT-NN-{title}.md` — one per task (standalone, self-contained)
- Ensure each prompt includes concrete deliverables
- Every prompt `# Requirements` entry must include a requirement ID (e.g., `REQ-012: ...`)

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

Say "go" to validate requirements coverage and generate the orchestrator index.
```

### Phase 6: Validate Requirements Coverage (Subagent)
- Spawn `@orchestrator-requirements-preflight` with:
  - `requirements_path` (absolute path to `PROMPT-PRD-REQUIREMENTS.md`)
  - `prompts_dir` (absolute path to the current working directory)
  - `prd_path` (absolute path to the PRD input)
- If status is FAIL or PARTIAL: revise the prompt pack and re-run this phase
- If PASS: proceed

### Phase 7: Generate Orchestrator Index
Create `PROMPT-ORCHESTRATOR.md` in current working directory with:
- Overall objective
- Prompt list with dependencies and tests
- `PRD Path` and `Requirements Inventory` paths (relative)
- Per-prompt `Reqs:` coverage list (requirement IDs)

### Phase 8: Hand Off to User
```
Ready for orchestration with `@ orchestrator` (scheduler). For a single prompt, use `@ orchestrator-runner`.
```

## Prompt File Format: `PROMPT-NN-{title}.md`

```markdown
# Mission
[1-2 sentence goal for this task]

# Objective
[What must be achieved]

# Context
[Relevant background; include file paths and decisions for isolated execution]

# Required Reads
- path/to/file: [Why this file is relevant]

# Requirements
- REQ-###: [Specific, measurable requirement]
- REQ-###: [Expected behaviors and outcomes]

# Deliverables
- [Concrete code artifacts from this prompt]

# Constraints
- [Technical constraints]
- [What to avoid]
- No placeholder types/errors; define new ones only when used here; later prompts may extend

# Success Criteria
- [How to know the objective is met]

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

# Findings
- PROMPT-FINDING-<prompt-stem>-01.md: <one-line relevance>

# Implementation Hints
- [Patterns, library usage, existing code to reuse]
- [Actionable guidance for planner/coder]
```

## Orchestrator Index: `PROMPT-ORCHESTRATOR.md`

```markdown
# Orchestrator Index

Overall Objective: <short line>
PRD Path: <relative path to PRD input>
Requirements Inventory: PROMPT-PRD-REQUIREMENTS.md

## Prompts
- PROMPT-01-{title}.md — Objective: <short> — Reqs: REQ-001, REQ-004 — Dependencies: None
- PROMPT-02-{title}.md — Objective: <short> — Reqs: REQ-002 — Dependencies: PROMPT-01
```

## Requirements Inventory: `PROMPT-PRD-REQUIREMENTS.md`

```markdown
# PRD Requirements Inventory

Source PRD: PROMPT-PRD.md

## REQ-001 [IN] <requirement>
- Source: <section>
- Acceptance: <evidence or outcome>

## REQ-002 [POST_INIT] <requirement>
- Source: <section>
- Acceptance: <evidence or outcome>
```

## Investigation Rules
Before creating any prompt:
- **Update/sync tasks**: fetch and compare; skip if identical
- **Add/create tasks**: confirm it doesn't already exist
- **Fix tasks**: confirm the bug is real
- **Migration tasks**: compare current vs target; skip if compliant

## Constraints
- Be thorough; validate work is needed before creating prompts
- Do not omit requirements; mark as OUT or POST_INIT when no work is needed
- Order prompts by dependency
- Each prompt must be standalone and self-contained
- Every prompt must have code as a deliverable (no research-only prompts)

## Task Sizing Guidance
- Default to the smallest useful unit; one primary objective per prompt
- If a task spans subsystems or integrations, split into prompts ordered by dependency
- Avoid cross-cutting refactors unless explicitly required by the user
- Prefer prompts that touch few files; if likely to touch many, split
- If work combines new types, integration changes, and tests, split
- When unsure, err on more prompts with smaller scopes
- Aim for <=500 lines per prompt; split if likely to exceed

## Findings File Format: `PROMPT-FINDING-<prompt-stem>-NN.md`

```markdown
# Prompt Finding

Query: <what was searched or inspected>

## Summary
- <concise facts>

## Details
- <key API signatures, constraints, patterns>

## Relevant Paths
- path/to/file

## Links
- https://example.com/docs
```
