---
description: "Review code changes, generate quality report, and display CLI summary"
agent: build
---

# Code Review

Perform a comprehensive code review of files with uncommitted changes and related files. Generate both a detailed `REVIEW.md` report with the format specified below and a concise CLI summary with file/line counts and issue summaries.

When invoked:

1. **Verify current branch** (do NOT switch branches at any point):
   ```bash
   git branch --show-current
   ```
   - If output is `main`, STOP and tell user: "Cannot review code on main branch. Please switch to a feature branch first using: git checkout -b feature/your-branch-name"
   - Store the branch name for reference in the review.

2. **Fetch latest main from remote** (this does NOT switch branches):
   ```bash
   git fetch origin main
   ```

3. **Get the diff as GitHub would see it** (three-dot syntax uses merge-base):
   ```bash
   git diff origin/main...HEAD
   ```

4. **Get file change statistics**:
   ```bash
   git diff --stat origin/main...HEAD
   ```

5. **Check for uncommitted changes**:
   ```bash
   git status
   ```

6. Focus on modified files compared to origin/main.
7. Thoroughly analyze the diff output to understand all implications.
8. Generate a comprehensive code review and save it to `REVIEW.md`.

## Review Checklist

- Code is simple and readable
- Functions and variables are well-named
- No duplicated code
- Proper error handling
- Input validation implemented
- Good test coverage
- Performance considerations addressed
- No bandaid fixes
- Security vulnerabilities
- Architecture and design patterns
- Consistency with codebase standards

## Output Format (save to `REVIEW.md`)

<prompt_md_example>
# Code Review Report

## 🔍 Summary

[Brief overview of the changes reviewed]

## 📊 Review Scope

- **Branch:** [Current branch name] (compared against origin/main)
- **Files Reviewed:** [Number] files
- **Lines Changed:** +[additions] -[deletions] 
- **Review Date:** [Current date]

## 🚨 Critical Issues (Must Fix)

### [Issue Title]
**File:** `path/to/file:line`
**Severity:** Critical

[Description of the issue]

**Problem:**
[Detailed explanation of what's wrong]

**Fix:**
```language
[Example of corrected code]
```

## ⚠️ Warnings (Should Fix)

### [Issue Title]
**File:** `path/to/file:line`
**Severity:** Warning

[Description and recommended fix]

## 💡 Suggestions (Consider Improving)

### [Suggestion Title]
**File:** `path/to/file:line`
**Impact:** Low/Medium/High

[Suggestion for improvement]

## ✅ Positive Aspects

[Things done well in the code]

## 📋 Security Analysis

[Security considerations and findings]

## 🏗️ Architecture & Design

[Assessment of architectural decisions and patterns]

## 🎯 Overall Assessment

**Code Quality:** [Excellent/Good/Fair/Poor]
**Security Posture:** [Strong/Adequate/Weak]
**Maintainability:** [High/Medium/Low]

**Recommendation:** [Approve/Request Changes/Block]

## 📝 Action Items

- [ ] [Specific action item 1]
- [ ] [Specific action item 2]

## 📚 Additional Notes

[Any additional context or considerations]
</prompt_md_example>

## Feedback Guidelines

- Be thorough but constructive
- Provide specific examples and solutions
- Focus on code quality, security, and maintainability
- Include file paths and line numbers for issues
- Organize feedback by priority level
- Remove sections that don't apply but keep all relevant ones

## CLI Summary Display

After analyzing the changes and writing the comprehensive review to `REVIEW.md`, display a concise CLI summary with:
- File and line counts from git diff
- Summary of critical issues, warnings, and suggestions
- Overall recommendation
- Path to the full REVIEW.md report

Example CLI output format:

<cli_example>
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
</cli_example>