#!/data/data/com.termux/files/usr/bin/bash

# Install Termux dependencies
packages install \
  termux-tools neovim git openssh coreutils ncurses-utils
#packages intall nodejs ruby php

# Setup VIM Preferences
echo "
:set softtabstop=4 shiftwidth=4 expandtab nowrap number
" >> ~/.vimrc

# Setup Bash Profile
cat profile_termux alias_termux >> ~/.bash_profile

# Fix ctrl-h for navigation mapping in neovim
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti

mkdir -p ~/.config/nvim
cp ./neovim.vim ~/.config/nvim/init.vim

. ~/.bash_profile
