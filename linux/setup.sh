#!/bin/bash

# Setup VIM Preferences
echo "
:set softtabstop=4 shiftwidth=4 expandtab nowrap number
" >> "$HOME/.vimrc"

# Setup Bash Profile
cat profile aliases >> "$HOME/.bash_profile"

# Fix ctrl-h for navigation mapping in neovim
# https://github.com/christoomey/vim-tmux-navigator/issues/71
OLDDIR=$PWD
cd $HOME
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti
cd $OLDDIR

mkdir -p "$HOME/.config/nvim"
cp ../common/neovim.vim ~/.config/nvim/init.vim

source "$HOME/.bash_profile"
