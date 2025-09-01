# Medium Task Solver

Use reasoning and all available tools to solve the problem.

You must consider edge cases and follow best coding practices for everything.
Never do bandaid fixes. Always ultrathink.

## Configuration

**IMPORTANT: Execute these steps SEQUENTIALLY - wait for each subagent to complete before starting the next one. NEVER run subagents in parallel.**

1. **Investigation Phase**
   - Use the `investigator` subagent with the full path of the `claude-instance-{id}` directory
   - Wait for completion before proceeding

2. **Planning Phase**
   - Use the `planner` subagent with the full path of the `claude-instance-{id}` directory
   - Wait for completion before proceeding

3. **Review and Execute**
   - Enter plan mode and read the `PLAN.md` file
   - Present the plan to the user so they can accept or modify it.