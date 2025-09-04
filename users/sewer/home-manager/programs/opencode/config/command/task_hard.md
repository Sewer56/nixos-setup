---
description: "Solve complex tasks with investigation, code flow analysis, and planning"
agent: build
model: anthropic/claude-sonnet-4-20250514
---

# Hard Task Solver

Use reasoning and all available tools to solve the problem.

You must consider edge cases and follow best coding practices for everything.
Never do bandaid fixes. Always ultrathink.

## Problem Description

$ARGUMENTS

## Configuration

**IMPORTANT: Execute these steps SEQUENTIALLY - wait for each subagent to complete before starting the next one. NEVER run subagents in parallel.**

1. **Investigation Phase**
   - Use the `@task-hard-investigator` subagent with the full path of the `opencode-instance-{id}` directory
   - Wait for completion before proceeding

2. **Flow Analysis Phase**
   - Use the `@task-hard-code-flow-mapper` subagent with the full path of the `opencode-instance-{id}` directory
   - Wait for completion before proceeding

3. **Planning Phase**
   - Use the `@task-hard-planner` subagent with the full path of the `opencode-instance-{id}` directory
   - Wait for completion before proceeding

4. **Review and Execute**
   - Enter plan mode and read the `PLAN.md` file from the opencode-instance directory
   - Present the plan to the user for approval
   - NEVER automatically execute the plan. The user MUST review it first.

Note: This command follows the same workflow as the original Claude Code task_hard, but adapted for OpenCode's subagent system with proper file-based workflow preservation.