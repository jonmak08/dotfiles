# ~/.zshenv
# This file is loaded for ALL zsh shells (interactive and non-interactive)
# Use this for essential environment setup that should be available everywhere

# Helper to check if a command exists
has() {
	command -v "$1" >/dev/null 2>&1
}

# Load PATH and other essential environment variables from dotfiles
for file in ~/dotfiles/terminal/.path ~/dotfiles/terminal/.exports; do
	[[ -f $file ]] && source $file
done

# Load private exports (tokens, secrets, etc.)
# This file is not tracked in git
[[ -f "${HOME}/dotfiles/terminal/.exports_private" ]] && source "${HOME}/dotfiles/terminal/.exports_private"

# Load Gusto init (if it exists). This configures mise itself, in shims mode.
GUSTO_INIT="${HOME}/.gusto/init.sh"
[[ -f $GUSTO_INIT ]] && source "$GUSTO_INIT"

# Activate mise (essential for managing tool versions), but only when Gusto's
# init didn't already do it. Activating on top of it breaks Gusto tooling:
# `scope doctor` requires commands to resolve through ~/.local/share/mise/shims,
# and `mise activate` (PATH mode) installs a precmd hook that recomputes PATH
# from its own baseline, dropping that shims dir on the next prompt.
if [[ -z ${_GUSTO_CONFIG_FILES_INITIALIZED:-} ]] && has mise; then
	eval "$(mise activate zsh)"
fi

# Any other critical environment setup that should be available in all shells
# Add more tools here as needed (e.g., nvm, rbenv, pyenv, etc.)
