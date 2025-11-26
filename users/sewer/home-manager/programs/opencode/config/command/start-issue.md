---
description: "Discover issue templates and recommend appropriate write command"
agent: build
---

# Start Issue

Discover available issue templates and recommend the appropriate `/write-issue` command.

## Process

1. List files in `.github/ISSUE_TEMPLATE/` directory
2. Read each template file to understand its purpose
3. Based on user's description, select the most appropriate template
4. Return all templates with the recommended one highlighted

## Output Format

```
## Available Templates
- `.github/ISSUE_TEMPLATE/bug_report.md` - For reporting bugs
- `.github/ISSUE_TEMPLATE/feature_request.md` - For new features

## Recommendation
Template: `.github/ISSUE_TEMPLATE/bug_report.md`

Next step: `/write-issue .github/ISSUE_TEMPLATE/bug_report.md`
Or with investigation: `/write-issue-with-investigate .github/ISSUE_TEMPLATE/bug_report.md`
```

If no templates found, suggest `/write-issue-default-bug` or `/write-issue-default-feature`.

$ARGUMENTS
