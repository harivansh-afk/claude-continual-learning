---
description: Simplify overly complex code while preserving full functionality
allowed-tools: Read, Edit, Bash(git diff:*), Bash(git status:*), Grep, Glob
argument-hint: [staged|unstaged|both]
---

# Simplify Implementation

You are reviewing code you just wrote to simplify it. Claude has a tendency to over-engineer. Your job is to ruthlessly simplify while preserving full functionality.

## Context

Current git status: !`git status --short`

### Changes to Review

Based on the argument provided ($ARGUMENTS), review the appropriate diff:

- **staged** (or no argument): Review staged changes only
- **unstaged**: Review unstaged changes only
- **both**: Review all changes (staged and unstaged)

Staged changes: !`git diff --cached`
Unstaged changes: !`git diff`

## Simplification Principles

### Remove Over-Engineering

1. **Delete unnecessary abstractions**: If a function is called once, inline it
2. **Remove premature generalization**: Delete parameters, options, or config that aren't used
3. **Flatten unnecessary nesting**: Reduce indirection levels
4. **Kill dead code paths**: Remove conditionals that can't trigger
5. **Simplify error handling**: Don't catch errors you can't meaningfully handle
6. **Remove defensive coding against impossible states**: Trust internal code

### Prefer Direct Solutions

1. **Three lines > one abstraction**: Repeated simple code beats a premature helper
2. **Explicit > clever**: Readable beats compact
3. **Flat > nested**: Early returns, guard clauses
4. **Concrete > generic**: Solve the actual problem, not hypothetical ones
5. **Standard library > custom implementation**: Use built-ins when available

### Preserve

1. **All functionality**: The feature must work exactly as before
2. **Public interfaces**: Don't change signatures that external code depends on
3. **Test coverage**: Existing tests must still pass
4. **Actual error handling**: Keep meaningful error cases

## Your Task

1. **Analyze the diff**: Identify over-engineered patterns
2. **List simplifications**: For each issue, explain what's complex and how to simplify
3. **Apply changes**: Edit the files to simplify
4. **Verify**: Ensure functionality is preserved

## Output Format

For each simplification:
```
FILE: path/to/file.ts

ISSUE: [What's over-engineered]
BEFORE: [Brief description or code snippet]
AFTER: [Brief description or code snippet]
WHY: [Why this is simpler without losing functionality]
```

Then apply the edits.

## Red Flags to Watch For

- Functions with > 3 parameters (probably doing too much)
- Deeply nested callbacks or conditionals (flatten them)
- Abstract base classes with one implementation (delete the abstraction)
- Config objects for things that could be hardcoded
- Wrapper functions that just call another function
- Comments explaining what code does (code should be self-explanatory)
- Type definitions that duplicate structure (use inference)
- Utility functions used once (inline them)
- Try/catch that just re-throws or logs (let it bubble)
- Feature flags for features that are always on
