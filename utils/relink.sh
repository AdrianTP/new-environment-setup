#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
	echo 'format: relink "old" "new" "/absolute/path/to/link"'

	if [ "$1" = 'help' ]; then
		echo 'to replace all symlinks in current directory and below:'
		echo '  find "$(pwd)" -type l -exec relink "old" "new" "{}" \;'
	fi
fi

# Modified from https://stackoverflow.com/a/21803843
target=$(readlink "$3")
if [[ $target =~ $1 ]]; then
	newtarget=${target//$1/$2}
	echo "Replacing $target with $newtarget"
	ln -snf "$newtarget" "$3"
fi
