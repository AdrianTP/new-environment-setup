#!/usr/bin/env bash

# iTerm window title function
# Record title from user input, or as user argument
[ -z "$TERM_SESSION_ID" ] && echo "Error: Not an iTerm session." && return 1
if [ -n "$1" ]; then # warning: $@ is somehow always non-empty!
  echo -ne "\033]0;"$@"\007"
else
  echo "Must specify a title"
fi
