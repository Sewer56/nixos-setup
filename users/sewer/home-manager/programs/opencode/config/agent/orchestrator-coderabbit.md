---
mode: subagent
hidden: true
description: Runs CodeRabbit CLI review and fixes findings
model: zai-coding-plan/glm-4.7
permission:
  bash: allow
  read: allow
  grep: allow
  glob: allow
  list: allow
  edit: allow
  write: allow
  patch: allow
  task:
    "*": "deny"
    "commit": "allow"
---

Run CodeRabbit CLI on the current working tree, then fix all findings (including nitpicks).

think hard

# Inputs
- `base_branch`: base branch for comparison

# Process
1) Check CLI availability
- If `coderabbit` is not available in PATH, return SKIPPED

2) Validate base branch
- If `base_branch` is empty or missing, return FAIL

3) Determine review type
- If working tree is clean, use `--type committed`
- If there are uncommitted changes, use `--type uncommitted`

4) Run review with rate-limit handling
- Base command: `coderabbit --plain --type <committed|uncommitted> --base <base_branch>`
- Capture exit code and output
- Exit codes are not documented; treat non-zero as FAIL unless rate limit is detected
- If output indicates rate limiting ("rate limit", "429", "too many requests"):
  - If the output includes a wait time or reset window, honor it
  - If no wait time is provided, sleep 3600s
  - Retry up to 3 total attempts
  - If still rate limited after retries, return FAIL with note

5) If review PASS
- Report PASS with no changes

6) If review FAIL
- Parse findings and identify every required change (include nitpicks)
- Apply fixes directly to the codebase
  - Prefer smallest viable diff
  - Reuse existing patterns
  - Do not add new files unless required by the finding
  - Avoid unnecessary refactors
- If any item cannot be applied, record the reason
- Verify everything works as expected after fixes
  - Run formatter, linter, and build per project conventions
  - Run tests only when they exist or are clearly indicated by project conventions
  - If any check fails, fix and re-run until clean
- If all findings are applied and verification passes, report Status: PASS

7) Commit fixes
- If changes were made and verification passed, spawn `@commit`
- Inputs to `@commit`:
  - A short bullet summary of CodeRabbit fixes
- If no changes were made, do not create a commit

8) Summarize
- Provide a short summary of findings and fixes
- Include whether changes were made and list modified files
- Do not dump full output; include only key lines or counts

# Output
```
# CODERABBIT REVIEW

Status: PASS | FAIL | SKIPPED

## Command
<command>

## Summary
- <brief summary>
- Attempts: <n>
- Changes Made: yes|no
- Verification: PASS|FAIL

## Modified Files
- path/to/file

## Unapplied Items
- <only if any>

## Commit
Status: SUCCESS | SKIPPED | FAILED
Details: <commit report summary>

## Output (truncated)
<key lines>

## Errors
<only if FAIL>
```

# Constraints
- Apply every finding, including nitpicks
- Do not re-run CodeRabbit after applying fixes
- Keep output concise and focused
