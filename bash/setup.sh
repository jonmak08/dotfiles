#!/bin/sh

BASH='bash'
DOT_FILES_BASH_DIR="${HOME}/dotfiles/${BASH}"

echo "Setting up ${BASH}..."

# Remove ~/.bash_profile, if it exists
[[ -f "${HOME}/.bash_profile" ]] && rm -rf "${HOME}/.bash_profile"

# Create symlink of ~/.bash_profile from ~/dotfiles/bash/.bash_profile
ln -s "${DOT_FILES_BASH_DIR}/.bash_profile" "${HOME}/.bash_profile"

# Remove ~/.bashrc, if it exists
[[ -f "${HOME}/.bashrc" ]] && rm -rf "${HOME}/.bashrc"

# Create symlink of ~/.bashrc from ~/dotfiles/bash/.bashrc
ln -s "${DOT_FILES_BASH_DIR}/.bashrc" "${HOME}/.bashrc"

echo "${BASH} setup complete."

unset DOT_FILES_BASH_DIR
unset BASH
