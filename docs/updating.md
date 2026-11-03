# Updating TnEOS

## System packages

### Arch (pacman / AUR)

```bash
sudo pacman -Syu
```

### Debian / Ubuntu (apt)

```bash
sudo apt update && sudo apt upgrade
```

### Fedora (dnf)

```bash
sudo dnf upgrade
```

## Nix packages

```bash
NIXPKGS_ALLOW_UNFREE=1 nix profile upgrade '.*' --impure
```

## Config files

Re-run `main.sh` and choose **Install Config Files** to update dotfiles from the repo to `~/.config/`.

For each config, TnEOS diffs the repo version against what's on disk (ignoring whitespace). The outcome depends on what it finds:

- **No changes** — skips silently, nothing touched
- **Changes detected** — shows a colored diff and asks whether to overwrite; you can accept or reject each config individually
- **First install** — copies straight through with no prompt

Before overwriting anything, TnEOS creates a timestamped backup in `~/.config-backups/` so you can always roll back.

### What is always preserved

Three paths are **never prompted and never overwritten**, regardless of what changed in the repo:

| Path | Purpose |
|---|---|
| `~/.config/awesome/custom.lua` | Your personal Awesome WM customizations |
| `~/.config/nvim/lua/local/` | Your machine-local Neovim plugins |
| `~/.zshrc` | Your personal shell config (only `~/.zshrc_TnEOS` is updated) |

### Editing configs directly

You can also edit files directly in `~/.config/` — changes take effect immediately. Awesome WM can be reloaded without logging out with `Super+Ctrl+R`.
