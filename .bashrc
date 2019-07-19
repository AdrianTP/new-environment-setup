export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
[ -d "/Users/athomas-prestemon/enova/8b/bin" ] && export PATH="/Users/athomas-prestemon/enova/8b/bin:$PATH"
export GOPATH=$HOME/enova/go
export PATH=$PATH:$(go env GOPATH)/bin
