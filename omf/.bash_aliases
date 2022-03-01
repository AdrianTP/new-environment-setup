alias cpl='clear; pwd; ls -ahl'
alias cplg='cpl; git status'
alias pbp='pbpaste'
alias pbc='pbcopy'
alias brb='pmset displaysleepnow'
alias duptab='open . -a iterm'
alias dockspace='~/utils/dockspace.sh'
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

alias http_ports="lsof -PiTCP -sTCP:LISTEN"

alias sleep_disable="sudo pmset -a sleep 0; sudo pmset -a hibernatemode 0; sudo pmset -a disablesleep 1;"
alias sleep_enable="sudo pmset -a sleep 1; sudo pmset -a hibernatemode 3; sudo pmset -a disablesleep 0;"

alias big_files="du -k * | awk '\$1 > 500000' | sort -nr"

alias git=hub

alias acquisition_local='USE_LOCAL_BACKEND_ENDPOINTS=true MOCK_PASSTHROUGH=true bundle exec rails s -p 3001'
alias frontend_local='USE_LOCAL_BACKEND_ENDPOINTS=true MOCK_PASSTHROUGH=true ACQUISITION_URL=http://localhost:3001/ CASHBACK_URL=http://localhost:3002/ bundle exec rails s'
