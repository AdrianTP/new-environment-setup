#!/bin/bash

# Setup VIM Preferences
echo "
:set softtabstop=4 shiftwidth=4 expandtab nowrap number
" >> ~/.vimrc

# Setup Bash Profile
cat profile aliases >> ~/.bash_profile

# Fix ctrl-h for navigation mapping in neovim
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti

mkdir -p ~/.config/nvim
cp ./neovim.vim ~/.config/nvim/init.vim

. ~/.bash_profile
