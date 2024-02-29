#!/bin/sh

echo 'Setting up your Mac...'

# Install Homebrew casks, formulae, and tap
./homebrew/setup.sh

# Setup EditorConfig
./editorconfig/setup.sh

# Setup Bash
./bash/setup.sh

# Setup Oh My Zsh
./oh-my-zsh/setup.sh

# Setup Git
./git/setup.sh

# Setup Karabiner
./karabiner/setup.sh

# Setup Makeup
./mackup/setup.sh

# Set macOS preferences - we will run this last because this will reload the shell
# ./macos/setup.sh
