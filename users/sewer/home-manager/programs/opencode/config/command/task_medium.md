# Medium Task Solver

Use reasoning and all available tools to solve the problem.

You must consider edge cases and follow best coding practices for everything.
Never do bandaid fixes. Always ultrathink.

## Problem Description

$ARGUMENTS

## Configuration

**IMPORTANT: Execute these steps SEQUENTIALLY - wait for each subagent to complete before starting the next one. NEVER run subagents in parallel.**

1. **Investigation Phase**
   - Use the `@task-medium-investigator` subagent with the full path of the `opencode-instance-{id}` directory
   - Wait for completion before proceeding

2. **Planning Phase**
   - Use the `@task-medium-planner` subagent with the full path of the `opencode-instance-{id}` directory
   - Wait for completion before proceeding

3. **Review and Execute**
   - Enter plan mode and read the `PLAN.md` file from the opencode-instance directory
   - Present the plan to the user for approval
   - NEVER automatically execute the plan. The user MUST review it first.

Note: This command follows the same workflow as the original Claude Code task_medium, but adapted for OpenCode's subagent system with proper file-based workflow preservation.