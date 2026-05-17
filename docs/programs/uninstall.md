# Uninstalling Programs

## System packages

### Arch (pacman / AUR)

```bash
yay -Rns <package>
```

`-Rns` removes the package, its unneeded dependencies, and any saved configuration files.

To list all explicitly installed packages:

```bash
yay -Qe
```

### Debian / Ubuntu (apt)

```bash
sudo apt remove <package>
```

Use `purge` instead of `remove` to also delete configuration files:

```bash
sudo apt purge <package>
```

To remove any leftover unneeded dependencies:

```bash
sudo apt autoremove
```

### Fedora (dnf)

```bash
sudo dnf remove <package>
```

To remove any leftover unneeded dependencies:

```bash
sudo dnf autoremove
```

## Nix packages

First, find the package index:

```bash
nix profile list
```

Then remove by index number:

```bash
nix profile remove <index>
```

Or remove by package name/attribute:

```bash
nix profile remove '.*<package>.*'
```
