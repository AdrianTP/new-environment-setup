cucumber_verbose() {
	bundle exec cucumber $1 --format pretty --expand
}

rspec_verbose() {
	bundle exec rspec $1 --format documentation
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

git_uncommit() {
	git reset --soft HEAD~1
}

git_unrebase() {
	git reset --hard ORIG_HEAD
}

if [ -d "$HOME/.vim/session" ];then
    NVIM_SESSION_DIR="$HOME/.vim/session"
fi

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
