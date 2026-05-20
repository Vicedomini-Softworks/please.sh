# please.sh

**A sudo wrapper that asks permission first (from you, to your terminal)**

---

## 🙏 What is this?

`please` is a shell function that makes your terminal more polite. Instead of just running `sudo command`, you now run `please command` and your terminal will:

1. Say "🙏 asking nicely..." before running your command
2. Say "✨ success!" if it works
3. Say "❌ that didn't work" if it fails (with helpful tips)

It's sudo, but with manners.

---

## 📦 Installation

### Quick Install

```bash
# Download and source it
curl -fsSL https://raw.githubusercontent.com/yourusername/please-sh/main/please.sh -o ~/.please.sh
echo '[ -f "$HOME/.please.sh" ] && source "$HOME/.please.sh"' >> ~/.zshrc
source ~/.zshrc
```

### Or use the installer

```bash
# Edit install.sh to point to your hosted script first!
curl -fsSL https://raw.githubusercontent.com/yourusername/please-sh/main/install.sh | bash
```

⚠️ **Important:** Edit `install.sh` and change the URL to wherever you host your script before running it!

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
- **Lightweight**: It's 28 lines of bash. That's it.

---

## 🤔 How does it work?

It's literally just a shell function:

```bash
please() {
  echo "🙏 asking nicely..."
  sudo "$@"
  # ... friendly feedback ...
}
```

The `"$@"` preserves all your arguments, so `please apt update` becomes `sudo apt update` under the hood.

---

## 🛠️ Customization

Want to change the messages? Edit `~/.please.sh`:

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
A: Make sure you sourced the script or restarted your shell

**Q: Still asking for password every time**
A: That's sudo's behavior, not `please`. Configure `/etc/sudoers` if you want passwordless sudo

**Q: Can I use this with fish/zsh/bash?**
A: Yes! It works in any POSIX shell that supports functions

---

## 📝 License

Do whatever you want with it. It's 28 lines. Just don't claim it's yours.

---

## 🙏 Acknowledgments

Made with 💖 and a tad of fun by [Vicedomini Softworks](https://vicedominisoftworks.com)

Because terminals deserve kindness too.

---

> *"I used to be aggressive like you, but then I installed please.sh"*
> — Some terminal, probably
