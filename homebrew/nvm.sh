#!/bin/sh

NVM='nvm'

echo "Setting up ${NVM}..."

# Remove ~/.nvm, if it exists
[[ -d "${HOME}/.nvm" ]] && rm -rf "${HOME}/.nvm"

# Create  ~/.nvm directory
[[ ! -d "${HOME}/.nvm" ]] && mkdir -p "${HOME}/.nvm"

echo "${NVM} setup complete."

unset NVM
