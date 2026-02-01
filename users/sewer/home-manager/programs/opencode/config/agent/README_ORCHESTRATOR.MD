# Orchestrator Overview

This folder defines the multi-agent workflow that turns a prompt pack into working code, with planning, review, verification, and requirements validation.

**Entry Points**
- `prompt-pack-generator` builds prompt packs (`PROMPT-*.md`), `PROMPT-PRD-REQUIREMENTS.md`, and `PROMPT-ORCHESTRATOR.md` using the builder workflow.
- `orchestrate-plan` turns a clarified plan into a single prompt and runs the same pipeline without an index.
- `orchestrator` is the scheduler that executes an existing `PROMPT-ORCHESTRATOR.md` sequentially.
- `orchestrator-runner` can be used directly for a single prompt when you already have a prompt file.

**Core Artifacts**
- `PROMPT-ORCHESTRATOR.md`: ordered prompt list with objectives, dependencies, tests, and requirement coverage.
- `PROMPT-PRD-REQUIREMENTS.md`: requirement inventory with scope and acceptance notes.
- `PROMPT-ORCHESTRATOR.state.md`: resumable state (prompt status, plan paths, base branch).
- `PROMPT-REQUIREMENTS-UNMET.md`: unmet requirement tracking with stage, reason, and evidence.
- `PROMPT-*-PLAN.md` and `PROMPT-*-CODER-NOTES.md`: per-prompt plan and execution notes.
- `PROMPT-ORCHESTRATOR.validation.md`: final requirements validation report written by the requirements checker.

**End-to-End Flow**
- Generate a prompt pack and orchestrator index via `prompt-pack-generator` (includes requirements preflight).
- The scheduler reads the index, initializes state, detects base branch, and runs prompts in order.
- Each prompt is executed by `@orchestrator-runner` through plan, review, implementation, quality gate, and commit.
- After each prompt, the scheduler runs CodeRabbit review when available.
- After all prompts, final requirements validation checks coverage and evidence against `base_branch`.

**Simple Diagrams**

End-to-end pipeline:
```
User Input
  |
  v
prompt-pack-generator
  |  (PROMPT-*.md, PROMPT-PRD-REQUIREMENTS.md, PROMPT-ORCHESTRATOR.md)
  v
orchestrator (scheduler)
  |
  v
orchestrator-runner (per prompt, sequential)
  |  (code changes + commits)
  v
orchestrator-requirements-final
  |  (PROMPT-ORCHESTRATOR.validation.md)
  v
Done
```

Per-prompt runner cycle:
```
PROMPT-NN-*.md
  |
  v
Planner -> Plan Review -> Coder -> Quality Gate -> Commit
  |          |               |           |
  |          v               |           v
  |     reviewer feedback    |     reviewer feedback
  v                          v
PROMPT-NN-*-PLAN.md      PROMPT-NN-*-CODER-NOTES.md
```

**Per-Prompt Runner Cycle**
- Plan: `@orchestrator-planner` writes a concrete `-PLAN.md` and optional findings.
- Plan review: GPT-5 + GLM reviewers must both approve; revisions loop as needed.
- Implementation: `@orchestrator-coder` applies the plan, runs checks, and writes `-CODER-NOTES.md`.
- Quality gate: GPT-5 + GLM reviewers validate objectives, code, and verification checks.
- Commit: `@commit` creates repo-style commits, excluding `PROMPT-*` files.

**Artifacts and Feedback Flow**
- **Planner and coder persist artifacts** to disk: `PROMPT-*-PLAN.md`, `PROMPT-*-CODER-NOTES.md`, and findings files.
- **Reviewers return feedback directly** in their agent response (plan reviewers and quality gates); the runner uses that feedback to decide approval or revision.
- **Scheduler state is persisted** in `PROMPT-ORCHESTRATOR.state.md` after each prompt for resume support.
- **Validation output is persisted** by the requirements checker in `PROMPT-ORCHESTRATOR.validation.md` after the final validation run.

**Roles At A Glance**
- **Scheduler**: `orchestrator` manages state, ordering, and final validation; never edits code.
- **Runner**: `orchestrator-runner` coordinates the plan -> build -> gate -> commit cycle per prompt.
- **Planner**: `orchestrator-planner` produces the actionable plan and updates prompt findings/required reads when needed.
- **Coder**: `orchestrator-coder` implements changes, runs verification, and records coder notes.
- **Reviewers**: plan reviewers (`orchestrator-plan-reviewer-*`) and quality gates (`orchestrator-quality-gate-*`) provide dual-model approval.
- **Validation and Tools**: requirements preflight/final (`orchestrator-requirements-*`), CodeRabbit (`orchestrator-coderabbit`), and commits (`commit`).
