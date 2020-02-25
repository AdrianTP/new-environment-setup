#!/usr/bin/env bash

setup_env() {
	local filename="projects.json"
	ATP_PROJECT_CONFIG_PARENT_DIR_PATH="$(realpath "$HOME/.private")"
	ATP_PROJECT_CONFIG_FILE_REALPATH="$(realpath "$ATP_PROJECT_CONFIG_PARENT_DIR_PATH/$filename")"
}

cleanup_env() {
	unset ATP_PROJECT_CONFIG_PARENT_DIR_PATH
	unset ATP_PROJECT_CONFIG_FILE_REALPATH
}

# From https://stackoverflow.com/a/3232082/771948
confirm() {
	# call with a prompt string or use a default
	read -r -p "${1:-Are you sure?} [y/N] " response
	case "$response" in
		[yY][eE][sS]|[yY])
			return 0
			;;
		*)
			return 1
			;;
	esac
}

config_has_project() {
	# shellcheck disable=SC2016
	local query='.projects.projects | has($name)'
	local exists=""

	exists="$(jq -r --arg name "$1" "$query" "$ATP_PROJECT_CONFIG_FILE_REALPATH")"

	if [ "$exists" = "true" ]; then
		true
	else
		false
	fi
}

get_dir_for_project() {
	# shellcheck disable=SC2016
	local query='.projects.defaults * .projects.projects[$name]
	 | "\(.home)/\(.base)/teams/\(.team)/\(.org)/\(.path)/"'

	jq -r --arg name "$1" "$query" "$ATP_PROJECT_CONFIG_FILE_REALPATH"
}

usage() {
	echo "Usage:
		project <name>
			cd to the directory mapped to the given name (tab completion available)
		project -l
			List all mapped projects
		project -a
			Add the current directory to the project list, named matching the current folder
		project -a <relative/path>
			Add the specified relative path to the project list, named matching the folder
		project -a <relative/path> <name>
			Add the specified relative path to the project list, mapped to the given name
		project -d <name>
			Remove from the project list the mapping matching the specified name"
}

make_config() {
	echo "Creating new project mapping store at $ATP_PROJECT_CONFIG_FILE_REALPATH"

	echo "Please fill out some default values for the config:"
	read -rp "Base Name (base): " base
	read -rp "Team Name (team): " team
	read -rp "Org Name (org): " org

	mkdir -p "$ATP_PROJECT_CONFIG_PARENT_DIR_PATH" && \
		jq -n -r\
		--arg home "$HOME"\
		--arg team "$team"\
		--arg base "$base"\
		--arg org "$org"\
		'{
			"teams": { ($team): { "path": $team } },
			"orgs": { ($org): { "path": $org } },
			"projects": {
				"defaults": {
					"home": $home,
					"base": $base,
					"team": $team,
					"org": $org
				},
				"projects": {}
			}
		}' > "$ATP_PROJECT_CONFIG_FILE_REALPATH"

	[ -f "$ATP_PROJECT_CONFIG_FILE_REALPATH" ] && return 0 || return 1
}

setup_map() {
	if ! [ -f "$ATP_PROJECT_CONFIG_FILE_REALPATH" ]; then
		echo "I could not find the project mapping store."

		if confirm "Should I initialise a new project mapping store?"; then
			make_config && return 0 || return 1
		else
			echo "No changes were made. Exiting."
			return 1
		fi
	else
		return 0
	fi
}

update() {
	local store="$ATP_PROJECT_CONFIG_FILE_REALPATH"
	local tmp="$ATP_PROJECT_CONFIG_FILE_REALPATH.tmp"
	local bak="$ATP_PROJECT_CONFIG_FILE_REALPATH.bak"

	if [ -f "$tmp" ]; then
		echo "Backing up the project mapping store."
		mv "$store" "$bak"

		if [ -f "$store" ]; then
			echo "Failed to backup the project mapping store. Exiting."
			return 1
		fi

		echo "Writing to the project mapping store."
		mv "$tmp" "$store"

		if [ -f "$tmp" ]; then
			echo "Failed to write to the project mapping store. Restoring from backup."
			mv "$bak" "$store"

			if [ -f "$bak" ]; then
				echo "Failed to restore the project mapping store from backup. Exiting."
				return 1
			fi
		fi

		if [ -f "$tmp" ]; then
			echo "Cleaning up."
			rm "$tmp"
		fi

		if ! [ -f "$store" ]; then
			echo "Cannot locate the project mapping store. Exiting."
			return 1
		fi

		complete -W "$(list)" project
		return 0
	else
		echo "Update failed. Exiting."
		return 1
	fi

	return "$?"
}

list() {
	[ ! -f "$ATP_PROJECT_CONFIG_FILE_REALPATH" ] && return 1

	# shellcheck disable=SC2016
	local query='.projects.projects | keys[]'

	jq -r "$query" "$ATP_PROJECT_CONFIG_FILE_REALPATH"

	return "$?"
}

add() {
	setup_map || return 1

	local fullpath=""
	local name=""

	# shellcheck disable=SC2016
	local write_query='.projects.projects[$name]={ org: $org, path: $path }'

	# use current directory if none specified
	[ -z "$1" ] && fullpath="$(pwd)" || fullpath="$(realpath "$1")"
	# use folder name as name if no args
	[ -z "$2" ] && name="$(basename "$fullpath")" || name="$(basename "$2")"

	if config_has_project "$name"; then
		echo "Project \"$name\" is already mapped!"
		return 1
	fi

	home="$(jq -r '.projects.defaults.home' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
	base="$(jq -r '.projects.defaults.base' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
	team="$(jq -r '.projects.defaults.team' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
	root="$home/$base/teams/$team/"

	org="$(cut -d'/' -f1 <<< "${fullpath/$root/}")"
	if [ -z "$org" ]; then
		echo "Could not automatically determine the org this project belongs to."
		echo "It is possible that it is not mapped to the folder structure."
		echo "Exiting."

		return 1
	fi

	root+="$org/"
	path=${fullpath/$root/}

	jq -e --arg name "$name" --arg org "$org" --arg path "$path" "$write_query" "$ATP_PROJECT_CONFIG_FILE_REALPATH" > "$ATP_PROJECT_CONFIG_FILE_REALPATH.tmp"

	update && return 0 || return 1
}

delete() {
	setup_map || return 1

	echo "Deleting \"$1\""

	if confirm; then
		jq --arg name "$1" 'del(.projects.projects[$name])' "$ATP_PROJECT_CONFIG_FILE_REALPATH" > "$ATP_PROJECT_CONFIG_FILE_REALPATH.tmp"

		update

		return "$?"
	else
		echo "No changes were made. Exiting."; return 0;
	fi
}

go() {
	setup_map || return 1

	if ! config_has_project "$1"; then
		echo "Project \"$1\" is not mapped."
		return 0
	fi

	cd "$(get_dir_for_project "$1")" || return "$?"
}

# App entry point
run() {
	if ! [ -x "$(command -v jq)" ]; then # https://stackoverflow.com/a/26759734/771948
		# shellcheck disable=SC2016
		echo 'jq is not installed. Run `brew install jq`.' >&2
		return 1
	fi

	setup_env

	case "$1" in
	"-l") # list names of mapped projects
		[ $# -gt 1 ] && usage && return 1
		list
		;;
	"-a") # add to map
		[ $# -gt 3 ] || [ -n "$2" ] && ! [ -d "$2" ] && usage && return 1
		add "$2" "$3"
		;;
	"-d") # delete from map
		[ $# -ne 2 ] || [ -z "$2" ] && usage && return 1
		delete "$2"
		;;
	*) # open the project directory
		[ -z "$1" ] && usage && return 1
		go "$1"
		;;
	esac

	cleanup_env

	return "$?"
}

# The recommended use of this script includes the inclusion of the following
# code in your ~/.bash_profile:
#
# project() {
# 	source "project.sh"
# 	run "$@"
# }

# complete -W "$(project -l)" project
