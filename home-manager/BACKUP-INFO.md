# Home Manager Backup System

## How It Works

When you run the installation script and choose to set up Home Manager, the system will:

1. **Check for existing config files** in these locations:
   - `~/.config/awesome/`
   - `~/.config/nvim/`
   - `~/.config/picom/`
   - `~/.config/rofi/`
   - `~/.config/alacritty/`

2. **Prompt you to create a backup** if any of these exist

3. **Move existing files** to a timestamped backup directory:
   - Format: `~/.config-backups/YYYYMMDD-HHMMSS/`
   - Example: `~/.config-backups/20231226-143022/`

4. **Apply your new configs** via Home Manager symlinks

## Restoring from Backup

### Easy Way: Interactive Restore Script

The easiest way to restore from backup is using the interactive restore script:

```bash
cd ~/TnEOS  # or wherever you cloned TnEOS
./restore-backup.sh
```

This script will:
1. Show you all available backups (newest first)
2. Let you select which backup to restore from
3. Show you what's in that backup
4. Let you choose which items to restore (all selected by default)
5. Safely remove and restore the selected configurations

### Manual Way

If you prefer to restore manually:

```bash
# Find your backup directories
ls -la ~/.config-backups/

# Restore a specific config (example: nvim)
rm -rf ~/.config/nvim
cp -r ~/.config-backups/YYYYMMDD-HHMMSS/nvim ~/.config/

# Or restore everything
BACKUP_DIR=~/.config-backups/YYYYMMDD-HHMMSS
cp -r $BACKUP_DIR/awesome ~/.config/
cp -r $BACKUP_DIR/nvim ~/.config/
cp -r $BACKUP_DIR/picom ~/.config/
cp -r $BACKUP_DIR/rofi ~/.config/
cp -r $BACKUP_DIR/alacritty ~/.config/
```

## What Gets Backed Up

- **Config directories only** (awesome, nvim, picom, rofi, alacritty)
- **Entire directory contents** (recursive)
- **Preserves directory structure**

## What Doesn't Get Backed Up

- **Asset directories** like `~/Pictures/Wallpapers/`
  - Your existing wallpapers are never touched
  - TnEOS wallpaper is copied alongside your existing ones as `tneos-wallpaper.jpg`
  - No backup needed since nothing is replaced
- Files that don't exist
- Other config directories not managed by this Home Manager setup
- Cache files or temporary data
