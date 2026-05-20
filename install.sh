#!/usr/bin/env bash
set -euo pipefail

# Default installation mode
echo "✨ Installing 'please'..."

PLEASE_URL="https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/please.sh"
PLEASE_CONFIG_URL="https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/.please.config.example"

PLEASE_FILE="$HOME/.please.sh"
PLEASE_CONFIG_FILE="$HOME/.please.config"

PLEASE_RC_FILE="$HOME/.zshrc"

# Detect shell automatically
echo "🔍 Detected shell: ${SHELL##*/}"

# Download the main script
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/please.sh" -o "$PLEASE_FILE"
  curl -fsSL "$PLEASE_CONFIG_URL" -o "$PLEASE_CONFIG_FILE"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$PLEASE_FILE" "$PLEASE_URL"
  wget -qO "$PLEASE_CONFIG_FILE" "$PLEASE_CONFIG_URL"
else
  echo "❌ Neither curl nor wget found"
  exit 1
fi

chmod +x "$PLEASE_FILE"
echo "  • Main script: $PLEASE_FILE"
echo "  • Config example: $PLEASE_CONFIG_FILE"

# Configure shell
append_if_missing() {
  local file="$1"
  
  [ -f "$file" ] || return 0
  
  # Check if already sourced
  if grep -q "please.sh" "$file" 2>/dev/null; then
    echo "✔ Already configured in $file"
    return 0
  fi
  
  # Append configuration
  echo "" >> "$file"
  echo "# Load 'please' sudo wrapper (add 'source' here)" >> "$file"
  echo "[ -f \"$PLEASE_FILE\" ] && source \"$PLEASE_FILE\"" >> "$file"
  
  echo "✔ Added to $file"
}

append_if_missing "$PLEASE_RC_FILE"

# Installation complete
echo ""
echo "🎉 Installation complete!"
echo ""
echo "👉 The following files were installed/updated:"
echo "   • $PLEASE_FILE (main script)"
echo "   • $PLEASE_CONFIG_FILE (configuration example)"
echo "   • $(basename "$PLEASE_RC_FILE") (shell configuration)"
echo ""
echo "📖 Try these examples:"
echo "   please ls                    # Run any command with sudo"
echo "   please --help                # Show help menu"
echo "   please --dryrun ls          # Show without executing"
echo "   please --confirm ls         # Ask for confirmation first"
echo "   PLEASE_CONFIRM=1 please ls # Enable confirmation mode"
echo ""
echo "💡 Next steps:"
echo "   1. Reload your shell: source $PLEASE_RC_FILE"
echo "   2. Or restart your terminal"
echo "   3. Edit $PLEASE_CONFIG_FILE to customize safety rules"
