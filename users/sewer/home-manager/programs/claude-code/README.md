# Claude Code Configuration

Advanced workflow management for Claude Code featuring custom commands, specialized AI agents, 
and automated task handling.

This is my personal configuration, but it's laid out in a way where you should be use it in a non-NixOS
repository as well.

## Features

### Custom Commands

- `/task_hard` - Multi-phase systematic problem solving with investigation, flow mapping, and planning
- `/task_easy` - Structured approach for straightforward problems
- `/code-review` - Comprehensive code review with security and quality checks  
- `/commit` - Keep a Changelog formatted commit messages

### Specialized AI Agents

- **investigator** - Code investigation specialist for understanding codebases
- **code-flow-mapper** - Maps execution paths and system architecture
- **planner** - Creates detailed implementation plans
- **code-reviewer** - Expert code review with prioritized feedback

### Automated Workflows

- **Hook System** - Automatic directory creation for task instances
- **MCP Integration** - Context7 and DeepWiki servers for enhanced capabilities
- **Structured Reporting** - Generates `INVESTIGATION_REPORT.md`, `FLOW_REPORT.md`, and `PLAN.md`

## Directory Structure

```
├── default.nix            # Nix configuration with settings and permissions
└── .claude/
    ├── agents/             # Specialized AI agents
    │   ├── investigator.md
    │   ├── code-flow-mapper.md
    │   ├── planner.md
    │   └── code-reviewer.md
    ├── commands/           # Custom slash commands
    │   ├── task_hard.md
    │   ├── task_easy.md
    │   ├── code-review.md
    │   └── commit.md
    └── hooks/              # Workflow automation hooks
        └── task_hard_prep_hook.py
```

## Usage

### Hard Task Solving (`/task_hard`)
For complex problems requiring systematic analysis:

1. **Investigation** - Understands codebase structure and dependencies
2. **Flow Mapping** - Traces execution paths and system architecture  
3. **Planning** - Creates detailed implementation strategy
4. **Review & Execute** - User approves plan before execution

Each phase generates comprehensive reports stored in `claude-instance-{id}/` directories.

### Code Review (`/code-review`)
Analyzes uncommitted changes and related files for:
- Code quality and readability
- Security vulnerabilities
- Performance considerations
- Best practice compliance
- Test coverage

### Commit Workflow (`/commit`)
Creates meaningful commits using Keep a Changelog categories:
- **Added** - New features
- **Changed** - Existing functionality changes
- **Fixed** - Bug fixes  
- **Security** - Vulnerability fixes
- **Removed** - Deleted features
- **Deprecated** - Soon-to-be removed features

## Configuration

This setup uses Nix for configuration management:
- **default.nix** - Contains all claude-code settings and permissions  
- **Python3** - Required for hooks (expected to be available system-wide)
- **Docker** - Required for GitHub MCP server integration

## MCP Server Integration

The configuration integrates with MCP servers for enhanced capabilities:
- **context7** - Library documentation  
- **mcp-deepwiki** - Auto-generated summary for any repository in the world
- **github** - GitHub repository integration (configured via Docker)