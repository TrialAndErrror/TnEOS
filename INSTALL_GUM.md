# Installing Gum

This installer now uses [Gum](https://github.com/charmbracelet/gum) for a modern, beautiful TUI experience.

## Installation

### Arch Linux
```bash
sudo pacman -S gum
```

### macOS
```bash
brew install gum
```

### Debian/Ubuntu
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum
```

### Fedora/RHEL
```bash
echo '[charm]
name=Charm
baseurl=https://repo.charm.sh/yum/
enabled=1
gpgcheck=1
gpgkey=https://repo.charm.sh/yum/gpg.key' | sudo tee /etc/yum.repos.d/charm.repo
sudo rpm --import https://repo.charm.sh/yum/gpg.key
sudo yum install gum
```

### Nix
```bash
nix-env -iA nixpkgs.gum
```

### From Binary
Download from: https://github.com/charmbracelet/gum/releases

## Running the Installer

Once gum is installed, simply run:
```bash
./main.sh
```

Enjoy the beautiful new interface! 🎀

