---
description: "Solve complex tasks with investigation, code flow analysis, and planning"
agent: plan
---

# Hard Task Solver

Use reasoning and all available tools to solve the problem.

You must consider edge cases and follow best coding practices for everything.
Never do bandaid fixes. Always ultrathink.

## Configuration

**IMPORTANT: Execute these steps SEQUENTIALLY - wait for each subagent to complete before starting the next one. NEVER run subagents in parallel.**

1. **Investigation Phase**
   - Use the `@task-hard-investigator` subagent
   - Wait for completion before proceeding

2. **Flow Analysis Phase**
   - Use the `@task-hard-code-flow-mapper` subagent
   - Wait for completion before proceeding

3. **Planning Phase**
   - Use the `@task-hard-planner` subagent
   - Wait for completion before proceeding

Once all the steps are done, enter plan mode and read the `PLAN.md` file.
Present a summarised version of this plan to the user so they can provide feedback on it.
The user MUST review it first.

***NEVER** automatically execute the plan without the user's approval.

The user provided problem to solve is described below.

## Problem Description

$ARGUMENTS
