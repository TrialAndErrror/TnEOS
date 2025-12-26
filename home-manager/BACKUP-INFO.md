# Home Manager Backup System

## How It Works

When you run the installation script and choose to set up Home Manager, the system will:

1. **Check for existing config files** in these locations:
   - `~/.config/awesome/`
   - `~/.config/nvim/`
   - `~/.config/picom/`
   - `~/.config/rofi/`
   - `~/.config/alacritty/`
   - `~/Pictures/Wallpapers/`
   - `~/.local/share/icons/`

2. **Prompt you to create a backup** if any of these exist

3. **Move existing files** to a timestamped backup directory:
   - Format: `~/.config-backup-YYYYMMDD-HHMMSS/`
   - Example: `~/.config-backup-20231226-143022/`

4. **Apply your new configs** via Home Manager symlinks

## Restoring from Backup

If you need to restore your old configs:

```bash
# Find your backup directory
ls -la ~ | grep config-backup

# Restore a specific config (example: nvim)
rm -rf ~/.config/nvim
cp -r ~/.config-backup-YYYYMMDD-HHMMSS/nvim ~/.config/

# Or restore everything
BACKUP_DIR=~/.config-backup-YYYYMMDD-HHMMSS
cp -r $BACKUP_DIR/awesome ~/.config/
cp -r $BACKUP_DIR/nvim ~/.config/
cp -r $BACKUP_DIR/picom ~/.config/
cp -r $BACKUP_DIR/rofi ~/.config/
cp -r $BACKUP_DIR/alacritty ~/.config/
```

## What Gets Backed Up

- **All config directories** listed above (if they exist)
- **Entire directory contents** (recursive)
- **Preserves directory structure**

## What Doesn't Get Backed Up

- Files that don't exist
- Other config directories not managed by this Home Manager setup
- Cache files or temporary data
