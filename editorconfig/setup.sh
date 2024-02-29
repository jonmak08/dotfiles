#!/bin/sh

EDITORCONFIG='editorconfig'

echo "Setting up ${EDITORCONFIG}..."

# Remove ~/.editorconfig, if it exists
[[ -f "${HOME}/.editorconfig" ]] && rm -rf "${HOME}/.editorconfig"

# Create symlink of ~/.bash_profile from ~/dotfiles/bash/.bash_profile
ln -s "${HOME}/dotfiles/${EDITORCONFIG}/.editorconfig" "${HOME}/.editorconfig"

echo "${EDITORCONFIG} setup complete."

unset EDITORCONFIG
