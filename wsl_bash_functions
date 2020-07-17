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

# git_config_enova() {
	# cwd=$(pwd)
	# start_dir="${1:-.}"
	# for d in $(find $start_dir -type d); do
		# dir_absolute=$(greadlink -f $d)
		# cd $dir_absolute
		# # if [ -d .git ] && git rev-parse --git-dir > /dev/null 2>&1; then
		# if is_git_repo; then
			# echo "Updating git config for $dir_absolute"
			# git config --local user.name "athomas8"
			# git config --local user.email "athomas8@enova.com"
		# fi
	# cd $cwd
	# done
# }

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
