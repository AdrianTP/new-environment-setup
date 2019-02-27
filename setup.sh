#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
  # Mac OS X
  OS='mac'
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  OS='linux'
elif [ $var = "/data/data/com.termux/files/usr/bin/bash" ]; then
  # Termux # thanks to https://github.com/KonradIT/dotfiles/blob/master/bashrc#L235
  OS='termux'
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  # 32-bit Windows
  echo 'Does not support 32-bit Windows yet'
  return 1
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
  # 64-bit Windows
  echo 'Does not support 64-bit Windows yet'
  return 1
fi

# Setup Bash Profile
cat "$OS/profile" "$OS/aliases" >> "$HOME/.test_output"

# Setup basic VIM Preferences
echo "
:set softtabstop=4 shiftwidth=4 expandtab nowrap number
" >> "$HOME/.vimrc"

# Fix ctrl-h for navigation mapping in neovim
# https://github.com/christoomey/vim-tmux-navigator/issues/71
OLDDIR=$PWD
cd $HOME
infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
tic $TERM.ti
cd $OLDDIR

# Copy my Neovim config into the appropriate directory
mkdir -p "$HOME/.config/nvim"
cp ./common/neovim.vim "$HOME/.config/nvim/init.vim"

# run the environment-specific config
[ ! -z "$OS" ] && exec "./$OS/setup.sh"

# source bash_profile so everything is ready to go
source "$HOME/.bash_profile"
return 0
