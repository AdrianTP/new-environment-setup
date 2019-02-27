#!/data/data/com.termux/files/usr/bin/bash

# Include utils
# From: https://stackoverflow.com/a/12694189/771948
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/utils/readarray.sh"

# Install Termux tools
readarray "termux_array" "pkg.txt"
packages install ${termux_array[@]}
#packages install nodejs ruby php
