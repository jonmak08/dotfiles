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

# Activate mise (essential for managing tool versions)
if has mise; then
	eval "$(mise activate zsh)"
fi

# Load Gusto init (if it exists)
GUSTO_INIT="${HOME}/.gusto/init.sh"
[[ -f $GUSTO_INIT ]] && source "$GUSTO_INIT"

# Any other critical environment setup that should be available in all shells
# Add more tools here as needed (e.g., nvm, rbenv, pyenv, etc.)
