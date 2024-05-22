# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/dotfiles/terminal/.*; do
	[[ -r $file ]] && [[ -f $file ]] && source $file;
done;

unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "${option}" 2> /dev/null;
done;

# Activate brew
if which brew; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi;

# Add tab completion for many Bash commands
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# Activate nvm
NVM='nvm'
BREW_NVM_DIR=$(brew --prefix nvm)

# Load nvm
[[ -s "${BREW_NVM_DIR}/${NVM}.sh" ]] && \. "${BREW_NVM_DIR}/${NVM}.sh"

# Load nvm bash_completion
[[ -s "${BREW_NVM_DIR}/etc/bash_completion.d/${NVM}" ]] && \. "${BREW_NVM_DIR}/etc/bash_completion.d/${NVM}"

unset BREW_NVM_DIR
unset NVM

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
	complete -o default -o nospace -F _git g;
fi;

# Enable bash-git-prompt
GIT_PROMPT_DIR="$(brew --prefix bash-git-prompt)/share";
GIT_PROMPT_SH="${GIT_PROMPT_DIR}/gitprompt.sh";

if [ -f $GIT_PROMPT_SH ]; then
  __GIT_PROMPT_DIR=${GIT_PROMPT_DIR}

  GIT_PROMPT_ONLY_IN_REPO=1

  source $GIT_PROMPT_SH
fi

unset GIT_PROMPT_DIR
unset GIT_PROMPT_SH

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[[ -e "${HOME}/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Activate rbenv
if which rbenv > /dev/null; then
	eval "$(rbenv init - bash)";
fi

# Gusto Init
GUSTO_INIT='~/.gusto/init.sh'

[[ -f $GUSTO_INIT ]] && source $GUSTO_INIT;

unset GUSTO_INIT
