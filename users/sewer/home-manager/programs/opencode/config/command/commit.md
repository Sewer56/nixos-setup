---
description: "Create semantic commits following changelog format"
---

# Commit Changes

Create meaningful commits following `Keep a Changelog` format.

## Process:

1. Check current git diff to understand changes
2. Create commit messages based on Keep a Changelog categories:
   - **Added** for new features
   - **Changed** for changes in existing functionality  
   - **Deprecated** for soon-to-be removed features
   - **Removed** for now removed features
   - **Fixed** for any bug fixes
   - **Security** for vulnerability fixes

## Guidelines:

- Changelogs are for humans, not machines.
- Use clear, descriptive commit messages
- Focus on what changed and why
- Group related changes logically
- Commit and push when ready

## Format:
```
[Category]: Brief description of changes

More detailed explanation if needed.
```

Examples:
- `Added: User authentication system with JWT tokens`
- `Fixed: Memory leak in image processing module`  
- `Changed: Database schema to support new user roles`

Follow [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) principles for clear, maintainable commit history.