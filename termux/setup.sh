#!/data/data/com.termux/files/usr/bin/bash

# Include utils
# From: https://stackoverflow.com/a/12694189/771948
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/utils/readarray.sh"

# Install Termux tools
readarray "termux_array" "pkg.txt"
packages install ${termux_pkg[@]}
#packages intall nodejs ruby php

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
