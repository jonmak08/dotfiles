#!/bin/sh

GIT='git'
DOT_FILES_GIT_DIR="${HOME}/dotfiles/${GIT}"

echo "Setting up ${GIT}..."

# Remove ~/.gitconfig, if it exists
[[ -f "${HOME}/.gitconfig" ]] && rm -rf "${HOME}/.gitconfig"

# Create symlink of ~/.gitconfig from ~/dotfiles/bash/.gitconfig
ln -s "${DOT_FILES_GIT_DIR}/.gitconfig" "${HOME}/.gitconfig"

# Remove ~/.gitignore_global, if it exists
[[ -f "${HOME}/.gitignore_global" ]] && rm -rf "${HOME}/.gitignore_global"

# Create symlink of ~/.gitignore_global from ~/dotfiles/bash/.gitignore_global
ln -s "${DOT_FILES_GIT_DIR}/.gitignore_global" "${HOME}/.gitignore_global"

# Setup Git SSH Keys
./${GIT}/ssh.sh

# Clone Git repositories
./${GIT}/clone.sh

# Install Dracula theme https://draculatheme.com/gitk
## Make git folder in ~/.config
[[ ! -d "${HOME}/.config/git" ]] && mkdir -p "${HOME}/.config/git"

## Copy ~/dotfiles/themes/gitk/gitk into ~/.config/git
cp "${HOME}/dotfiles/themes/dracula/gitk/gitk" "${HOME}/.config/${GIT}"

echo "${GIT} setup complete."

unset DOT_FILES_GIT_DIR
unset GIT
