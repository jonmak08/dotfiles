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

# Rename ~/.gnupg/gpg.conf to /.gnupg/gpg.conf.bak
[[ -f "${GNUPG_DIR}/gpg.conf" ]] && mv "${GNUPG_DIR}/gpg.conf" "${GNUPG_DIR}/gpg.conf.bak"

# Create symlink of ~/.gnupg/gpg.conf from ~/dotfiles/gnupg/gpg.conf
ln -s "${HOME}/dotfiles/${GNUPG}/gpg.conf" "${GNUPG_DIR}/gpg.conf"

echo "${GNUPG} setup complete."

unset GNUPG_DIR
unset GNUPG
