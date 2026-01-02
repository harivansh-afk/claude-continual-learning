#!/bin/bash
# Continual Learning System Installer
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/harivansh-afk/claude-continual-learning/main/install.sh | bash
#   or: ./install.sh [target-dir]
#
# This installer:
#   1. Copies skills, commands, and hooks to your project's .claude/ directory
#   2. Configures the SessionEnd hook
#   3. Prompts you to run /setup-agent to initialize the agent
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Determine target directory
TARGET_DIR="${1:-.}"
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

# Determine script location (for local installs)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

# GitHub raw URL for remote downloads
REPO_RAW_URL="https://raw.githubusercontent.com/harivansh-afk/claude-continual-learning/main"

echo -e "${GREEN}Continual Learning System Installer${NC}"
echo "Installing to: $TARGET_DIR"
echo ""

# Check if .claude directory exists
if [ -d "$TARGET_DIR/.claude" ]; then
    echo -e "${YELLOW}Note: .claude directory already exists - will add missing files only${NC}"
fi

# Create directory structure
echo "Creating directory structure..."
mkdir -p "$TARGET_DIR/.claude/skills/codebase-agent"
mkdir -p "$TARGET_DIR/.claude/commands"
mkdir -p "$TARGET_DIR/.claude/hooks"

# Copy files
echo "Copying files..."

# Function to copy file from local or download from remote
# Only copies if destination doesn't exist (no overwrite)
copy_file() {
    local src="$1"
    local dest="$2"

    # Skip if destination already exists
    if [ -f "$dest" ]; then
        echo "  Skipping $(basename "$dest") - already exists"
        return 0
    fi

    if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/$src" ]; then
        # Local install
        cp "$SCRIPT_DIR/$src" "$dest"
        echo "  Added $(basename "$dest")"
    else
        # Remote install - download from GitHub
        if ! curl -fsSL "$REPO_RAW_URL/$src" -o "$dest"; then
            echo -e "${RED}Error: Failed to download $src${NC}"
            exit 1
        fi
        echo "  Added $(basename "$dest")"
    fi
}

copy_file "skills/codebase-agent/SKILL.md" "$TARGET_DIR/.claude/skills/codebase-agent/SKILL.md"
copy_file "skills/codebase-agent/learnings.md" "$TARGET_DIR/.claude/skills/codebase-agent/learnings.md"
copy_file "commands/setup-agent.md" "$TARGET_DIR/.claude/commands/setup-agent.md"
copy_file "commands/retrospective.md" "$TARGET_DIR/.claude/commands/retrospective.md"
copy_file "hooks/session-end.sh" "$TARGET_DIR/.claude/hooks/session-end.sh"

# Make hook executable (if it exists and was just copied)
if [ -f "$TARGET_DIR/.claude/hooks/session-end.sh" ]; then
    chmod +x "$TARGET_DIR/.claude/hooks/session-end.sh"
fi

# Handle settings.json
SETTINGS_FILE="$TARGET_DIR/.claude/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    # Check if SessionEnd hook is already configured
    if grep -q "session-end.sh" "$SETTINGS_FILE" 2>/dev/null; then
        echo "  Skipping settings.json - SessionEnd hook already configured"
    else
        echo ""
        echo -e "${YELLOW}Existing settings.json found. Please manually add the hook configuration:${NC}"
        echo ""
        cat << 'EOF'
Add to your .claude/settings.json hooks section:

"SessionEnd": [
  {
    "hooks": [
      {
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/session-end.sh\"",
        "timeout": 60
      }
    ]
  }
]
EOF
        echo ""
    fi
else
    # Create new settings.json
    echo "  Creating settings.json with SessionEnd hook"
    cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {
    "SessionEnd": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR/.claude/hooks/session-end.sh\"",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
EOF
fi

echo ""
echo -e "${GREEN}Installation complete!${NC}"
echo ""

# Change to target directory and run claude /setup-agent
cd "$TARGET_DIR"
if command -v claude &> /dev/null; then
    # Check if we have a TTY available (not piped via curl | bash)
    if [ -t 0 ]; then
        echo "Running setup-agent to initialize the learning agent..."
        echo ""
        claude --dangerously-skip-permissions /setup-agent
        echo ""
        echo "Setup complete! The agent will automatically learn from each session."
    else
        echo "To complete setup, run:"
        echo "  cd $TARGET_DIR && claude /setup-agent"
        echo ""
        echo "This will analyze your codebase and set up the learning agent."
    fi
else
    echo -e "${RED}Error: 'claude' command not found in PATH${NC}"
    echo "Please install Claude Code and run:"
    echo "  cd $TARGET_DIR && claude /setup-agent"
    exit 1
fi
