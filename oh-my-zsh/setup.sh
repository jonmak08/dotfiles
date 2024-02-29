#!/bin/sh

OH_MY_ZSH='oh-my-zsh'
DOT_FILES_OH_MY_ZSH_DIR="${HOME}/dotfiles/${OH_MY_ZSH}"

# Homebrew's installed location
BREW_PREFIX=$(brew --prefix)

echo 'Setting up Oh My Zsh...'

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  echo 'Installing Oh My Zsh...'

  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"

  echo 'Oh My Zsh installation complete.'
fi

# Remove ~/.zshrc if it exists
[[ -f "${HOME}/.zshrc" ]] && rm -rf "${HOME}/.zshrc"

# Create symlink of ~/.zshrc from ~/dotfiles/oh-my-zsh/.zshrc
ln -s "${DOT_FILES_OH_MY_ZSH_DIR}/.zshrc" "${HOME}/.zshrc"

# Remove ~/.zprofile if it exists
[[ -f "${HOME}/.zprofile" ]] && rm -rf "${HOME}/.zprofile"

# Create symlink of ~/.zprofile from ~/dotfiles/oh-my-zsh/.zprofile
ln -s "${DOT_FILES_OH_MY_ZSH_DIR}/.zprofile" "${HOME}/.zprofile"

# Remove ~/.p10k.zsh if it exists
[[ -f "${HOME}/.p10k.zsh" ]] && rm -rf "${HOME}/.p10k.zsh"

# Create symlink of ~/.p10k.zsh from ~/dotfiles/oh-my-zsh/.p10k.zsh
ln -s "${DOT_FILES_OH_MY_ZSH_DIR}/.p10k.zsh" "${HOME}/.p10k.zsh"

# Add Dracula theme to zsh
DOT_FILES_DRACULA_ZSH="${HOME}/dotfiles/themes/dracula/zsh"
OH_MY_ZSH_ROOT="${HOME}/.oh-my-zsh"

# Create symlink for ~/.oh-my-zsh/lib/async.zsh from ~/dotfiles/themes/dracula/zsh/lib/async.zsh
ln -s "${DOT_FILES_DRACULA_ZSH}/lib/async.zsh"  "${OH_MY_ZSH_ROOT}/lib"

# Create symlink for ~/.oh-my-zsh/themes/dracula.zsh-theme from ~/dotfiles/themes/dracula/zsh/dracula.zsh-theme
ln -s "${DOT_FILES_DRACULA_ZSH}/dracula.zsh-theme" "${OH_MY_ZSH_ROOT}/themes"

unset OH_MY_ZSH_ROOT
unset DOT_FILES_DRACULA_ZSH

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;

  chsh -s "${BREW_PREFIX}/bin/zsh";
fi;

echo 'Oh My Zsh setup complete.'

unset BREW_PREFIX
unset OH_MY_ZSH
