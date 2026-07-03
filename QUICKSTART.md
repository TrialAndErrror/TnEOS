# TnEOS Quick Start

## 🚀 Super Quick Install (Recommended)

Copy and paste this single command:

```bash
curl -fsSL trialanderrror.com/install | bash
```

That's it! The script handles everything else.

---

## 📦 Alternative: Manual Clone

If you prefer to clone manually:

```bash
sudo pacman -S git && git clone https://github.com/TrialAndErrror/TnEOS.git && cd TnEOS && ./bootstrap.sh
```

---

## 🎯 What Happens

1. **Bootstrap checks your system** - Installs gum and Nix
2. **You confirm your info** - Hostname and username (auto-detected)
3. **You pick packages** - Choose what you want installed
4. **Installation runs** - Everything installs automatically
5. **You're done!** - Log out and back in to use Awesome WM

Total time: **5-10 minutes** depending on your internet speed.

---

## 📦 What You Choose

During installation, you'll select from:

### Development
- Neovim (pre-configured)
- Python, Go
- Docker & Docker Compose
- PyCharm Professional

### Utilities
- Yazi (file manager)
- Zellij (terminal multiplexer)
- Modern CLI tools (ripgrep, fd, bat, eza)

### GUI Apps
- GitKraken
- LibreOffice
- GIMP
- Chromium

### System Tools
- Feh (wallpapers)
- Flameshot (screenshots)
- PulseAudio Control

---

## ✅ Always Installed

These are installed automatically:
- **Awesome WM** - Tiling window manager
- **Picom** - Compositor for effects
- **Rofi** - Application launcher
- **Kitty** - Terminal emulator
- **Essential CLI tools** - eza, fd, bat (+ brightnessctl on laptops)

---

## 🎉 After Installation

1. **Log out** and log back in
2. **Select Awesome WM** from your display manager
3. **Start using your system!**

Everything is configured and ready to go.

---

## 🔄 Customizing Later

Want to change something? Edit configs directly in `~/.config/`:

```bash
# Edit any config
vim ~/.config/awesome/rc.lua
```

---

## 🆘 Need Help?

**Nix commands don't work?**
```bash
# Log out and back in, or run:
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

**Had existing configs?**
They're backed up in `~/.config-backup-*/`

**More details?**
See [README.md](README.md) for full documentation.

