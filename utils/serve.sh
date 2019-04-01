#!/usr/bin/env bash

if [ -n "$1" ]; then
  PORT=$1
else
  PORT='8000'
fi

if type ruby >/dev/null 2>&1; then
  # $(ruby -rwebrick -e'WEBrick::HTTPServer.new(:Port => $PORT, :DocumentRoot => Dir.pwd).start')
  $(ruby -run -ehttpd . -p$PORT) # Ruby 1.9.2+
elif php >/dev/null 2>&1; then
  $(php -S localhost:$PORT)
elif python >/dev/null 2>&1; then
  # $(python -m SimpleHTTPServer $PORT) # Python 2.x
  $(python -m http.server $PORT) # Python 3.x
else
  echo 'Missing required programmes'
fi
