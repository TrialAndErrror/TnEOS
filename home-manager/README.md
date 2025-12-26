# Home Manager Configuration

This directory contains your Home Manager configuration for managing dotfiles and assets.

## Directory Structure

```
home-manager/
├── home.nix                    # Main Home Manager configuration
├── config/
│   ├── awesome/               # Awesome WM configs (rc.lua, etc.)
│   ├── nvim/                  # Neovim configs (init.lua, etc.)
│   ├── picom/                 # Picom compositor configs
│   ├── rofi/                  # Rofi launcher configs
│   └── alacritty/             # Alacritty terminal configs
└── assets/
    ├── backgrounds/           # Wallpaper images
    └── icons/                 # Icon files
```

## How It Works

When you run the installation script and choose to set up Home Manager:

1. Home Manager will be installed via Nix
2. This configuration will be copied to `~/.config/home-manager/`
3. Home Manager will create symlinks for your configs:
   - `~/.config/awesome/` → your awesome configs
   - `~/.config/nvim/` → your nvim configs
   - `~/.config/picom/` → your picom configs
   - `~/.config/rofi/` → your rofi configs
   - `~/.config/alacritty/` → your alacritty configs
4. TnEOS wallpaper will be copied to `~/Pictures/Wallpapers/tneos-wallpaper.jpg`
   (Your existing wallpapers are not touched)

## Applying Changes
If you want to make changes, you can edit files in ~/.config/home-manager/

After adding or modifying your config files, apply the changes with:
```bash
home-manager switch
```