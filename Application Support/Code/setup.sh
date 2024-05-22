#!/bin/sh

CODE='Code'
CODE_USER_DIR="${HOME}/Library/Application Support/${CODE}/User"

echo "Setting up ${CODE}..."

# Remove ~/Library/Application Support/Code/User/settings.json, if it exists
[[ -f "${CODE_USER_DIR}/settings.json" ]] && rm -rf "${CODE_USER_DIR}/settings.json"

# Create symlink of ~/Library/Application Support/Code/User/settings.json from ~/dotfiles/Application Support/Code/User/settings.json
ln -s "${HOME}/dotfiles/Application Support/${CODE}/User/settings.json" "${CODE_USER_DIR}/settings.json"

echo "${CODE} setup complete."

unset CODE_USER_DIR
unset CODE
