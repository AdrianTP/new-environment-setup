#!/usr/bin/env bash

setup_env() {
	ATP_PROJECT_OLD_CONFIG_PARENT_DIR_PATH="$CONFIG_PARENT_DIR_PATH"
	ATP_PROJECT_OLD_CONFIG_FILE_REALPATH="$CONFIG_FILE_REALPATH"

	CONFIG_PARENT_DIR_PATH="$(realpath "$HOME/.private")"
	CONFIG_FILE_REALPATH="$(realpath "$CONFIG_PARENT_DIR_PATH/projects.json")"
}

cleanup_env() {
	CONFIG_PARENT_DIR_PATH="$ATP_PROJECT_OLD_CONFIG_PARENT_DIR_PATH"
	CONFIG_FILE_REALPATH="$ATP_PROJECT_OLD_CONFIG_FILE_REALPATH"
}

# From https://stackoverflow.com/a/3232082/771948
confirm() {
	# call with a prompt string or use a default
	read -r -p "${1:-Are you sure?} [y/N] " response
	case "$response" in
		[yY][eE][sS]|[yY])
			true
			;;
		*)
			false
			;;
	esac
}

config_has_project() {
	# shellcheck disable=SC2016
	local query='.projects.projects | has($name)'
	local exists=""

	exists="$(jq -r --arg name "$1" "$query" "$CONFIG_FILE_REALPATH")"

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

	jq -r --arg name "$1" "$query" "$CONFIG_FILE_REALPATH"
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

list() {
	[ ! -f "$CONFIG_FILE_REALPATH" ] && return 1

	# shellcheck disable=SC2016
	local query='.projects.projects | keys[]'

	jq -r "$query" "$CONFIG_FILE_REALPATH"

	return "$?"
}

update() {
	local store="$CONFIG_FILE_REALPATH"
	local tmp="$CONFIG_FILE_REALPATH.tmp"
	local bak="$CONFIG_FILE_REALPATH.bak"

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

add() {
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

	home="$(jq -r '.projects.defaults.home' "$CONFIG_FILE_REALPATH")"
	base="$(jq -r '.projects.defaults.base' "$CONFIG_FILE_REALPATH")"
	team="$(jq -r '.projects.defaults.team' "$CONFIG_FILE_REALPATH")"
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

	jq -e --arg name "$name" --arg org "$org" --arg path "$path" "$write_query" "$CONFIG_FILE_REALPATH" > "$CONFIG_FILE_REALPATH.tmp"

	update

	return "$?"
}

delete() {
	echo "Deleting \"$1\""

	if confirm; then
		jq --arg name "$1" 'del(.projects.projects[$name])' "$CONFIG_FILE_REALPATH" > "$CONFIG_FILE_REALPATH.tmp"

		update

		return "$?"
	else
		echo "No changes were made. Exiting."; return 0;
	fi
}

make_config() {
	echo "Creating new project mapping store at $CONFIG_FILE_REALPATH"

	echo "Please fill out some default values for the config:"
	read -pr "Company Name (company): " company
	read -pr "Team Name (team): " team
	read -pr "Org Name (org): " org

	mkdir -p "$CONFIG_PARENT_DIR_PATH" && \
		jq -n -r\
		--arg home "$HOME"\
		--arg team "$team"\
		--arg company "$company"\
		--arg org "$org"\
		'{
			"teams": { ($team): { "path": $team } },
			"orgs": { ($org): { "path": $org } },
			"projects": {
				"defaults": {
					"home": $home,
					"company": $company,
					"team": $team,
					"org": $org
				},
				"projects": {}
			}
		}' > "$CONFIG_FILE_REALPATH"
}

go() {
	if ! config_has_project "$1"; then
		echo "Project \"$1\" is not mapped."
		return 0
	fi

	cd "$(get_dir_for_project "$1")" || return "$?"
}

setup_map() {
	if [ ! -f "$CONFIG_FILE_REALPATH" ]; then
		echo "I could not find the project mapping store."

		if confirm "Should I initialise a new project mapping store?"; then
			make_config
			return "$?"
		else
			echo "No changes were made. Exiting."
			return 0
		fi
	else
		return 0
	fi
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
		[ $# -gt 1 ] && usage && return 0
		list
		;;
	"-a") # add to map
		[ $# -gt 3 ] || [ -n "$2" ] && ! [ -d "$2" ] && usage && return 0
		setup_map
		add "$2" "$3"
		;;
	"-d") # delete from map
		[ $# -ne 2 ] || [ -z "$2" ] && usage && return 0
		setup_map
		delete "$2"
		;;
	*) # open the project directory
		[ -z "$1" ] && usage && return 0
		setup_map
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
