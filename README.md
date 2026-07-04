# TnEOS - Linux Desktop Setup

Get from a fresh Linux installation to a fully configured desktop environment in minutes.

## What is TnEOS?

TnEOS is an automated post-installation script that sets up a complete desktop environment. It is primarily developed and tested on **Arch Linux** — Debian and Fedora are experimentally supported but may have rough edges.

TnEOS installs and configures:

- 🎨 **Awesome Window Manager** - Pre-configured and ready to use
- 📝 **Neovim** - Fully configured development environment
- 🎯 **Essential Tools** - Terminal, file manager, and productivity apps
- 📦 **Package Selection** - Choose what you want installed

## Quick Start

After installing Linux and booting into your system, run this single command:

```bash
curl -fsSL trialanderrror.com/install | bash
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
- **LightDM** - Display manager with customizable login screen
- **Picom** - Compositor for transparency and effects
- **Rofi** - Application launcher and window switcher
- **Kitty** - Fast, GPU-accelerated terminal emulator

### Development Tools
- **Neovim** - Modern text editor with full IDE features
- **Python, Go** - Programming language support (optional)
- **Docker** - Containerization platform (optional)

### Utilities
- **Yazi** - Modern terminal file manager (optional)
- **Zellij** - Terminal multiplexer (optional)
- **ripgrep, fd, bat, eza** - Modern CLI tools

### System Tools
- **Feh** - Wallpaper manager
- **Flameshot** - Screenshot tool
- **PulseAudio Control** - Audio management

## How It Works

The installation process is simple and interactive:

1. **System Detection** - Automatically detects your hostname and username
2. **Package Selection** - Choose which optional packages you want
3. **Review** - See a summary of what will be installed
4. **Installation** - Sit back while everything is installed and configured
5. **Done!** - Log out and back in to start using your new environment

## Installation Steps

### Prerequisites
- Linux installation (Arch recommended; Debian and Fedora experimentally supported)
- Internet connection
- Non-root user account

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
2. Install required tools (gum, Nix)
3. Launch the interactive installer

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

Your dotfiles are copied into `~/.config/`:
- Awesome WM configuration
- Neovim setup
- Terminal settings
- Application launcher
- Wallpapers and themes

## Running TnEOS Again

Re-run `main.sh` at any time to update or reconfigure your system:

```bash
cd ~/TnEOS
./main.sh
```

The main menu offers six options:

| Option | What it does |
|---|---|
| **Install Everything** | Full install — programs, configs, display setup |
| **Install Config Files** | Copy/update dotfiles only (shows a diff and asks before overwriting each one) |
| **Install Programs** | Install packages only, skipping config changes |
| **Setup Display** | Set the wallpaper and configure the LightDM login screen theme |
| **Manage Backups** | Interactive UI to restore or delete timestamped config backups |
| **Install Fonts** | Download and install Nerd Fonts |
| **Set Default Font** | Choose a font and apply it to Kitty, Rofi, and Awesome WM in one step |

---

## Important Configurations

### Customizing Awesome WM

TnEOS includes a `~/.config/awesome/custom.lua` file specifically for your personal Awesome WM changes. The TnEOS installer never overwrites this file, so your customizations survive upgrades.

Add any of the following directly to `custom.lua`:
- Extra keybindings
- Window rules (e.g. always open Discord on tag 5)
- Autostart applications
- Custom widgets
- Signal/event hooks

The file ships with commented-out examples for all of these. Uncomment and edit what you need:

```bash
nvim ~/.config/awesome/custom.lua
```

After editing, reload Awesome WM with `Super+Ctrl+R` — no need to log out.

---

### Customizing Neovim

Machine-local Neovim plugins live in `~/.config/nvim/lua/local/plugins/`. This directory is gitignored and preserved across TnEOS installs, so anything you add there won't be touched by updates.

To add a plugin, create a new `.lua` file in that folder returning a [lazy.nvim plugin spec](https://lazy.folke.io/spec):

```bash
# Example: add a plugin just for this machine
nvim ~/.config/nvim/lua/local/plugins/my-plugin.lua
```

```lua
-- ~/.config/nvim/lua/local/plugins/my-plugin.lua
return {
  "owner/repo",
  config = function()
    require("my-plugin").setup()
  end,
}
```

Lazy.nvim automatically picks up any spec files in that folder — no need to register them anywhere else.

---

### Your Shell Config (zshrc)

TnEOS installs its shell configuration as `~/.zshrc_TnEOS` (a separate file from your own `~/.zshrc`) and adds a single source line to your `~/.zshrc`:

```bash
[ -f ~/.zshrc_TnEOS ] && source ~/.zshrc_TnEOS
```

You are free to edit `~/.zshrc` however you like — add aliases, change your theme, set environment variables, configure plugins — as long as that source line remains present. TnEOS only manages `~/.zshrc_TnEOS`; your `~/.zshrc` is yours.

When TnEOS updates its shell config, it overwrites `~/.zshrc_TnEOS` only, leaving your personal `~/.zshrc` untouched.

---

### Zsh and Oh-My-Zsh

If you select zsh during package installation, TnEOS automatically installs [Oh-My-Zsh](https://ohmyz.sh/) as part of the same step.

To avoid interrupting the install session, Oh-My-Zsh is installed with `RUNZSH=no CHSH=no` — it does **not** switch your default shell or launch a new zsh session mid-install. Everything finishes cleanly in your current shell.

To make zsh your default shell after the install completes:

```bash
chsh -s $(which zsh)
```

Then log out and back in. From that point on, new terminal sessions will open in zsh with Oh-My-Zsh and the TnEOS config already active.

The `~/.zshrc_TnEOS` file pre-configures Oh-My-Zsh with a theme, useful plugins (git, battery, colored-man-pages, alias-finder), and sensible defaults — nothing extra to set up.

---

### Laptop vs Desktop

TnEOS automatically detects whether it is running on a laptop or desktop by checking for a battery in `/sys/class/power_supply/`. If detection is ambiguous it will ask you to confirm before continuing.

The device type affects both what gets installed and how Awesome WM is configured:

| | Laptop | Desktop |
|---|---|---|
| Extra packages | `acpid`, `brightnessctl` | — |
| System services | `acpid` enabled on install | — |
| Lid-switch config | Installed to `/etc/systemd/logind.conf.d/` | — |
| Awesome WM | Battery widget + brightness keybindings active | Battery widget removed |

If you install on a desktop but later move the config to a laptop (or vice versa), re-run **Install Config Files** from the main menu — TnEOS will re-detect the device type and apply the correct Awesome WM configuration.

---

### Rofi Customization

In ~/.config/rofi/config.rasi, we declare an overall theme at the top and then have some overrides and customization in the file. You can modify that config with the config-loader command (meta + shift + c).

There is a setting for fonts; by default, it looks for Hack Nerd Font, then JetBrainsMono Nerd Font, then Iosevka Nerd Font, then falls back to monospace font. Be sure to install those fonts if you're just seeing plain monospace using the Font Installer command (or change to your preferred fonts.)

### Customizing the Login Screen

TnEOS includes a beautiful, customizable login screen. To customize it:

```bash
# Automated setup with TnEOS theme
cd ~/TnEOS
./install/setup-lightdm-greeter.sh

# Or use the GUI tool
sudo pacman -S lightdm-gtk-greeter-settings
lightdm-gtk-greeter-settings
```


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
Your old configs are backed up in `~/.config-backups/` if you need to restore them.

## Support

Found a bug or have a question? Open an issue on GitHub.

## License

MIT

# Special Thanks
... to Aditya Shakya for providing [so many helpful Rofi themes and applets](https://github.com/adi1090x/rofi)
... to Ryan McIntyre for creating [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts)
