# Hard Task Solver

Use reasoning and all available tools to solve the problem.

You must consider edge cases and follow best coding practices for everything.
Never do bandaid fixes. Always ultrathink.

A `claude-instance-{id}` directory has been automatically created for you for this session.
This will store all information related to the task.

## Configuration

**IMPORTANT: Execute these steps SEQUENTIALLY - wait for each subagent to complete before starting the next one. NEVER run subagents in parallel.**

1. **Investigation Phase**
   - Use the `investigator` subagent with the full path of the `claude-instance-{id}` directory
   - Wait for completion before proceeding

2. **Flow Analysis Phase**
   - Use the `code-flow-mapper` subagent with the full path of the `claude-instance-{id}` directory
   - Wait for completion before proceeding

3. **Planning Phase**
   - Use the `planner` subagent with the full path of the `claude-instance-{id}` directory
   - Wait for completion before proceeding

4. **Review and Execute**
   - Enter plan mode and read the `PLAN.md` file
   - Present the plan to the user so they can accept or modify it.

The problem to solve is described below.

## The Problem

$ARGUMENTS