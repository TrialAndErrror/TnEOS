# Installation Guide

## Prerequisites

Before running TnEOS, you need:

1. **Linux installed** - Arch is recommended and best supported; Debian and Fedora are experimentally supported
2. **Booted into your system** - Not a live ISO
3. **Internet connection** - Working network
4. **Non-root user account** - You should be logged in as a regular user

## Installation

### Method 1: Web Install (Recommended)

The easiest way - just copy and paste this command:

```bash
curl -fsSL trialanderrror.com/install | bash
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
- Detect your distro (Arch, Debian, or Fedora)
- Verify internet connection
- Install `gum` (for the interactive interface)
- Install Nix (if not already installed)
- Enable Nix experimental features (nix-command and flakes)
- Enable unfree packages in Nix (for proprietary software)
- Launch the main installer

The main installer will:
- Install your selected packages via pacman/apt/dnf
- Install Nix packages using `nix profile install`
- Copy dotfiles into `~/.config/`

### Step 4: Follow the Interactive Prompts

The installer will guide you through:

#### 1. System Information
- Shows your detected hostname and username
- Asks you to confirm before continuing

#### 2. Package Selection
- **Nix Packages** - Choose from development tools, utilities, and GUI apps
- **Pacman Packages** - Choose additional system packages
- Use arrow keys and space to select, Enter to confirm

#### 3. Summary
- Review everything that will be installed
- Confirm to proceed or go back to make changes

#### 4. Installation
- Pacman packages install
- Nix packages install
- Dotfiles are copied to `~/.config/`

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
- Kitty (terminal)
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
- Chromium

**System Tools:**
- Feh (wallpaper setter)
- Flameshot (screenshots)
- PulseAudio Control
- LXAppearance (themes)

## Backup System

If you have existing configurations, TnEOS will:

1. **Detect** existing config files in `~/.config/`
2. **Prompt** you to create a backup
3. **Create** a timestamped backup directory: `~/.config-backups/YYYYMMDD-HHMMSS/`
4. **Move** your old configs there
5. **Apply** the new TnEOS configurations

Your old configs are safe and can be restored anytime.

## After Installation

### Your Configurations

Configs are copied directly into `~/.config/`:

```
~/.config/
├── awesome/     → Awesome WM configuration
├── nvim/        → Neovim configuration
├── picom/       → Picom configuration
├── rofi/        → Rofi configuration
└── kitty/       → Kitty terminal configuration
```

TnEOS wallpaper is copied to:
- `~/Pictures/Wallpapers/tneos-wallpaper.jpg`
  (Your existing wallpapers are not touched)

### Updating Configurations

Edit config files directly in `~/.config/`. To re-run TnEOS and apply updates from the repo, run `./main.sh` again — it will diff and prompt before overwriting.

## Troubleshooting

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

### "error: experimental Nix feature 'nix-command' is disabled"
The bootstrap script should enable this automatically. If you see this error, manually enable it:
```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf
sudo systemctl restart nix-daemon
```

### Awesome WM won't start
Make sure you selected it from your display manager. If you don't have a display manager:
```bash
echo "exec awesome" > ~/.xinitrc
startx
```

### Want to restore old configs?
Your backups are in `~/.config-backups/*/`.

**Easy way** - Use the interactive restore script:
```bash
cd ~/TnEOS
./restore-backup.sh
```

**Manual way** - Restore manually:
```bash
# Remove TnEOS configs
rm -rf ~/.config/awesome ~/.config/nvim ~/.config/picom ~/.config/rofi ~/.config/kitty

# Restore from backup (replace YYYYMMDD-HHMMSS with your backup timestamp)
cp -r ~/.config-backups/YYYYMMDD-HHMMSS/* ~/
```

## Non-Arch Users (Debian / Ubuntu / Fedora)

TnEOS is primarily developed and tested on Arch Linux. Debian, Ubuntu, and Fedora are experimentally supported — most things work, but a handful of packages are not available in their official repos and must be installed separately after running TnEOS.

### Neovim: `tree-sitter-cli` not available via apt or dnf

When you select Neovim, TnEOS also installs `tree-sitter-cli` (required to compile language parsers). On Arch this comes from pacman, but it is not in the apt or dnf repos. You will see a warning during installation:

```
⚠ Skipping tree-sitter-cli: not in apt/dnf repos
```

After the TnEOS install finishes, install it via npm:

```bash
npm i -g tree-sitter-cli
```

> If you don't have npm, install Node.js first: `sudo apt install nodejs npm` or `sudo dnf install nodejs npm`.

Without `tree-sitter-cli`, Neovim will work but treesitter parsers may fail to compile, which affects syntax highlighting and text objects for some languages.

### Fedora only: Yazi not available via dnf

Yazi (the terminal file manager) is not in the Fedora repos. TnEOS will skip it with a warning. Install it manually from the official releases page after TnEOS finishes:

```
https://github.com/sxyazi/yazi/releases
```

Or via cargo if you have Rust installed:

```bash
cargo install --locked yazi-fm yazi-cli
```

---

## Advanced: Pre-cloning During Installation

If you want to clone TnEOS before your first boot (e.g. during an Arch `arch-chroot` or a Debian chroot):

```bash
# Install git (Arch)
pacman -S git

# Clone to user's home
cd /home/yourusername
git clone https://github.com/TrialAndErrror/TnEOS.git
chown -R yourusername:yourusername TnEOS
```

Then after booting into your user account:

```bash
cd ~/TnEOS
./bootstrap.sh
```

## Getting Help

- Check [README.md](README.md) for overview
- See [QUICKSTART.md](QUICKSTART.md) for quick reference
- Open an issue on GitHub for bugs or questions

