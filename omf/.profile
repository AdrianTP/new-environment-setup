echo "loading $USER's .profile"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
      . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/repos/personal/new-environment-setup/utils" ]; then
    PATH="$HOME/repos/personal/new-environment-setup/utils:$PATH"
fi

# Git-Autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# iTermocil Autocomplete
if command -v itermocil &> /dev/null; then
	complete -W "$(itermocil --list)" itermocil
fi

# custom db command autocomplete
if command -v db &> /dev/null; then
	complete -W "$(db -l)" db
fi

if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
	[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

PATH="/usr/local/opt/postgresql@10/bin:$PATH"
PATH="/usr/local/opt/influxdb@1/bin:$PATH"
