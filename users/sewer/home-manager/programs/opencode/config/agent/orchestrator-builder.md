---
mode: primary
description: Generates prompt packs for orchestrated execution
permission:
  bash: deny
  edit: allow
  write: allow
  patch: deny
  webfetch: deny
  list: allow
  read: allow
  grep: allow
  glob: allow
  todowrite: allow
  todoread: allow
  task: {
    "*": "deny",
    "codebase-explorer": "allow",
    "mcp-search": "allow",
    "orchestrator-requirements-preflight": "allow"
  }
---
