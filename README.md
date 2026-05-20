# please.sh

**A sudo wrapper that asks permission first (from you, to your terminal)**

---

## 🙏 What is this?

`please` is a shell function that makes your terminal more polite. Instead of just running `sudo command`, you now run `please command` and your terminal will:

1. Say "⚠️ About to run: sudo ..." showing the exact command
2. Say "✨ Success!" if it works or "❌ ..." with details if it fails
3. Validates commands exist before running
4. Blocks dangerous commands by default (like `rm`)
5. Offers dry-run, confirmation, and timeout protection

It's sudo, but with manners.

---

## 📦 Installation

### Quick Install

```bash
# Download and source it
curl -fsSL https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/please.sh -o ~/.please.sh
echo '[ -f "$HOME/.please.sh" ] && source "$HOME/.please.sh"' >> ~/.zshrc
source ~/.zshrc
```

### Or use the installer

```bash
curl https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/install.sh | bash
```

---

## 🚀 Usage

```bash
# Instead of this:
sudo apt update

# Do this:
please apt update

# Output:
# 🙏 asking nicely...
# [sudo] password for you:
# ... command runs ...
# ✨ success!
```

---

## 🎯 Why would I use this?

- **Friendly vibes**: Your terminal should be nice to you
- **Clear feedback**: You always know if something worked or not
- **Zero learning curve**: Just type `please` instead of `sudo`
- **Meme potential**: Tell your friends you "ask nicely" before running sudo commands
- **Lightweight**: Minimal shell function, zero dependencies

---

## 🤔 How does it work?

It's literally just a shell function that:

1. **Validates** your command exists
2. **Secures** by checking allowlist/denylist
3. **Previews** the sudo command: `⚠️ About to run: sudo apt update`
4. **Protects** with dry-run, confirmation, and timeout options
5. **Executes** safely with proper argument preservation

```bash
please() {
  # Validates command exists
  if ! command -v "${1%% *}" >/dev/null 2>&1; then ... fi
  
  # Checks denylist/allowlist for safety
  if [ -n "$denylist" ] && echo "$denylist" | tr ',' '\n' | grep -qx "$cmd"; then ... fi
  
  # Shows: "⚠️ About to run: sudo apt update"
  echo "⚠️ About to run: sudo $*"
  
  # Optional dry-run confirmation, timeout handling...
  
  sudo "$@"  # Safe argument forwarding with "$@"
  # Returns proper exit code
}
```

The `"$@"` preserves all your arguments, so `please apt update` becomes `sudo apt update` with perfect fidelity.

---

## 🛠️ Customization

### Quick Message Customization

Want to change the messages? Edit `~/.please.sh`:

```bash
# Make it sassier
please() {
  [ $# -eq 0 ] && echo "🙄 I need a command, genius" && return 1
  echo "🥺 *puppy eyes* Running with sudo..."
  sudo "$@" && echo "🎉 you're welcome" || echo "💀 oopsie"
}
```


### Advanced Configuration with Safety Rules

For **command restrictions, confirmations, and timeouts**, create `~/.please.config`:

```bash
# ~/.please.config - Safety rules for please.sh

# Allow only specific commands (safer)
PLEASE_ALLOWLIST="apt,systemctl,service"

# Block dangerous commands
PLEASE_DENYLIST="rm,dd,shred"

# Always ask for confirmation
PLEASE_CONFIRM=1

# Enable dry-run mode by default
PLEASE_DRYRUN=0

# Timeout commands after 60 seconds
PLEASE_TIMEOUT=60
```

Or use **environment variables** directly:

```bash
# Only allow specific commands
export PLEASE_ALLOWLIST="apt,systemctl"

# Always ask for confirmation
export PLEASE_CONFIRM=1

# Preview commands without executing
export PLEASE_DRYRUN=1

# Set a 30-second timeout
export PLEASE_TIMEOUT=30
```

### Command Line Options

```bash
# Show command but don't execute
please --dryrun apt update
please -d apt update

# Ask for confirmation before executing
please --confirm apt install
please -c apt install

# Show help
please --help
```


### Quick Command Examples

```bash
# Normal usage (original polite sudo)
please ls -la

# Preview without executing
please --dryrun apt update

# Require explicit confirmation
please --confirm apt dist-upgrade

# Enable confirm for all commands in session
export PLEASE_CONFIRM=1
please apt remove package
```

---

## 🐛 Troubleshooting

**Q: `please: command not found`**
A: Make sure you sourced the script or restarted your shell

**Q: Still asking for password every time**
A: That's sudo's behavior, not `please`. Configure `/etc/sudoers` if you want passwordless sudo

**Q: Can I use this with fish/zsh/bash?**
A: Yes! It works in any POSIX shell that supports functions

---

## 📝 License

MIT License. Copyright (c) 2026 Vicedomini Softworks

See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

Made with 💖 and a tad of fun by [Vicedomini Softworks](https://vicedominisoftworks.com)

Because terminals deserve kindness too.

---

> *"I used to be aggressive like you, but then I installed please.sh"*
> — Some terminal, probably
