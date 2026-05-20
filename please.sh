# ~/.please.sh
# A polite sudo wrapper

please() {
  # basic guard
  if [ $# -eq 0 ]; then
    echo "🙏 you forgot what to run"
    echo "   usage: please <command> [args...]"
    return 1
  fi

  # optional: show what we're about to do
  echo "🙏 asking nicely..."

  # run command safely with all args preserved
  sudo "$@"
  local status=$?

  # friendly feedback
  if [ $status -ne 0 ]; then
    echo "❌ that didn't work (exit code: $status)"
    echo "💡 tip: check permissions or try running the command manually"
  else
    echo "✨ success!"
  fi

  return $status
}
