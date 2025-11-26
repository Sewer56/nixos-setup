---
description: "Generate comprehensive PR documentation"
agent: build
---

# Detailed PR Summary

You are a technical writer specializing in creating thorough pull request documentation.
Generate a comprehensive markdown file that fully documents all aspects of the changes.
Ultrathink to ensure you understand the changes to the best of your ability before summarizing.

## Process

When invoked:

1. **Verify current branch** (do NOT switch branches at any point):
   ```bash
   git branch --show-current
   ```
   - If output is `main`, STOP and tell user: "Cannot generate PR summary on main branch. Switch to a feature branch first."
   - Store the branch name for reference in the summary.

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

6. Thoroughly analyze the diff output to understand all implications.

7. Generate a `PR-SUMMARY.md` file with detailed documentation.

## Output Format

Save to `PR-SUMMARY.md`:

```markdown
## 📋 Summary

[One clear sentence describing what this PR does]

## 🎯 Purpose

[Detailed explanation of why these changes were made and what problem they solve]

## 📝 Changes

### ✨ Features
- [New features or capabilities added]

### 🐛 Bug Fixes
- [Any bugs fixed with issue references if applicable]

### ♻️ Refactoring
- [Refactoring changes and their benefits]

### 🔧 Configuration
- [Configuration changes and their implications]

### 📚 Documentation
- [Documentation updates]

### ✅ Tests
- [Test additions or improvements]

## 📁 Modified Files

| File               | Description                     |
| ------------------ | ------------------------------- |
| `path/to/file.ext` | Detailed description of changes |
| `another/file.ext` | What was modified and why       |

## 💥 Breaking Changes

[List any breaking changes with migration instructions, or skip section]

## 🔗 Dependencies

- **Added:** [New dependencies with versions and purpose]
- **Removed:** [Removed dependencies and why]
- **Updated:** [Updated dependencies with version changes]

## 📊 Impact Analysis

### 👥 User-Facing Changes
[Detailed description of visible changes to end users]

### ⚡ Performance Impact
[Analysis of performance implications, positive or negative]

### 🔒 Security Considerations
[Security improvements or considerations that reviewers should know]

### 🔄 Compatibility
[Backward compatibility notes, supported versions, etc.]

## 🧪 Testing

- [Description of how changes were tested]
- [Test coverage information]
- [Manual testing steps if applicable]

## 🗒️ Extra Notes

[Any special deployment considerations or steps]
```

## Guidelines

- Be thorough but organized - use sections to maintain readability
- Include all relevant technical details
- Provide context for complex changes
- Document any decisions or trade-offs made
- Include references to related issues or discussions
- Remove sections that don't apply but keep all that do
- Do not include bug fixes for new functionality in this PR; as those were never in a released version.

After analyzing the changes, write the summary to `PR-SUMMARY.md` and confirm the file is ready for GitHub.

$ARGUMENTS