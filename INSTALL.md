# Installation Guide

## Prerequisites

Before running TnEOS, you need:

1. **Arch Linux installed** - Complete the base Arch installation
2. **Booted into your system** - Not the live ISO
3. **Internet connection** - Working network
4. **User account** - Created during Arch install (you should be logged in as this user)

## Installation

### Method 1: Web Install (Recommended)

The easiest way - just copy and paste this command:

```bash
curl -fsSL https://raw.githubusercontent.com/TrialAndErrror/TnEOS/main/install.sh | bash
```

This will:
1. Install git (if needed)
2. Clone the TnEOS repository to `~/TnEOS`
3. Run the bootstrap script automatically

### Method 2: Manual Clone

If you prefer to clone manually:

**Step 1: Install Git**
```bash
sudo pacman -S git
```

**Step 2: Clone TnEOS**
```bash
git clone https://github.com/TrialAndErrror/TnEOS.git
cd TnEOS
```

**Step 3: Run the Bootstrap Script**
```bash
./bootstrap.sh
```

The bootstrap script will:
- Check that you're on Arch Linux
- Verify internet connection
- Install `gum` (for the interactive interface)
- Install Nix (if not already installed)
- Install `rsync` (for file management)
- Launch the main installer

### Step 4: Follow the Interactive Prompts

The installer will guide you through:

#### 1. System Information
- Shows your detected hostname and username
- Asks you to confirm before continuing

#### 2. Package Selection
- **Nix Packages** - Choose from development tools, utilities, and GUI apps
- **Pacman Packages** - Choose additional system packages
- Use arrow keys and space to select, Enter to confirm

#### 3. Home Manager Information
- Brief explanation of how dotfiles will be managed
- No action needed, just informational

#### 4. Summary
- Review everything that will be installed
- Confirm to proceed or go back to make changes

#### 5. Installation
- Pacman packages install
- Nix packages install
- Home Manager installs and configures
- Your dotfiles are applied

### Step 5: Complete!

After installation:
1. Log out of your session
2. Log back in
3. Select "Awesome" from your display manager's session menu
4. Enjoy your configured system!

## What Gets Installed

### Core Desktop Environment (Always)
- Awesome WM
- Picom (compositor)
- Rofi (launcher)
- Alacritty (terminal)
- Essential CLI tools

### Optional Packages (You Choose)

**Development:**
- Neovim (full config)
- Python, Go
- Docker
- PyCharm Professional

**Utilities:**
- Yazi (file manager)
- Zellij (terminal multiplexer)
- ripgrep, fd, bat, eza

**GUI Applications:**
- GitKraken
- LibreOffice
- GIMP
- Thorium Browser

**System Tools:**
- Nitrogen (wallpaper setter)
- Flameshot (screenshots)
- PulseAudio Control
- LXAppearance (themes)

## Backup System

If you have existing configurations, TnEOS will:

1. **Detect** existing config files in `~/.config/`
2. **Prompt** you to create a backup
3. **Create** a timestamped backup directory: `~/.config-backup-YYYYMMDD-HHMMSS/`
4. **Move** your old configs there
5. **Apply** the new TnEOS configurations

Your old configs are safe and can be restored anytime.

## After Installation

### Your Configurations

All configs are managed by Home Manager in `~/.config/home-manager/`:

```
~/.config/home-manager/
├── config/
│   ├── awesome/     → Awesome WM configuration
│   ├── nvim/        → Neovim configuration
│   ├── picom/       → Picom configuration
│   ├── rofi/        → Rofi configuration
│   └── alacritty/   → Alacritty configuration
└── assets/
    ├── backgrounds/ → Wallpapers
    └── icons/       → Icon files
```

These are symlinked to their proper locations:
- `~/.config/awesome/` → Awesome WM
- `~/.config/nvim/` → Neovim
- `~/.config/picom/` → Picom
- `~/.config/rofi/` → Rofi
- `~/.config/alacritty/` → Alacritty
- `~/Pictures/Wallpapers/` → Wallpapers
- `~/.local/share/icons/` → Icons

### Updating Configurations

To customize your setup:

```bash
# Edit any config file
vim ~/.config/home-manager/config/awesome/rc.lua

# Apply the changes
home-manager switch
```

That's it! Home Manager will update the symlinks and apply your changes.

## Troubleshooting

### Bootstrap fails with "not on Arch Linux"
You can bypass this check, but the script is designed for Arch. Proceed at your own risk.

### "gum: command not found"
The bootstrap script should install this. If it fails:
```bash
sudo pacman -S gum
```

### Nix installation fails
The bootstrap script installs Nix automatically. If it fails, you can install manually:
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
```

### "nix: command not found" after installation
Log out and log back in, or source the Nix profile:
```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Home Manager fails to apply
Check for errors:
```bash
home-manager switch --show-trace
```

### Awesome WM won't start
Make sure you selected it from your display manager. If you don't have a display manager:
```bash
echo "exec awesome" > ~/.xinitrc
startx
```

### Want to restore old configs?
Your backups are in `~/.config-backup-*/`. To restore:
```bash
# Remove TnEOS configs
rm -rf ~/.config/awesome ~/.config/nvim ~/.config/picom ~/.config/rofi ~/.config/alacritty

# Restore from backup (replace YYYYMMDD-HHMMSS with your backup timestamp)
cp -r ~/.config-backup-YYYYMMDD-HHMMSS/* ~/
```

## Advanced: Preparing During Arch Installation

If you want to clone TnEOS during the Arch installation process:

### During arch-chroot

```bash
# Install git
pacman -S git

# Clone to user's home
cd /home/yourusername
git clone https://github.com/TrialAndErrror/TnEOS.git
chown -R yourusername:yourusername TnEOS
```

### After Reboot

Log in as your user and run:
```bash
cd ~/TnEOS
./bootstrap.sh
```

This saves you from having to clone the repo after installation, but the setup is still interactive.

## Getting Help

- Check [README.md](README.md) for overview
- See [QUICKSTART.md](QUICKSTART.md) for quick reference
- Open an issue on GitHub for bugs or questions

