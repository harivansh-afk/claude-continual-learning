# Continual Learning System for Claude Code

A self-improving coding agent that learns from every session. Patterns, failures, edge cases, and insights are automatically extracted and stored, making the agent smarter over time.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/harivansh-afk/claude-continual-learning/main/install.sh | bash
```

Or clone and install manually:

```bash
git clone https://github.com/harivansh-afk/claude-continual-learning.git
cd continual-learning
./install.sh /path/to/your/project
```

## Setup

After installing, run the setup command in Claude Code:

```
/setup-agent
```

## How It Works

1. You code with Claude as normal
2. SessionEnd hook fires after each session
3. Learnings are automatically extracted and stored
4. Next session benefits from accumulated knowledge

## Requirements

- Claude Code (latest version)
- `jq` command-line tool

## License

MIT
