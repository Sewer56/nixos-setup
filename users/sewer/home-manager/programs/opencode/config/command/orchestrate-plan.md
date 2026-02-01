---
description: "Orchestrate a clarified plan"
agent: build
model: github-copilot/gpt-5.2-codex
---

# Orchestrate Plan

Use the plan from the immediately previous assistant message. Assume clarifications are done. Orchestrate a single prompt without any index.

think hard

## Workflow

### Phase 1: Parse the Plan
- Use the immediately previous assistant message as the plan input
- Accept any reasonable plan structure; extract objective, requirements, constraints, and ordered steps
- Choose a short, stable title for the prompt
- Tests: set to `basic` unless the plan explicitly says no tests

### Phase 2: Create Prompt File
- Create `PROMPT-01-{title}.md` in the current working directory using the prompt file format below
- Dependencies: None
- Implementation Hints: pull from the plan's steps and key details
- Required Reads: include minimal paths with brief relevance notes
- Findings: start empty; populate if you perform code discovery or library research

### Phase 3: Create Plan File
- Create a plan file named `<prompt_filename>-PLAN.md`
  - Example: `PROMPT-01-auth.md` -> `PROMPT-01-auth-PLAN.md`
- Use `PROMPT-01-{title}.md` as the source of truth
- Minimal code discovery only as needed to make steps concrete; otherwise reuse the plan details
- If additional code discovery is needed:
  - Use `@codebase-explorer` to find relevant files and patterns
  - Update the prompt's `# Required Reads` with new paths and relevance notes
  - Log each relevant/important discovery to `PROMPT-FINDING-<prompt-stem>-NN.md`
  - Update the prompt's `# Findings` list with each finding file and a one-line relevance note
- If external library/API details are needed, use `@mcp-search` and log findings the same way
- Apply discipline: smallest viable change, inline tiny helpers, avoid new files, avoid unnecessary abstractions, restrict visibility
- Do NOT modify the prompt file except to update `# Required Reads` and `# Findings`

### Phase 4: Plan Review (Parallel)
- Spawn `@orchestrator-plan-reviewer-glm` and `@orchestrator-plan-reviewer-gpt5` in parallel
- Inputs: `prompt_path`, `plan_path`
- Plan approved only if BOTH reviewers approve
- If either reviewer requests changes:
  - Distill feedback
  - Revise the plan file (add `## Reviewer Concerns (Revision)` at the top and update `## Plan Notes` revision history)
  - Re-run both reviewers (max 2 iterations)
- If still not approved, report failure and stop

### Phase 5: Implementation
- Route coder: `@orchestrator-coder`
- Inputs: `prompt_path`, `plan_path`, one-line task intent
- Parse the coder response as `# CODER RESULT` to extract Status and Coder Notes Path
- Read the coder notes file and extract concerns, related files, and issues remaining from the latest iteration
- If the coder response or notes are missing required fields, re-run coder and request corrected output
- If Status is FAIL or ESCALATE:
  - Distill escalation details (if present) and issues encountered/remaining
  - Revise the plan and re-run plan review
  - Retry implementation (max 3 attempts)
  - If still failing, report failure and stop

### Phase 6: Quality Gate (Loop <= 3)
- Build review context: task intent, coder concerns and related files (from coder notes)
- Reviewers: `@orchestrator-quality-gate-glm` and `@orchestrator-quality-gate-gpt5`
- Do NOT pass the plan file to reviewers
- Do not pass coder notes; reviewers derive and read `-CODER-NOTES.md` directly
- If FAIL or PARTIAL:
  - Distill issues
  - Re-invoke coder with feedback
  - Re-run gate
- Max 3 iterations
- If still FAIL or PARTIAL after max iterations, proceed to commit and report Status: INCOMPLETE

### Phase 7: Commit
- Spawn `@commit` with `prompt_path` and a short bullet summary of key changes
- Do not include `PROMPT-*` files in commits

### Phase 8: Hand Off
- Provide a concise status summary of each phase and final outcome
- Status: SUCCESS | FAIL | INCOMPLETE

## Prompt File Format: `PROMPT-01-{title}.md`

```markdown
# Mission
[1-2 sentence overall goal for this task]

# Objective
[What specifically needs to be achieved]

# Context
[Relevant background and current situation]

# Required Reads
- path/to/file: [Why this file is relevant]

# Requirements
- [Specific, measurable requirements]
- [Expected behaviors and outcomes]

# Constraints
- [Technical constraints]
- [What to avoid]

# Success Criteria
- [How we'll know the objective is met]

# Scope
- IN: [what's in scope]
- OUT: [what's out of scope]

# Tests
basic

# Dependencies
None

# Clarifications
Q: <question>
A: <answer>

# Findings
- PROMPT-FINDING-<prompt-stem>-01.md: <one-line relevance>

# Implementation Hints
- [Discovered patterns, library usage, existing code to reuse]
- [Actionable guidance for planner/coder]
```

## Planner-Style Plan File Format

Write this to `<prompt_filename>-PLAN.md`:

```markdown
# Plan

## Reviewer Concerns (Revision)
- [ ] Address <concern>

## Plan Notes

### Summary
- <short overview of intent and risks>

### Assumptions
- <assumptions made while planning>

### Risks and Open Questions
- <unknowns or potential blockers>

### Review Focus
- <areas reviewers should scrutinize>

### Revision History
- Iteration <n>: <what changed and why>

## Types

### User
Core domain entity representing a registered user.

```rust
struct User {
    id: Uuid,
    email: String,
    created_at: DateTime<Utc>,
}
```

### CreateUserInput
Input DTO for user creation endpoint.

```rust
struct CreateUserInput {
    email: String,
}
```

### UserError
Error variants for user operations.

```rust
enum UserError {
    DuplicateEmail(String),
    InvalidEmail,
}
```

## External Symbols

Map files to required `use` statements.

- `src/services/user.rs`:
  - `use crate::repository::user::UserRepository;`
  - `use serde::Serialize;`

## Implementation Steps

### src/services/user.rs

Add UserService impl:

```rust
impl UserService {
    pub fn new(repo: Arc<dyn UserRepository>) -> Self {
        Self { repo }
    }

    pub async fn create_user(&self, input: CreateUserInput) -> Result<User, UserError> {
        if self.repo.find_by_email(&input.email).await?.is_some() {
            return Err(UserError::DuplicateEmail(input.email));
        }
        let user = User {
            id: Uuid::new_v4(),
            email: input.email,
            created_at: Utc::now(),
        };
        self.repo.create(&user).await?;
        Ok(user)
    }
}
```

### src/repository/user.rs

Add find_by_email to UserRepository trait and impl:

```rust
// In trait:
async fn find_by_email(&self, email: &str) -> Result<Option<User>, DbError>;

// In impl:
async fn find_by_email(&self, email: &str) -> Result<Option<User>, DbError> {
    sqlx::query_as!(User, "SELECT * FROM users WHERE email = $1", email)
        .fetch_optional(&self.pool)
        .await
        .map_err(DbError::from)
}
```

### src/validation.rs

Modify validate_email to handle edge case:

```rust
// Before:
pub fn validate_email(email: &str) -> bool {
    EMAIL_REGEX.is_match(email)
}

// After:
pub fn validate_email(email: &str) -> bool {
    if email.is_empty() || email.len() > 254 {
        return false;
    }
    EMAIL_REGEX.is_match(&email.to_lowercase().trim())
}
```

## Test Steps

### tests/user_service.rs

```rust
#[tokio::test]
async fn create_user_returns_user_with_id() {
    let service = setup_test_service().await;
    let user = service.create_user(CreateUserInput { 
        email: "test@example.com".into() 
    }).await.unwrap();
    assert!(!user.id.is_nil());
}

#[tokio::test]
async fn create_user_rejects_duplicate_email() {
    let service = setup_test_service().await;
    service.create_user(CreateUserInput { email: "dupe@example.com".into() }).await.unwrap();
    let result = service.create_user(CreateUserInput { email: "dupe@example.com".into() }).await;
    assert!(matches!(result, Err(UserError::DuplicateEmail(_))));
}
```
```

## Findings File Format: `PROMPT-FINDING-<prompt-stem>-NN.md`

```markdown
# Prompt Finding

Query: <what was searched or inspected>

## Summary
- <concise, reusable facts>

## Details
- <key API signatures, constraints, or patterns>

## Relevant Paths
- path/to/file

## Links
- https://example.com/docs
```

# Output
Final message must contain:
- Absolute path to the plan file (the new `-PLAN.md` file)
