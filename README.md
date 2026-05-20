<div align="center">

# 🙏 please.sh

**A polite sudo wrapper with built-in security — command validation, denylist, dry-run, confirmation, and timeout protection**

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-POSIX-brightgreen)](https://en.wikipedia.org/wiki/POSIX)
[![Platform](https://img.shields.io/badge/platform-Linux%20|%20macOS%20|%20WSL-lightgrey)](https://github.com/Vicedomini-Softworks/please.sh)
[![GitHub Repo](https://img.shields.io/badge/GitHub-please.sh-181717?logo=github)](https://github.com/Vicedomini-Softworks/please.sh)

[Install](#-installation) · [Usage](#-usage) · [Security Features](#-security-features) · [Configuration](#%EF%B8%8F-configuration) · [GitHub](https://github.com/Vicedomini-Softworks/please.sh)

---

</div>

## 🙏 What Is please.sh?

**please.sh** is an open-source shell function that replaces `sudo` with a safer, friendlier alternative. Every command is validated against a configurable denylist before execution, and optional dry-run and confirmation modes help prevent costly mistakes.

Instead of typing `sudo command`, you type `please command`:

- 🔎 **Validates** the command exists before calling sudo
- 🛑 **Blocks** dangerous commands like `rm` by default
- 👁️ **Previews** the full command: `⚠️ About to run: sudo apt update`
- 🧪 **Dry-Run** mode: preview without executing
- ✅ **Confirmation** prompts: require typing `YES` to proceed
- ⏰ **Timeout** protection: kill hanging commands automatically
- ✨ **Clear feedback**: know instantly if it worked

It's sudo with manners — *and* a safety net.

---

## 📦 Installation

### Quick Install (One Liner)

```bash
# Download and source please.sh
curl -fsSL https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/please.sh -o ~/.please.sh
echo '[ -f "$HOME/.please.sh" ] && source "$HOME/.please.sh"' >> ~/.zshrc
source ~/.zshrc
```

### Optional: Safety Config

```bash
curl -fsSL https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/.please.config.example -o ~/.please.config
```

### Or Use the Installer

```bash
curl https://raw.githubusercontent.com/Vicedomini-Softworks/please.sh/refs/heads/main/install.sh | bash
```

> ⚠️ **Security Note:** `rm` is blocked by default. To unblock it, remove `rm` from `PLEASE_DENYLIST` in `~/.please.config`.

---

## 🚀 Usage

### Basic Usage

Replace `sudo` with `please`:

```bash
please apt update
```

```
$ please apt update
⚠️ About to run: sudo apt update
[sudo] password for you:
... output ...
✨ Success!
```

### Dry-Run Mode (Preview Without Executing)

```bash
please --dryrun apt update
please -d apt update
```

```
$ please --dryrun apt update
⚠️ About to run: sudo apt update
➡️  Dry-run mode enabled. Not executing.
```

### Confirmation Mode

```bash
please --confirm rm file
please -c rm file
```

```
$ please --confirm rm file
⚠️ About to run: sudo rm file
⚠️  Type 'YES' to execute: YES
... executes ...
✨ Success!
```

### Denylist in Action

```bash
$ please rm -rf /
❌ Command blocked by safety policy: rm
   This command is in the deny list.
```

---

## 🔒 Security Features

| Feature | Description | How to Enable |
|---------|-------------|---------------|
| **Denylist** | Block dangerous commands (`rm`, `dd`, `shred`, etc.) | `PLEASE_DENYLIST="rm,dd"` or config file |
| **Allowlist** | Restrict to approved commands only | `PLEASE_ALLOWLIST="apt,systemctl"` |
| **Dry-Run** | Preview commands without executing | `please --dryrun` or `PLEASE_DRYRUN=1` |
| **Confirmation** | Require typing `YES` to proceed | `please --confirm` or `PLEASE_CONFIRM=1` |
| **Timeout** | Auto-kill hanging commands | `PLEASE_TIMEOUT=30` (seconds) |
| **Command Validation** | Verify command exists before sudo | Always on |

---

## ⚙️ Configuration

### Environment Variables

Set these in your `~/.zshrc` or `~/.bashrc`:

```bash
export PLEASE_CONFIRM=1       # Require confirmation for every command
export PLEASE_DRYRUN=0        # Disable dry-run by default
export PLEASE_TIMEOUT=30      # Kill commands after 30 seconds
export PLEASE_DENYLIST="rm,dd,shred"  # Block these commands
export PLEASE_ALLOWLIST=""    # Empty = allow any (except denylist)
```

### Config File (`~/.please.config`)

```bash
# ~/.please.config
PLEASE_DENYLIST="rm,dd,shred,chmod"
PLEASE_ALLOWLIST="apt,systemctl,service"
PLEASE_CONFIRM=1
PLEASE_DRYRUN=0
PLEASE_TIMEOUT=30
```

### Command-Line Flags

```bash
please --help              # Show full help
please --dryrun apt update # Preview without executing
please -d apt update       # Short form
please --confirm rm file   # Require YES confirmation
please -c rm file          # Short form
```

---

## 🎯 Why Use please.sh?

- **Friendly Vibes** — Your terminal should be nice to you. Polite messages and clear feedback.
- **Safety First** — Blocks dangerous commands by default, validates before execution.
- **Clear Feedback** — Know what's about to run and whether it succeeded.
- **Zero Learning Curve** — Just type `please` instead of `sudo`. All arguments preserved.
- **Lightweight** — Single shell function, zero dependencies. Works on Linux, macOS, and WSL.
- **Open Source** — MIT licensed. [Contribute on GitHub](https://github.com/Vicedomini-Softworks/please.sh).

---

## 🤔 How It Works

**please.sh** is a simple shell function that wraps `sudo` with multiple safety layers:

1. **Validates** the command exists on your system
2. **Checks** the command against your denylist and allowlist
3. **Previews** the full sudo command
4. **Optionally** pauses for dry-run or confirmation
5. **Executes** with timeout protection (if configured)
6. **Reports** success or failure with the exit code

```bash
please() {
  command -v "$1"        # 1. Does the command exist?
  check denylist         # 2. Is it allowed?
  echo "About to run"    # 3. Show what's happening
  read confirmation      # 4. Ask for approval (optional)
  timeout ... sudo "$@"  # 5. Execute with guardrails
  report status          # 6. Tell you the result
}
```

The `"$@"` syntax preserves all arguments, so `please apt update` runs `sudo apt update` with perfect fidelity.

---

## 🛠️ Customization

### Quick Message Customization

Edit `~/.please.sh` to change the output messages:

```bash
# Make it sassier
please() {
  [ $# -eq 0 ] && echo "🙄 I need a command, genius" && return 1
  echo "🥺 *puppy eyes* Running with sudo..."
  sudo "$@" && echo "🎉 you're welcome" || echo "💀 oopsie"
}
```

---

## 🐛 Troubleshooting

**Q: `please: command not found`**
A: Make sure you sourced the script or restarted your shell.

**Q: Still asking for the sudo password every time**
A: That's sudo's behavior, not **please.sh**. Configure `/etc/sudoers` if you want passwordless sudo.

**Q: Can I use this with fish, zsh, or bash?**
A: Yes! It works in any POSIX-compatible shell — bash, zsh, dash, and more.

**Q: `rm` is blocked — how do I use it?**
A: Use `sudo rm` directly, or remove `rm` from `PLEASE_DENYLIST` in `~/.please.config`.

**Q: The confirmation prompt hangs in scripts**
A: **please.sh** automatically detects non-interactive mode and skips the confirmation prompt.

**Q: How do I contribute or report a bug?**
A: Open an issue or pull request on [GitHub](https://github.com/Vicedomini-Softworks/please.sh).

---

## 📝 License

MIT License. Copyright © 2026 [Vicedomini Softworks](https://vicedominisoftworks.com)

See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

Made with 💖 and a tad of fun by [Vicedomini Softworks](https://vicedominisoftworks.com)

Because terminals deserve kindness too.

> *"I used to be aggressive like you, but then I installed please.sh"*
> — Some terminal, probably

---

<p align="center">
  <a href="https://github.com/Vicedomini-Softworks/please.sh">GitHub Repository</a>
  &nbsp;·&nbsp;
  <a href="https://vicedomini-softworks.github.io/please.sh/">GitHub Pages Site</a>
  &nbsp;·&nbsp;
  <a href="https://github.com/Vicedomini-Softworks/please.sh/issues">Report an Issue</a>
</p>
