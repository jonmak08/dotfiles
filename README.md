          888          888     .d888 d8b 888
          888          888    d88P"  Y8P 888
          888          888    888        888
      .d88888  .d88b.  888888 888888 888 888  .d88b.  .d8888b
     d88" 888 d88""88b 888    888    888 888 d8P  Y8b 88K
     888  888 888  888 888    888    888 888 88888888 "Y8888b.
     Y88b 888 Y88..88P Y88b.  888    888 888 Y8b.          X88
      "Y88888  "Y88P"   "Y888 888    888 888  "Y8888   88888P'

## Introduction

This repository helps me setup and maintain my macOS devices; it takes the effort out of installing everything manually.  Everything needed to install my preferred setup of macOS is detailed in this readme.

## Quick Start

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the installer:**
   ```bash
   ./install
   ```

### Installation Options

The `install` script supports various options for customized installation:

```bash
# See all available options
./install --help

# Dry run (see what would be installed without making changes)
./install --dry-run

# Install with verbose output
./install --verbose

# Skip specific modules
./install --skip macos --skip mackup

# Install only specific modules
./install --only git --only homebrew

# List available modules
./install --list
```

### Available Modules

- **homebrew** - Installs Homebrew and all packages from Brewfile
- **editorconfig** - Sets up EditorConfig
- **bash** - Configures Bash shell
- **oh-my-zsh** - Installs and configures Oh My Zsh with Powerlevel10k theme
- **git** - Sets up Git configuration and aliases
- **karabiner** - Configures Karabiner-Elements for keyboard customization
- **mackup** - Sets up Mackup for application settings backup
- **macos** - Applies macOS system preferences

## Manual Setup

If you prefer to run the original setup script or individual module setups:

```bash
# Run the complete setup
./setup.sh

# Run individual module setup
./git/setup.sh
./oh-my-zsh/setup.sh
```

## Backing up your Mac