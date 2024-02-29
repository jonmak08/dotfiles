#!/bin/sh

HOMEBREW='homebrew'

echo "Setting up ${HOMEBREW}..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  echo 'Installing Homebrew...'

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.bash_profile
  eval "$(/opt/homebrew/bin/brew shellenv)"

  echo 'Homebrew installation complete.'
fi

# Homebrew's installed location
BREW_PREFIX=$(brew --prefix)

# Install Homebrew casks, formulae, and tap
## Update Homebrew recipes
brew update

## Upgrade anything already installed via Homebrew
brew upgrade

## Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle

echo 'Installing Homebrew packages...'

brew bundle --file "~/dotfiles/${HOMEBREW}/Brewfile"

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;

  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Remove outdated versions from the cellar.
echo "Cleaning up ${HOMEBREW}..."

brew cleanup

# Setup nvm
./homebrew/nvm.sh

echo "${HOMEBREW} setup complete."

unset HOMEBREW
