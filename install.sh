#!/usr/bin/env bash
set -euo pipefail

echo "✨ Installing 'please' (local install mode)..."

PLEASE_URL="https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/please.sh"

PLEASE_FILE="$HOME/.please.sh"

BASH_RC="$HOME/.bashrc"
ZSH_RC="$HOME/.zshrc"
PROFILE="$HOME/.profile"

echo "🔗 downloading from:"
echo "   $PLEASE_URL"

# Download the script once
if command -v curl >/dev/null 2>&1; then
  curl -fsSL "$PLEASE_URL" -o "$PLEASE_FILE"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$PLEASE_FILE" "$PLEASE_URL"
else
  echo "❌ neither curl nor wget found"
  exit 1
fi

chmod +x "$PLEASE_FILE"

echo "✔ saved to $PLEASE_FILE"

append_if_missing() {
  local file="$1"

  [ -f "$file" ] || return 0

  if grep -q "please.sh" "$file" 2>/dev/null; then
    echo "✔ already configured in $file"
    return 0
  fi

  echo "" >> "$file"
  echo "# load 'please' sudo wrapper" >> "$file"
  echo "[ -f \"$PLEASE_FILE\" ] && source \"$PLEASE_FILE\"" >> "$file"

  echo "✔ added to $file"
}

# Detect shell for nicer UX
echo "🔍 detected shell: ${SHELL##*/}"

append_if_missing "$BASH_RC"
append_if_missing "$ZSH_RC"
append_if_missing "$PROFILE"

echo ""
echo "🎉 installation complete!"
echo ""
echo "👉 restart your shell or run:"
echo "   source ~/.bashrc  (or ~/.zshrc)"
echo ""
echo "Try:"
echo "   please ls"
