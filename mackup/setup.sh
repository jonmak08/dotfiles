#!/bin/sh

MACKUP='mackup'

echo "Setting up ${MACKUP}..."

# Remove ~/.mackup.cfg if it exists
[[ -f "${HOME}/.mackup.cfg" ]] && rm -rf "${HOME}/.mackup.cfg"

# Create symlink of ~/.mackup.cfg from ~/dotfiles/mackup/.mackup.cfg
ln -s "${HOME}/dotfiles/${MACKUP}/.mackup.cfg" "${HOME}/.mackup.cfg"

echo "${MACKUP} setup complete."

unset MACKUP
