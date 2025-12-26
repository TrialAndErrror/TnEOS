# TnEOS - Automated Arch Linux Setup

Get from a fresh Arch Linux installation to a fully configured desktop environment in minutes.

## What is TnEOS?

TnEOS is an automated post-installation script for Arch Linux that sets up a complete desktop environment with:

- 🎨 **Awesome Window Manager** - Pre-configured and ready to use
- 📝 **Neovim** - Fully configured development environment
- 🎯 **Essential Tools** - Terminal, file manager, and productivity apps
- 🏠 **Dotfile Management** - Automatic configuration with Home Manager
- 📦 **Package Selection** - Choose what you want installed

## Quick Start

After installing Arch Linux and rebooting into your new system, run this single command:

```bash
curl -fsSL https://raw.githubusercontent.com/TrialAndErrror/TnEOS/main/install.sh | bash
```

That's it! The script will:
- Install git
- Clone the repository
- Run the interactive installer
- Guide you through package selection
- Set up your complete desktop environment

## What You'll Get

### Desktop Environment
- **Awesome WM** - Tiling window manager with custom configuration
- **Picom** - Compositor for transparency and effects
- **Rofi** - Application launcher and window switcher
- **Alacritty** - Fast, GPU-accelerated terminal emulator

### Development Tools
- **Neovim** - Modern text editor with full IDE features
- **Python, Go** - Programming language support (optional)
- **Docker** - Containerization platform (optional)

### Utilities
- **Yazi** - Modern terminal file manager (optional)
- **Zellij** - Terminal multiplexer (optional)
- **ripgrep, fd, bat, eza** - Modern CLI tools

### System Tools
- **Nitrogen** - Wallpaper manager
- **Flameshot** - Screenshot tool
- **PulseAudio Control** - Audio management

All configurations are managed by Home Manager, making updates easy.

## How It Works

The installation process is simple and interactive:

1. **System Detection** - Automatically detects your hostname and username
2. **Package Selection** - Choose which optional packages you want
3. **Review** - See a summary of what will be installed
4. **Installation** - Sit back while everything is installed and configured
5. **Done!** - Log out and back in to start using your new environment

## Installation Steps

### Prerequisites
- Fresh Arch Linux installation
- Internet connection
- User account created during Arch install

### Run the Installer

```bash
# Install git
sudo pacman -S git

# Clone the repository
git clone https://github.com/TrialAndErrror/TnEOS.git
cd TnEOS

# Run the bootstrap script
./bootstrap.sh
```

The bootstrap script will:
1. Check your system
2. Install required tools (gum, Nix, rsync)
3. Install yay (AUR helper) if not present
4. Launch the interactive installer

### Interactive Setup

The installer will guide you through:

1. **System Info** - Confirm your hostname and username
2. **Package Selection** - Choose what you want installed
3. **Summary** - Review your selections
4. **Installation** - Automatic installation and configuration

## After Installation

### Starting Your Environment

1. **Log out** of your current session
2. **Log back in** (or reboot)
3. **Select Awesome WM** from your display manager's session menu
4. **Enjoy!** Your system is fully configured

### What's Configured

All your dotfiles are now managed by Home Manager:
- Awesome WM configuration
- Neovim setup
- Terminal settings
- Application launcher
- Wallpapers and themes

### Updating Configurations

Want to customize something? Easy:

```bash
# Edit any config file
vim ~/.config/home-manager/config/nvim/init.lua

# Apply the changes
home-manager switch
```

All your configurations are in `~/.config/home-manager/` and can be updated anytime.

## Backup Protection

If you had existing configurations, TnEOS automatically:
- Detects conflicts
- Offers to create a timestamped backup
- Safely stores old files in `~/.config-backups/YYYYMMDD-HHMMSS/`

### Restoring from Backup

You can restore from backup anytime using the interactive restore script:

```bash
cd ~/TnEOS
./restore-backup.sh
```

The script lets you:
- Choose which backup to restore from
- Select specific items to restore (or restore everything)
- Safely replace current configs with backed-up versions

## Troubleshooting

### Script won't run
Make sure you have git installed:
```bash
sudo pacman -S git
```

### Nix commands don't work after installation
Log out and log back in, or run:
```bash
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
```

### Awesome WM won't start
Make sure you selected it from your display manager's session menu. If you don't have a display manager, you can start it with:
```bash
echo "exec awesome" > ~/.xinitrc
startx
```

### Want to start over?
Your old configs are backed up in `~/.config-backup-*/` if you need to restore them.

## Support

Found a bug or have a question? Open an issue on GitHub.

## License

MIT

