# ~/.please.sh
# A secure sudo wrapper that asks permission first

# Load user config (silently skip if absent)
[ -f "$HOME/.please.config" ] && . "$HOME/.please.config"

please() {
  local dryrun=0
  local confirm=0
  local rc=0
  
  # Check if first arg is a flag (starting with -)
  if [ $# -gt 0 ] && [ "$1" != "${1#-}" ]; then
    case "$1" in
      --dryrun|-d)
        dryrun=1
        shift
        ;;
      --confirm|-c)
        confirm=1
        shift
        ;;
      --help|-h)
        echo "Usage: please [--dryrun|-d] [--confirm|-c] <command> [args...]"
        echo ""
        echo "Options:"
        echo "  --dryrun, -d   Show command without executing"
        echo "  --confirm, -c  Ask for confirmation before executing"
        echo ""
        echo "Environment Variables:"
        echo "  PLEASE_DRYRUN=1      Enable dry-run mode (equivalent to --dryrun)"
        echo "  PLEASE_CONFIRM=1     Enable confirmation prompt (equivalent to --confirm)"
        echo "  PLEASE_ALLOWLIST="    Comma-separated list of allowed commands"
        echo "  PLEASE_DENYLIST="rm  Comma-separated list of denied commands"
        echo "  PLEASE_TIMEOUT=30     Timeout in seconds for commands"
        echo ""
        echo "Configuration File (~/.please.config):"
        echo "  PLEASE_ALLOWLIST=\"\"       Comma-separated list of allowed commands"
        echo "  PLEASE_DENYLIST=\"rm\"      Comma-separated list of denied commands"
        echo "  PLEASE_CONFIRM=0           Enable confirmation prompt"
        echo "  PLEASE_DRYRUN=0            Enable dry-run mode by default"
        echo "  PLEASE_TIMEOUT=30          Timeout in seconds"
        echo ""
        echo "Config file is sourced automatically if present."
        return 0
        ;;
    esac
  fi

  # basic guard
  if [ $# -eq 0 ]; then
    echo "🙏 You forgot what to run"
    echo "   Usage: please <command> [args...]"
    echo "   Type 'please -h' for help"
    return 1
  fi

  # Check if command exists before attempting sudo
  if ! command -v "${1%% *}" >/dev/null 2>&1; then
    echo "❌ Command not found: $1"
    echo "   Please install the required package or check the command name"
    return 127
  fi

  # Check for dangerous commands via allowlist/denylist
  local cmd="${1%% *}"
  local allowlist="${PLEASE_ALLOWLIST:-}"
  local denylist="${PLEASE_DENYLIST:-rm}"
  
  # Check denylist
  if echo "$denylist" | tr ',' '\n' | grep -qx "$cmd"; then
    echo "❌ Command blocked by safety policy: $cmd"
    echo "   This command is in the deny list. Type 'please --help' to customize"
    return 1
  fi
  
  # Check allowlist only if allowlist is set
  if [ -n "$allowlist" ] && ! echo "$allowlist" | tr ',' '\n' | grep -qx "$cmd"; then
    echo "❌ Command not in allow list: $cmd"
    echo "   Allowed commands: $allowlist"
    echo "   Type 'please --help' to customize allowlist"
    return 1
  fi

  # Show what we're about to do
  echo "⚠️ About to run: sudo $*"
  
  # Dry-run mode
  if [ $dryrun -eq 1 ] || [ "${PLEASE_DRYRUN:-}" = "1" ]; then
    echo "➡️  Dry-run mode enabled. Not executing."
    return 0
  fi

  # Confirmation mode
  if [ $confirm -eq 1 ] || [ "${PLEASE_CONFIRM:-}" = "1" ]; then
    if [ ! -t 0 ]; then
      echo "⚠️  Non-interactive mode detected, skipping confirmation"
    else
      printf "⚠️  Type 'YES' to execute: "
      read -r confirmation
      if [ "$confirmation" != "YES" ]; then
        echo "❌ Aborted by user"
        return 1
      fi
    fi
  fi

  # Execute with timeout if configured
  if [ -n "${PLEASE_TIMEOUT:-}" ]; then
    if command -v timeout >/dev/null 2>&1; then
      timeout "${PLEASE_TIMEOUT}"s sudo "$@"
      rc=$?
    else
      echo "⚠️ timeout command not available, running without timeout"
      sudo "$@"
      rc=$?
    fi
    
    # Timeout exit codes: 124=timeout, 137=SIGKILL
    if [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ]; then
      echo "⏰ Command timed out or was killed (exit code: $rc)"
      return 1
    fi
  else
    sudo "$@"
    rc=$?
  fi

  # friendly feedback
  if [ $rc -eq 0 ]; then
    echo "✨ Success!"
  else
    case $rc in
      1)
        echo "❌ Command failed (exit code: $rc)"
        echo "💡 Tip: Check permissions or try running the command manually"
        ;;
      *)
        echo "❌ Failed with exit code: $rc"
        ;;
    esac
  fi

  return $rc
}
