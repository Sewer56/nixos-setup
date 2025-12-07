---
description: "Generate 1 or more prompts to run with @orchestrator"
agent: build
---

# Prompt Pack Generator

Convert user requirements into a small set of executable prompt files that @orchestrator will run sequentially.

Do not implement code. Only write prompt files.

## Inputs
- A numbered or bulleted list of user requirements
- Optional global constraints (including testing policy)

## Quick Repo Scan
Briefly inspect the repository to recognize:
- Languages/frameworks and test tools in use
- Naming/conventions, formatters/linters, and common entry points
- Concrete identifiers, files, or modules likely relevant

Use this to make prompts specific; do not perform deep analysis.

## Process
1) Slice work: Split requirements by logical outcome, not file count. Group interdependent operations and batch similar changes across files. Order them and note dependencies.
2) Tests: If the user explicitly says "no tests", set `Tests: no`; otherwise `Tests: basic`.
3) Planning: Set `Planning: no` for simple, self-contained tasks. Set `Planning: yes` when deeper codebase analysis is needed.
4) Emit files: PROMPT‑TASK‑OBJECTIVES.md, PROMPT‑ORCHESTRATOR.md, and PROMPT‑NN‑{short-title}.md for each step.

## Prompt File Format: `PROMPT-{NN}-{short-title}.md`
```markdown
# Objective
[What specifically needs to be achieved]

# Context
[Relevant background and current situation]

# Requirements
- [Specific, measurable requirements]
- [Expected behaviors and outcomes]
- [Constraints or limitations]

# Success Criteria
- [How we'll know the objective is met]
- [Specific conditions that must be satisfied]

# Scope Boundaries
- IS included: [what's in scope]
- IS NOT included: [what's out of scope]

# Testing Requirements
Tests: basic|no

# Planning Requirements
Planning: yes|no

# Dependencies
None | depends on PROMPT-NN-...

# Relevant Code Locations (optional)
Include if specific existing files are known. Omit if created by a previous step.

## relative/path/to/file.ext
Relevance: High|Medium|Low
Lines: [start]-[end] (omit if file is new)
Reason: ≤10 words
```

## Task Objectives File: `PROMPT-TASK-OBJECTIVES.md`
```markdown
# Mission Objectives

Overall Mission: 1–2 sentence goal.

## Success Criteria
- 3–5 measurable outcomes

## Constraints
- Minimal implementation
- Testing policy: Tests default to basic unless user says no
- Any user‑specified constraints (list briefly)

## Scope
- Included: core tasks above
- Excluded: unrelated features, generic utilities, speculative improvements
```

## Orchestrator Index: `PROMPT-ORCHESTRATOR.md`
```markdown
# Orchestrator Index

Overall Objective: <short line>

Execution: SEQUENTIAL  
Global Testing: basic|no

## Steps
1. PROMPT‑01‑{title}.md — Objective: <short> — Dependencies: None — Tests: basic|no — Planning: yes|no
2. PROMPT‑02‑{title}.md — Objective: <short> — Dependencies: … — Tests: basic|no — Planning: yes|no
…
```

## Output Summary
- PROMPT‑TASK‑OBJECTIVES.md
- PROMPT‑ORCHESTRATOR.md
- PROMPT‑NN‑{title}.md (one per task)

## User Input

$ARGUMENTS
