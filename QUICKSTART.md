# TnEOS Quick Start

## 🚀 Super Quick Install (Recommended)

Copy and paste this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/TrialAndErrror/TnEOS/main/install.sh | bash
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

1. **Bootstrap checks your system** - Installs gum, Nix, and rsync
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
- Thorium Browser

### System Tools
- Nitrogen (wallpapers)
- Flameshot (screenshots)
- PulseAudio Control

---

## ✅ Always Installed

These are installed automatically:
- **Awesome WM** - Tiling window manager
- **Picom** - Compositor for effects
- **Rofi** - Application launcher
- **Alacritty** - Terminal emulator
- **Neovim** - Text editor (base install)
- **Home Manager** - Dotfile management
- **Essential CLI tools** - brightnessctl, eza, fd, bat

---

## 🎉 After Installation

1. **Log out** and log back in
2. **Select Awesome WM** from your display manager
3. **Start using your system!**

Everything is configured and ready to go.

---

## 🔄 Customizing Later

Want to change something? All configs are in `~/.config/home-manager/`:

```bash
# Edit any config
vim ~/.config/home-manager/config/awesome/rc.lua

# Apply changes
home-manager switch
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

