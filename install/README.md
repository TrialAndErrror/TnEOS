# TnEOS Installation Modules

This directory contains modular installation scripts that are called by `main.sh`. Each script handles a specific part of the installation process.

## Installation Scripts

### 1. `install-package-manager-packages.sh`
Installs packages via the system package manager (pacman, apt, or dnf).
- Installs all packages in the `PACMAN_PACKAGES` array
- Enables LightDM service if installed
- Enables acpid service for battery monitoring (laptops)

### 3. `install-nix-packages.sh`
Installs packages via Nix package manager.
- Installs all packages in the `NIX_PACKAGES` array
- Handles installation errors gracefully
- Uses unfree packages when needed

### 4. `install-home-manager.sh`
Installs Home Manager for dotfile management.
- Adds Home Manager channel
- Updates Nix channels
- Installs Home Manager package

### 5. `backup-configs.sh`
Backs up existing configuration files.
- Checks for existing configs (awesome, nvim, picom, rofi, alacritty)
- Prompts user for backup confirmation
- Creates timestamped backup directory
- Exports `BACKUP_DIR` and `BACKUP_NEEDED` variables

### 6. `setup-home-manager-config.sh`
Copies and configures Home Manager files.
- Copies home-manager directory to `~/.config/home-manager`
- Removes nvim config if neovim wasn't selected
- Configures Desktop vs Laptop mode (battery widget, etc.)

### 7. `apply-home-manager.sh`
Applies the Home Manager configuration.
- Runs `home-manager switch`
- Fixes ownership of config files

### 8. `setup-wallpaper.sh`
Installs and configures the TnEOS wallpaper.
- Finds wallpaper in either copied config or source repo
- Copies wallpaper to `~/Pictures/Wallpapers/`
- Sets wallpaper with feh and writes ~/.fehbg for session restore
- Works standalone or as part of full installation

### 9. `show-completion.sh`
Displays installation completion messages.
- Shows backup information if applicable
- Lists installed configurations
- Provides next steps for the user

### 10. `install-nerd-fonts.sh`
Installs Nerd Fonts and optionally sets one as default.
- Presents a selection of popular Nerd Fonts from AUR
- Pre-selects already installed fonts
- Installs selected fonts via yay
- Refreshes font cache
- Optionally updates default font in configs (Alacritty, Rofi, AwesomeWM)
- Can apply changes immediately with home-manager

## Usage

These scripts are designed to be sourced and called from `main.sh`:

```bash
source ./install/install-package-manager-packages.sh
install_package_manager_packages
```

Each script can also be run independently if needed:

```bash
./install/install-package-manager-packages.sh
```

## Dependencies

All scripts depend on:
- `ui.sh` - UI helper functions (gum wrappers)
- Environment variables set by earlier steps (PACMAN_PACKAGES, NIX_PACKAGES, DEVICE_TYPE)

