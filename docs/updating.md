# Updating TnEOS

## pacman / AUR packages

```bash
yay -Syu
```

## Nix packages

```bash
NIXPKGS_ALLOW_UNFREE=1 nix profile upgrade '.*' --impure
```

## Config files

Re-run `main.sh` and choose **Install Config Files** to re-copy dotfiles from the repo to `~/.config/`. Your existing configs will be backed up with a timestamp before being replaced.

Alternatively, edit files directly in `~/.config/` — changes there take effect immediately (awesome can be reloaded with `Super+Ctrl+R`).
