---
description: "Generate a prompt pack from user requirements for @orchestrator"
agent: build
model: github-copilot/gpt-5
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
1) Slice work: Split requirements into minimal, single‑objective prompts. Order them and note dependencies.
2) Tests: If the user explicitly says “no tests”, set Tests: no; otherwise Tests: basic.
3) Emit files: PROMPT‑TASK‑OBJECTIVES.md, PROMPT‑ORCHESTRATOR.md, and PROMPT‑NN‑{short-title}.md for each step.

## Prompt File Format: `PROMPT-{NN}-{short-title}.md`
```markdown
# Requirement: <concise title>

## Objective
1–2 sentences describing the outcome.

## Repo Cues
- Relevant languages/frameworks detected
- Concrete identifiers/files/modules to target
- Repo constraints (formatter, linter, scripts) that affect this task

## Requirements
- Specific, measurable items and constraints

## Acceptance
- Observable behaviors that prove success
- Verification signals (build/lint/test as applicable)

## Testing Requirements
Tests: basic|no

## Dependencies
None | depends on PROMPT‑NN‑...

## Guardrails
- Implement only what is asked
- No abstractions or unused code
- Keep changes minimal and local
```

## Task Objectives File: `PROMPT-TASK-OBJECTIVES.md`
```markdown
# Mission Objectives

Overall Mission: 1–2 sentence goal.

## Success Criteria
- 3–5 measurable outcomes

## Constraints
- Minimal implementation; no future‑proofing
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
1. PROMPT‑01‑{title}.md — Objective: <short> — Dependencies: None — Tests: basic|no
2. PROMPT‑02‑{title}.md — Objective: <short> — Dependencies: … — Tests: basic|no
…

## Usage
@orchestrator [all prompt file paths in order]
```

## Output Summary
- PROMPT‑TASK‑OBJECTIVES.md
- PROMPT‑ORCHESTRATOR.md
- PROMPT‑NN‑{title}.md (one per task)

## User Input

$ARGUMENTS
