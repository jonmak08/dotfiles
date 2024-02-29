#!/bin/sh

TEXTMATE='textmate'

echo "Setting up ${TEXTMATE}..."

# Remove ~/.tm_properties, if it exists
[[ -f "${HOME}/.tm_properties" ]] && rm -rf "${HOME}/.tm_properties"

# Create symlink of ~/.gitconfig from ~/dotfiles/bash/.gitconfig
ln -s "${HOME}/dotfiles/${TEXTMATE}/.tm_properties" "${HOME}/.tm_properties"

echo "${TEXTMATE} setup complete."

unset TEXTMATE
