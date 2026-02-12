#!/bin/sh

CURSOR='Cursor'
CURSOR_USER_DIR="${HOME}/Library/Application Support/${CURSOR}/User"

echo "Setting up ${CURSOR}..."

# Remove settings.json if it exists
[[ -f "${CURSOR_USER_DIR}/settings.json" ]] && rm -rf "${CURSOR_USER_DIR}/settings.json"

# Create symlink for settings.json
ln -s "${HOME}/dotfiles/Application Support/${CURSOR}/User/settings.json" "${CURSOR_USER_DIR}/settings.json"

# Remove workspace files if they exist
[[ -f "${CURSOR_USER_DIR}/gusto.code-workspace" ]] && rm -rf "${CURSOR_USER_DIR}/gusto.code-workspace"
[[ -f "${CURSOR_USER_DIR}/mithrin.code-workspace" ]] && rm -rf "${CURSOR_USER_DIR}/mithrin.code-workspace"
[[ -f "${CURSOR_USER_DIR}/web.code-workspace" ]] && rm -rf "${CURSOR_USER_DIR}/web.code-workspace"
[[ -f "${CURSOR_USER_DIR}/zenpayroll.code-workspace" ]] && rm -rf "${CURSOR_USER_DIR}/zenpayroll.code-workspace"

# Create symlinks for workspace files
ln -s "${HOME}/dotfiles/Application Support/${CURSOR}/User/gusto.code-workspace" "${CURSOR_USER_DIR}/gusto.code-workspace"
ln -s "${HOME}/dotfiles/Application Support/${CURSOR}/User/mithrin.code-workspace" "${CURSOR_USER_DIR}/mithrin.code-workspace"
ln -s "${HOME}/dotfiles/Application Support/${CURSOR}/User/web.code-workspace" "${CURSOR_USER_DIR}/web.code-workspace"
ln -s "${HOME}/dotfiles/Application Support/${CURSOR}/User/zenpayroll.code-workspace" "${CURSOR_USER_DIR}/zenpayroll.code-workspace"

# Also create symlink for VSCode to share Cursor settings
CODE_USER_DIR="${HOME}/Library/Application Support/Code/User"
[[ -f "${CODE_USER_DIR}/settings.json" ]] && rm -rf "${CODE_USER_DIR}/settings.json"
ln -s "${HOME}/dotfiles/Application Support/${CURSOR}/User/settings.json" "${CODE_USER_DIR}/settings.json"

echo "${CURSOR} setup complete."

unset CURSOR_USER_DIR
unset CODE_USER_DIR
unset CURSOR
