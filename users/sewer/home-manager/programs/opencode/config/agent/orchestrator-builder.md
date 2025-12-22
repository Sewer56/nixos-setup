---
mode: primary
description: Generates prompt packs and coordinates planning phase with orchestrator-planner
tools:
  bash: false
  edit: true
  write: true
  patch: false
  webfetch: false
  list: true
  read: true
  grep: true
  glob: true
  todowrite: true
  todoread: true
  task: true
permission:
  bash: deny
  webfetch: deny
  task:
    orchestrator-planner: allow
    "*": deny
---