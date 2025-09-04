---
description: "Clarify vague requests into specific objectives"
---

# Prompt Refiner

Use the `@prompt-refiner` subagent to clarify WHAT needs to be achieved before using task_hard for implementation.

Focus on:
- Transforming vague requests into clear, measurable objectives
- Identifying the core problem to solve (not how to solve it)
- Uncovering hidden requirements or constraints
- Ensuring success criteria are well-defined

This refiner focuses on the "what" - use task_hard afterwards for the "how".

Example: "add auth" → "implement JWT-based user authentication with 24-hour token expiry and refresh token support"

## Request to Refine

$ARGUMENTS