#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
  # Mac OS X
  ./mac.sh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  ./linux.sh
elif [ $var = "/data/data/com.termux/files/usr/bin/bash" ]; then
  # Termux # thanks to https://github.com/KonradIT/dotfiles/blob/master/bashrc#L235
  ./termux.sh
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  # 32-bit Windows
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
  # 64-bit Windows
fi
