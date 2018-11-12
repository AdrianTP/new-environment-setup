#!/usr/bin/env bash

if [ "$(uname)" == "Darwin" ]; then
  # Mac OS X
  ./mac.sh
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Linux
  ./linux.sh
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
  # 32-bit Windows
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
  # 64-bit Windows
fi
