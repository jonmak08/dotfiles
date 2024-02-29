#!/bin/sh

KARABINER='karabiner'
KARABINER_DIR="${HOME}/.config/karabiner"

echo "Setting up ${KARABINER}..."

# Remove ~/.config/karabiner/karabiner.json if it exists
[[ -f "${KARABINER_DIR}/karabiner.json" ]] && rm -rf "${KARABINER_DIR}/karabiner.json"

## Make git folder in ~/.config
[[ ! -d "${KARABINER_DIR}" ]] && mkdir -p "${KARABINER_DIR}"

# Create symlink of ~/.config/karabiner/karabiner.json from ~/dotfiles/karabiner/karabiner.json
ln -s "${HOME}/dotfiles/${KARABINER}/karabiner.json" "${KARABINER_DIR}/karabiner.json"

echo "${KARABINER} setup complete."

unset KARABINER_DIR
unset KARABINER
