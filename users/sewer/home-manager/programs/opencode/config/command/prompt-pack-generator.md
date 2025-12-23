---
description: "Generate complete prompt packs with embedded plans"
agent: orchestrator-builder
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

# Prompt Pack Generator

Generate complete, ready-to-execute prompt files with embedded implementation plans.

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
Clarification complete. Ready to run planners.

Say "plan" to continue.
```
**Continue to Phase 5 only when user says "plan".**

### Phase 5: Dependency-Aware Planning
1. Parse `# Dependencies` from each prompt file
2. Build execution layers:
   - Layer 0: prompts with no dependencies
   - Layer N: prompts whose dependencies are all in layers < N
3. For each layer (in order):
   - Spawn `@orchestrator-planner` for all prompts in layer **in parallel**
   - Pass: `prompt_path` (absolute path)
   - **Wait for layer to complete** before proceeding to next layer
4. Report results per layer.

### Phase 6: Generate Orchestrator
After all planning completes:
1. Read `# Difficulty` from each prompt file (set by planner)
2. Create `PROMPT-ORCHESTRATOR.md` with difficulties and tests from each prompt

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

# Plan
```

Plan is a placeholder.

## Orchestrator Index: `PROMPT-ORCHESTRATOR.md`

```markdown
# Orchestrator Index

Overall Objective: <short line>

Execution: SEQUENTIAL
Global Testing: basic|no

## Steps
- PROMPT-01-{title}.md — Objective: <short> — Dependencies: None — Tests: basic|no — Difficulty: low|medium|high
- PROMPT-02-{title}.md — Objective: <short> — Dependencies: ... — Tests: basic|no — Difficulty: low|medium|high
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
