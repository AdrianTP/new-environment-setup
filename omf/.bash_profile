echo "loading $USER's .bash_profile"

export https_proxy=http://127.0.0.1:9000
export http_proxy=http://127.0.0.1:9000
export HTTP_PROXY=http://127.0.0.1:9000
export HTTPS_PROXY=http://127.0.0.1:9000

source "$HOME/.profile"

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

    alias git=hub
