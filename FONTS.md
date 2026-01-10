# Nerd Fonts Installation Guide

TnEOS includes a convenient script to install and configure Nerd Fonts for your system.

## Quick Start

Run the standalone font installer:

```bash
./install-fonts.sh
```

## What It Does

1. **Presents a selection of popular Nerd Fonts:**
   - JetBrainsMono Nerd Font (default)
   - FiraCode Nerd Font
   - Hack Nerd Font
   - MesloLG Nerd Font
   - SauceCodePro Nerd Font
   - Iosevka Nerd Font
   - CaskaydiaCove Nerd Font
   - UbuntuMono Nerd Font
   - RobotoMono Nerd Font
   - DejaVuSansMono Nerd Font

2. **Installs selected fonts** via pacman (from official Arch repositories)

3. **Refreshes font cache** so fonts are immediately available

4. **Optionally sets a default font** across your system:
   - Updates Alacritty terminal configuration
   - Updates Rofi launcher configuration
   - Updates AwesomeWM theme configuration

5. **Applies changes** with home-manager (if you confirm)

## Requirements

- `gum` - for interactive UI (installed during TnEOS setup)
- `pacman` - Arch Linux package manager (pre-installed on Arch)

**Note:** All Nerd Fonts are available in the official Arch Linux repositories, so no AUR helper is needed!

## Usage Examples

### Install Additional Fonts

Already have fonts installed but want more? Just run the script again:

```bash
./install-fonts.sh
```

Your currently installed fonts will be pre-selected, and you can add more.

### Change Default Font

Want to switch from JetBrainsMono to FiraCode? Run the script and:

1. Select the fonts you want (or keep current selection)
2. When prompted, choose to set a default font
3. Select your preferred font from the list
4. Confirm to apply changes with home-manager

### Manual Font Installation

If you prefer to install fonts manually:

```bash
# Install a specific Nerd Font (from official repos)
sudo pacman -S ttf-firacode-nerd

# Refresh font cache
fc-cache -fv

# List installed Nerd Fonts
fc-list | grep -i "nerd"
```

## Configuration Files

The font installer updates these configuration files:

- `~/.config/home-manager/config/alacritty/alacritty.toml`
- `~/.config/home-manager/config/awesome/theme.lua`
- `~/.config/home-manager/config/rofi/**/*.rasi` (all Rofi theme files)

## Troubleshooting

### Fonts not showing up after installation

```bash
# Refresh font cache
fc-cache -fv

# Verify font is installed
fc-list | grep -i "jetbrains"
```

### Changes not applied

If you didn't apply changes with home-manager during installation:

```bash
home-manager switch
```

### Font looks wrong in terminal

Make sure your terminal emulator supports Nerd Fonts. Alacritty (included in TnEOS) has full support.

## More Information

- [Nerd Fonts Official Site](https://www.nerdfonts.com/)
- [Nerd Fonts GitHub](https://github.com/ryanoasis/nerd-fonts)
- [Font Preview](https://www.programmingfonts.org/)

