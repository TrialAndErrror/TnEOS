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

### 4. `backup-configs.sh`
Backs up existing configuration files.
- Checks for existing configs (awesome, nvim, picom, rofi, alacritty)
- Prompts user for backup confirmation
- Creates timestamped backup directory
- Exports `BACKUP_DIR` and `BACKUP_NEEDED` variables

### 5. `setup-wallpaper.sh`
Installs and configures the TnEOS wallpaper.
- Finds wallpaper in either copied config or source repo
- Copies wallpaper to `~/Pictures/Wallpapers/`
- Sets wallpaper with feh and writes ~/.fehbg for session restore
- Works standalone or as part of full installation

### 6. `show-completion.sh`
Displays installation completion messages.
- Shows backup information if applicable
- Lists installed configurations
- Provides next steps for the user

### 7. `install-nerd-fonts.sh`
Installs Nerd Fonts and optionally sets one as default. Works on all distros.
- Presents a selection of popular Nerd Fonts
- Pre-selects already installed fonts
- Downloads selected fonts from github.com/ryanoasis/nerd-fonts releases
- Extracts to ~/.local/share/fonts/NerdFonts/
- Refreshes font cache with fc-cache
- Optionally updates default font in configs (Alacritty, Rofi, AwesomeWM)

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

