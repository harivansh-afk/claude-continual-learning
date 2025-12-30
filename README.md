# Continual Learning System for Claude Code

A self-improving coding agent that learns from every session. Patterns, failures, edge cases, and insights are automatically extracted and stored, making the agent smarter over time.

## How It Works

```
Session 1: You code with Claude
    |
    v
SessionEnd Hook fires
    |
    v
/retrospective extracts learnings
    |
    v
learnings.md is updated
    |
    v
Session 2: Agent applies learnings from Session 1
    |
    v
(repeat - agent gets smarter each session)
```

## Quick Start

### 1. Install

```bash
# Clone this repo
git clone https://github.com/YOUR_ORG/continual-learning.git
cd continual-learning

# Install to your project
./install.sh /path/to/your/project
```

### 2. Set Up the Agent

```bash
cd /path/to/your/project
claude

# In Claude Code, run:
> /setup-agent
```

This analyzes your codebase and configures the agent with project-specific context.

### 3. Start Coding

Just work normally with Claude Code. After each session:
- The `SessionEnd` hook automatically runs
- `/retrospective` analyzes what happened
- New learnings are added to `learnings.md`
- Next session benefits from accumulated knowledge

## What Gets Installed

```
your-project/
+-- .claude/
    +-- skills/
    |   +-- codebase-agent/
    |       +-- SKILL.md        # Main agent skill
    |       +-- learnings.md    # Accumulated learnings (grows over time)
    |
    +-- commands/
    |   +-- setup-agent.md      # /setup-agent - Initial setup
    |   +-- retrospective.md    # /retrospective - Extract learnings
    |
    +-- hooks/
    |   +-- session-end.sh      # Auto-triggers after sessions
    |
    +-- settings.json           # Hook configuration
```

## Manual Commands

While learning happens automatically, you can also trigger it manually:

- `/setup-agent` - Re-analyze codebase and update skill context
- `/retrospective` - Manually run learning extraction

## Customization

### Adjust the Skill

Edit `.claude/skills/codebase-agent/SKILL.md` to:
- Add project-specific instructions
- Modify the agent's behavior
- Include additional context

### Adjust Learning Extraction

Edit `.claude/commands/retrospective.md` to:
- Change what categories of learnings to extract
- Modify the format of learnings
- Adjust selectivity (what gets saved vs skipped)

### Disable Automatic Learning

Remove the hook from `.claude/settings.json` to disable automatic learning.
You can still run `/retrospective` manually when you want.

## Requirements

- Claude Code (latest version)
- `jq` command-line tool (for parsing JSON in hooks)

Install jq if needed:
```bash
# macOS
brew install jq

# Ubuntu/Debian
apt-get install jq
```

## How Learnings Are Structured

Learnings in `learnings.md` are organized into categories:

- **Patterns**: Successful approaches to reuse
- **Failures**: Mistakes to avoid
- **Edge Cases**: Tricky scenarios to remember
- **Technology Insights**: Framework/library-specific knowledge
- **Conventions**: Project coding conventions

Each learning follows this format:

```markdown
### [Short Title]
- **Context**: When this applies
- **Learning**: The insight
- **Example**: Code snippet (optional)
```

## Philosophy

This system is based on the idea that:

1. **Agents should learn** - Not just follow static instructions
2. **Every session has insights** - Patterns, failures, edge cases
3. **Compounding knowledge** - Each session builds on previous ones
4. **Human-readable memory** - Learnings are plain markdown, easy to review/edit
5. **Shareable knowledge** - Commit learnings.md to git for team benefit

## Contributing

1. Fork the repo
2. Make changes
3. Test by installing to a real project
4. Submit a PR

## License

MIT
