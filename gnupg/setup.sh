#!/bin/sh

GNUPG='gnupg'
GNUPG_DIR="${HOME}/.gnupg"

echo "Setting up ${GNUPG}..."

# Create  ~/.gnupg directory
[[ ! -d "${GNUPG_DIR}" ]] && mkdir -p "${GNUPG_DIR}"

# Rename ~/.gnupg/gpg-agent.conf to /.gnupg/gpg-agent.conf.bak
[[ -f "${GNUPG_DIR}/gpg-agent.conf" ]] && mv "${GNUPG_DIR}/gpg-agent.conf" "${GNUPG_DIR}/gpg-agent.conf.bak"

# Create symlink of ~/.gnupg/gpg-agent.conf from ~/dotfiles/gnupg/gpg-agent.conf
ln -s "${HOME}/dotfiles/${GNUPG}/gpg-agent.conf" "${GNUPG_DIR}/gpg-agent.conf"

echo "${GNUPG} setup complete."

unset GNUPG_DIR
unset GNUPG
