# Begin AdrianTP's Custom Profile Edits
alias cpl='clear;pwd;ls -la'
alias cplg='cpl; git status'
#PS1=\u\$
alias dockspace='~/dockspace.sh'
alias be='bundle exec'
alias bi='bundle install'
alias bu='bundle update'
alias nw='/Applications/nwjs.app/Contents/MacOS/nwjs'
alias electron='/Applications/Electron.app/Contents/MacOS/Electron'

# Git-Autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
