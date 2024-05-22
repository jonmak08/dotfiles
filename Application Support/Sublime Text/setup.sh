#!/bin/sh

SUBLIME_TEXT='Sublime Text'
SUBLIME_TEXT_DIR="${HOME}/Library/Application Support/${SUBLIME_TEXT}"
DOT_FILES_SUBLIME_TEXT_DIR="${HOME}/dotfiles/Application Support/${SUBLIME_TEXT}"

echo "Setting up ${SUBLIME_TEXT}..."

# Remove ~/Library/Application Support/Sublime Text/Packages/User, if it exists
[[ -d "${SUBLIME_TEXT_DIR}/Packages/User" ]] && rm -rf "${SUBLIME_TEXT_DIR}/Packages/User"

# Create symlink of ~/Library/Application Support/Sublime Text/Packages/User directory from ~/dotfiles/Application Support/Sublime Text/Packages/User
ln -s "${DOT_FILES_SUBLIME_TEXT_DIR}/Packages/User" "${SUBLIME_TEXT_DIR}/Packages/User"

# Remove ~/Library/Application Support/Sublime Text/Installed Packages, if it exists
[[ -d "${SUBLIME_TEXT_DIR}/Installed Packages" ]] && rm -rf "${SUBLIME_TEXT_DIR}/Installed Packages"

# Create symlink of ~/Library/Application Support/Sublime Text/Installed Packages directory from ~/dotfiles/Application Support/Sublime Text/Installed Packages
ln -s "${DOT_FILES_SUBLIME_TEXT_DIR}/Installed Packages" "${SUBLIME_TEXT_DIR}/Installed Packages"

echo "${SUBLIME_TEXT} setup complete."

unset DOT_FILES_SUBLIME_TEXT_DIR
unset SUBLIME_TEXT_DIR
unset SUBLIME_TEXT
