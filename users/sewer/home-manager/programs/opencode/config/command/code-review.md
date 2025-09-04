---
description: "Review code changes and generate quality report"
agent: build
model: anthropic/claude-sonnet-4-20250514
---

# Code Review Command

Perform a comprehensive code review of files with uncommitted changes and related files.

Use the `@code-reviewer` subagent to analyze only the files that have uncommitted changes and all files related to them.

The code reviewer will:
1. Run `git diff` to see recent changes
2. Focus on modified files and analyze them thoroughly  
3. Check for code quality, security, and maintainability issues
4. Generate a comprehensive REVIEW.md file with detailed findings

After the agent completes the review, display a concise CLI summary with:
- File and line counts from git diff
- Summary of critical issues, warnings, and suggestions
- Overall recommendation
- Path to the full REVIEW.md report

Example CLI output format:
```
# Code Review Summary

📊 **Files:** 5 reviewed | **Lines:** +127 -43

🚨 **Critical:** 2 issues
⚠️ **Warnings:** 4 issues  
💡 **Suggestions:** 3 items

## Top Issues
- Security: Hardcoded credentials in config.json:17
- Performance: Inefficient loop in utils.py:45

## Overall: Request Changes

📄 Full report: /path/to/current/directory/REVIEW.md
```