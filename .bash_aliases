alias cpl='clear; pwd; ls -ahl'
alias cplg='cpl; git status'
# alias pbp='pbpaste'
# alias pbc='pbcopy'
# alias duptab='open . -a iterm'
#PS1=\u\$
# alias dockspace='~/dockspace.sh'
alias be='bundle exec'
alias larry='be cucumber'
alias wwld='echo "What would Larry do?";be cucumber'
alias bi='bundle install'
alias bu='bundle update'
alias migrate_dev='be rake db:migrate RAILS_ENV=development'
alias migrate_test='be rake db:migrate RAILS_ENV=test'
alias reset_dev='be rake db:reset RAILS_ENV=development'
alias reset_test='be rake db:reset RAILS_ENV=test'
alias pg_root="sudo psql -U $USER postgres"
alias clean_rake='redis-cli FLUSHALL; be rake'

# personal dev shortcuts
# alias nw='/Applications/nwjs.app/Contents/MacOS/nwjs'
# alias electron='/Applications/Electron.app/Contents/MacOS/Electron'

# Lazy Git Shortcuts
alias gbr='git branch'
alias gco='git checkout'
alias gci='git commit'
alias gdi='git diff'
alias gfe='git fetch'
alias glo='git log'
alias gpl='git pull'
alias gplu='git pull upstream'
alias gplo='git pull origin'
alias gps='git push'
alias gpso='git push origin'
alias gre='git reset'
alias gst='git stash'
alias latest='BN=$(git symbolic-ref --short -q HEAD); \
  STM=$(gst); gco master; gplu master; \
  gco $BN; if [[ $STM == Saved* ]]; then gst pop; fi'

# XAMPP-VM SSH
# alias xampp-vm="ssh -i '/Users/athomas8/.bitnami/stackman/machines/xampp/ssh/id_rsa' -o StrictHostKeyChecking=no 'root@192.168.64.2'"

# Tux Racer Docker
# alias tuxracer="docker run -dp 80:80 dtcooper/tuxracer-web && sleep 2 && python -m webbrowser http://localhost/"

# alias http-ports="lsof -nP +c 15 | grep LISTEN"
# alias http-ports="sudo lsof -PiTCP -sTCP:LISTEN"
# alias http-ports="netstat -ap tcp | grep -i listen"

# alias gobjdump="/usr/local/Cellar/binutils/2.32/bin/objdump"

# alias sleep_disable="sudo pmset -a sleep 0; sudo pmset -a hibernatemode 0; sudo pmset -a disablesleep 1;"
# alias sleep_enable="sudo pmset -a sleep 1; sudo pmset -a hibernatemode 3; sudo pmset -a disablesleep 0;"

alias big_files="du -k * | awk '\$1 > 500000' | sort -nr"

# alias activate_py37="source ~/miniconda3/bin/activate py37"
# alias deactivate_py37="source ~/miniconda3/bin/deactivate py37"
