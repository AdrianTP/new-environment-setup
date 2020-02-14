source "$HOME/.bashrc"
source "$HOME/.profile"
source "$HOME/.private/repos_projects"

# Begin AdrianTP's Custom Profile Edits
alias cpl='clear; pwd; ls -ahl'
alias cplg='cpl; git status'
alias pbp='pbpaste'
alias pbc='pbcopy'
alias duptab='open . -a iterm'
#PS1=\u\$
alias dockspace='~/dockspace.sh'
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
alias nw='/Applications/nwjs.app/Contents/MacOS/nwjs'
alias electron='/Applications/Electron.app/Contents/MacOS/Electron'

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
alias xampp-vm="ssh -i '/Users/athomas8/.bitnami/stackman/machines/xampp/ssh/id_rsa' -o StrictHostKeyChecking=no 'root@192.168.64.2'"

# Tux Racer Docker
alias tuxracer="docker run -dp 80:80 dtcooper/tuxracer-web && sleep 2 && python -m webbrowser http://localhost/"

# alias http-ports="lsof -nP +c 15 | grep LISTEN"
alias http-ports="sudo lsof -PiTCP -sTCP:LISTEN"
# alias http-ports="netstat -ap tcp | grep -i listen"

alias gobjdump="/usr/local/Cellar/binutils/2.32/bin/objdump"

alias sleep_disable="sudo pmset -a sleep 0; sudo pmset -a hibernatemode 0; sudo pmset -a disablesleep 1;"
alias sleep_enable="sudo pmset -a sleep 1; sudo pmset -a hibernatemode 3; sudo pmset -a disablesleep 0;"

# Enova-specific stuff
alias pipeline="$HOME/enova/teams/jarvis/dev/pipeline/pipeline"
# alias nconjure="$HOME/enova/teams/jarvis/netcredit/nconjure/bin/nconjure"
alias traps_stop="/Library/Application Support/PaloAltoNetworks/Traps/bin/cytool runtime stop all"

alias big_files="du -k * | awk '\$1 > 500000' | sort -nr"

# Change owner of all files belonging to a user/group
# sudo find . -user old_user -group old_group -exec chown new_user:new_group "{}" \;
# add `-h` flag to chown to make it work on symlinks, too!

# Replace string in all found files
# find . -type f -exec gsed -i -e 's/athomas-prestemon/athomas8/g' "{}" \;

# Git Autocomplete
if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

# iTermocil Autocomplete
complete -W "$(itermocil --list)" itermocil

# # Prevent Homebrew from automatically updating
# export HOMEBREW_NO_AUTO_UPDATE=1

# install a specific version of an app from Homebrew
# usage: brew_install_version <name> <version>
brew_install_version() {
	DIR="$(pwd)"
	REPO="$(brew --repo homebrew/core)"
	LOG_GREP="$1 $2"

	cd $REPO

	git checkout master
	LOG=$(git --no-pager log -n 20 master --pretty=oneline --grep="$LOG_GREP")

	HASH=$(echo $LOG | gsed -rn 's/^([0-9a-fA-F]{8,40}).*/\1/p')

	git checkout $HASH

	export HOMEBREW_NO_AUTO_UPDATE=1

	brew install $1

	git checkout master

	unset HOMEBREW_NO_AUTO_UPDATE

	cd $DIR
}

chredoby() {
	redoby "$HOME/.rubies" $1
}

chbundlerfix() {
	for d in $HOME/.rubies/*; do
		ruby_version=$(basename $d)
		echo "Installing bundler 1.17.3 for $ruby_version..."
		chruby $ruby_version; gem install bundler -v '1.17.3';
	done
}

bundlerfix() {
	# taken from https://bundler.io/blog/2019/05/14/solutions-for-cant-find-gem-bundler-with-executable-bundle.html
	gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
}

redoby() {
	# FIXME: currently broken, do not use
	echo "this is currently broken, sorry"
	return 1

	# inspired by https://gist.github.com/yannvery/b1cf1a7b11ac84e798a5
	# one or two args
	# custom dir, soft: redoby <dir>
	# custom dir, hard: redoby <dir> hard

	read -r -d '' usage <<-'USAGE'
		Usage:
		  Soft mode (just reinstalls):
		    redoby <rubies_directory>
		  Hard mode (deletes rubies before reinstall):
		    redoby <rubies_directory> hard
	USAGE

	echo "1 $#"

	if [[ "$#" -eq 0 ]]; then echo $usage; return 1; fi

	target_dir=$(cd "${1/#\~/$HOME}"; pwd)

	echo "2"

	[[ -z "$1" ]] && echo "path must not be blank";

	echo "3"

	[[ -d $target_dir ]] || return 1

	echo "4 $target_dir-bak"
	# backup directory
	# TODO: figure out how to make this work
	# cp -r "$target_dir" "$target_dir-bak"

	echo "5"
	# iterate versions
	for r in $target_dir/*; do
		echo "6 $r"
		ruby_path=$(greadlink -f "$r")
		ruby_version=$(basename "$ruby_path" | cut -d'-' -f 2)

		echo "7 $ruby_path"
		# if hard_mode, delete dir
		[[ $2 = 'hard' ]] && echo "rm -rf $ruby_path"

		# install ruby
		ruby-build "$ruby_version" "$target_dir/ruby-$ruby_version"
	done

	echo "Done."
	# echo "Be sure to delete $target_dir-bak once you're sure everything is working."
}

gem_pristine() {
	versions=$(chruby)
	rubies_dir="$HOME/.rubies"

	for r in $rubies_dir/*; do
		ruby_path=$(greadlink -f "$r")
		ruby_version=$(basename "$ruby_path" | cut -d'-' -f 2)

		echo "running 'gem pristine --all' on ruby $ruby_version"

		chruby $ruby_version && gem pristine --all
	done
}

[[ -v dbs[@] ]] || declare -A dbs=(
	["example"]="psql -h <db_server_address> -d <db_name> -p <port> -U <username> -W"
)

db() {
	if ! [ -x "$(command -v jjg)" ]; then # https://stackoverflow.com/a/26759734/771948
		echo 'jq is not installed. Run \`brew install jq\`.' >&2
		exit 1
	fi
	# command -v foo >/dev/null 2>&1 || { echo >&2 "jq is not installed. Run \`brew install jq\`."; exit 1; }
	# if [ -v "dbs[$1]" ]; then
	# 	exec ${dbs[$1]}
	# else
	# 	echo "Database \"$1\" is not mapped."
	# 	return 1
	# fi
}

_db() {
	local cur
	local options

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	options=$(join_by ' ' "${!dbs[@]}")

	case "$cur" in
		*) COMPREPLY=( $( compgen -W "$options" -- $cur ) );;
	esac

	return 0
}

complete -F _db -o filenames db

[[ -v repos[@] ]] || declare -A repos=(
	["example"]="$HOME/example"
)

# Takes you to the mapped local folder for the specified Repo (Git Organisation)
repo() {
	if [ -v "repos[$1]" ]; then
		cd "${repos[$1]}"
	else
		echo "Repo \"$1\" is not mapped."
		return 1
	fi
}

# Enables suggestions in the terminal for the `repo` command
_repo() {
	local cur
	local options

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	options=$(join_by ' ' "${!repos[@]}")

	case "$cur" in
		*) COMPREPLY=( $( compgen -W "$options" -- $cur ) );;
	esac

	return 0
}

complete -F _repo -o filenames repo

[[ -v projects[@] ]] || declare -A projects=(
	["example"]="$HOME/example"
)

# Takes you to the mapped local folder for the specified Project (Git Repository)
project() {
	if [ -v "projects[$1]" ]; then
		cd "$HOME/${projects[$1]}"
	else
		echo "Project \"$1\" is not mapped."
		return 1
	fi
}

# Enables suggestions in the terminal for the `project` command
_project() {
	local cur
	local options

	COMPREPLY=()
	cur=${COMP_WORDS[COMP_CWORD]}
	options=$(join_by ' ' "${!projects[@]}")

	case "$cur" in
		*) COMPREPLY=( $( compgen -W "$options" -- $cur ) );;
	esac

	return 0
}

complete -F _project -o filenames project

join_by() { local IFS="$1"; shift; echo "$*"; }

cucumber_verbose() {
	be cucumber $1 --format pretty --expand
}

rspec_verbose() {
	be rspec $1 --format documentation
}

git_stash() {
	git stash push -m "$1"
}

git_unstash() {
	stash_id=$(git stash list | grep "$1" | gsed -rn 's/^(stash\@\{[[:digit:]]\}).*/\1/p')
	git stash pop "$stash_id"
}

is_git_repo() {
	[ -d .git ] && git rev-parse --git-dir > /dev/null 2>&1
}

git_config_enova() {
	cwd=$(pwd)
	start_dir="${1:-.}"
	for d in $(find $start_dir -type d); do
		dir_absolute=$(greadlink -f $d)
		cd $dir_absolute
		# if [ -d .git ] && git rev-parse --git-dir > /dev/null 2>&1; then
		if is_git_repo; then
			echo "Updating git config for $dir_absolute"
			git config --local user.name "athomas8"
			git config --local user.email "athomas8@enova.com"
		fi
	cd $cwd
	done
}

git_uncommit() {
	git reset --soft HEAD~1
}

git_unrebase() {
	git reset --hard ORIG_HEAD
}

title() {
	# Record title from user input, or as user argument
	[ -z "$TERM_SESSION_ID" ] && echo "Error: Not an iTerm session." && return 1
	if [ -n "$1" ]; then # warning: $@ is somehow always non-empty!
		echo -ne "\033]0;"$@"\007"
	else
		echo "Must specify a title"
	fi
}

serve() {
	PORT="${1:-8000}"
	TYPE="${2:-ruby}"

	# if [ -n "$2" ]; then
	# 	TYPE=$2
	# else
	# 	TYPE='ruby'
	# fi

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
}

export NVIM_SESSION_DIR="$HOME/.vim/session"

nvim_session_ls() {
	if [ -z "$1" ]; then
		ls "$NVIM_SESSION_DIR"
	else
		ls "$NVIM_SESSION_DIR" | grep "$1"
	fi
}

nvim_session() {
	# TODO: add autocomplete https://iridakos.com/tutorials/2018/03/01/bash-programmable-completion-tutorial.html
	nvim -S "$NVIM_SESSION_DIR/$1.vim"
}

mkcd() {
	mkdir -p "$@"
	echo "made dirs, switching to $@"
	builtin cd "$@"
}

go_test() {
	go test -count=1 -v ./...
}

# cd {
# 	# actually change the directory with all args passed to the function
# 	builtin cd "$@"
# 	# if there's a regular file named "todo.txt"...
# 	if [ -f "todo.txt" ] ; then
# 		# display its contents
# 		cat todo.txt
# 	fi
# 	# TODO: if git repo, cplg
# }

# git {
# 	builtin git "$@"
# 	# TODO: if clone command and if remotes contain "git.enova.com"
# 	# TODO: then run git_config_enova
# }

# Neo4j Directories
export NEO4J_DESKTOP_DIR="$HOME/Library/Application Support/Neo4j Desktop/Application/neo4jDatabases"
export NEO4J_CLI_DIR=/usr/local/Cellar/neo4j

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

##
# Your previous /Users/athomas8/.bash_profile file was backed up as /Users/athomas8/.bash_profile.macports-saved_2019-01-18_at_15:25:09
##

# MacPorts Installer addition on 2019-01-18_at_15:25:09: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

# Make OpenSSL be a thing
export PATH="/usr/local/opt/openssl/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

# Make Ruby be a thing
# export PATH="/usr/local/opt/ruby/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/ruby/lib"
# export CPPFLAGS="-I/usr/local/opt/ruby/include"
# export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# From https://gemfury.com/help/could-not-verify-ssl-certificate/
export SSL_CERT_FILE=/usr/local/etc/openssl/cert.pem

# From https://stackoverflow.com/a/40372831/771948
# export SSL_CERT_FILE=/usr/local/etc/openssl/cacert.pem

# Homebrew complained at me, so here:
export PATH="/usr/local/sbin:$PATH"