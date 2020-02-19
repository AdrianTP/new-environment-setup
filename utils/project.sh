#!/usr/bin/env bash

atp_project_list() {
	jq -r '.projects.projects | keys[]' "$ATP_PROJECT_CONFIG_FILE_REALPATH"
	return "$?"
}

atp_project_update() {
	if [ -f "$ATP_PROJECT_CONFIG_FILE_REALPATH.tmp" ]; then
		mv "$ATP_PROJECT_CONFIG_FILE_REALPATH" "$PROJECT_CONFIG_FILE_REALPATH.bak" && mv "$PROJECT_CONFIG_FILE_REALPATH.tmp" "$PROJECT_CONFIG_FILE_REALPATH"
	fi

	# TODO: figure out how to refresh the autocompletion (without using the daemon)
	# names="$(list)"
	# complete -W "$names" project

	return "$?"
}

atp_project_add() {
	# shellcheck disable=SC2016
	query='.projects.projects[$name]={ org: $org, path: $path }'
	fullpath="$(pwd)"
	name="$(basename "$fullpath")"

	# config_has_project="$(jq -r --arg name "$name" '.projects.projects | has($name)' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
	config_has_project=""

	if [ "$config_has_project" = "true" ]; then
		echo "Project \"$name\" is already mapped!"
		return 0
	fi

	# use current directory and folder name if no args
	if [ -n "$1" ]; then # path, use folder name
		fullpath="$(realpath "$1")"
		if [ -n "$2" ]; then # path, name
			name="$(basename "$2")"
		fi
	fi

	home="$(jq -r '.projects.defaults.home' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
	base="$(jq -r '.projects.defaults.base' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
	team="$(jq -r '.projects.defaults.team' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
	root="$home/$base/teams/$team/"
	org="$(cut -d'/' -f1 <<< "${fullpath/$root/}")"
	root+="$org/"
	path=${fullpath/$root/}

	echo "Mapping $fullpath to \"$name\""
	jq -e --arg name "$name" --arg org "$org" --arg path "$path" "$query" "$ATP_PROJECT_CONFIG_FILE_REALPATH" > "$PROJECT_CONFIG_FILE_REALPATH.tmp"

	atp_project_update

	return "$?"
}

atp_project_delete() {
	echo "Deleting \"$1\""
	jq -e --arg name "$1" 'del(.projects.projects[$name])' "$ATP_PROJECT_CONFIG_FILE_REALPATH" > "$PROJECT_CONFIG_FILE_REALPATH.tmp"

	atp_project_update

	return "$?"
}

atp_project_go() {
	config_has_project="$(jq -r --arg name "$1" '.projects.projects | has($name)' "$ATP_PROJECT_CONFIG_FILE_REALPATH")"

	if [ "$config_has_project" != "true" ]; then
		echo "Project \"$1\" is not mapped."
		return 1
	else
		cmd="$(jq -r --arg name "$1" "$ATP_PROJECT_QUERY" "$ATP_PROJECT_CONFIG_FILE_REALPATH")"
		$cmd
		return 0
	fi
}

atp_project_make_config() {
	echo "projects.json file does not exist"
	echo "creating file at $ATP_PROJECT_CONFIG_FILE_REALPATH"

	echo "Please fill out some default values for the config:"
	read -pr "Company Name (company): " company
	read -pr "Team Name (team): " team
	read -pr "Org Name (org): " org

	mkdir -p "$ATP_PROJECT_CONFIG_PARENT_DIR_PATH" && \
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
		}' > "$ATP_PROJECT_CONFIG_FILE_REALPATH"
}

# App entry point
atp_project_do() {
	ATP_PROJECT_CONFIG_PARENT_DIR_PATH="$(realpath "$HOME/.private")"
	ATP_PROJECT_CONFIG_FILE_REALPATH="$(realpath "$ATP_PROJECT_CONFIG_PARENT_DIR_PATH/projects.json")"

	ATP_PROJECT_USAGE="Usage:
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

	# shellcheck disable=SC2016
	ATP_PROJECT_QUERY='.projects.defaults * .projects.projects[$name]
	 | "cd \(.home)/\(.base)/teams/\(.team)/\(.org)/\(.path)/"'

	if ! [ -x "$(command -v jq)" ]; then # https://stackoverflow.com/a/26759734/771948
		# shellcheck disable=SC2016
		echo 'jq is not installed. Run `brew install jq`.' >&2
		return 1
	fi

	[ ! -f "$ATP_PROJECT_CONFIG_FILE_REALPATH" ] && atp_project_make_config

	case "$1" in
	"-l") # list names of mapped projects
		[ $# -gt 1 ] && echo "$ATP_PROJECT_USAGE" && return 0
		atp_project_list
		;;
	"-a") # add to map
		[ $# -gt 3 ] || ! [ -d "$2" ] && echo "$ATP_PROJECT_USAGE" && return 0
		atp_project_add "$2" "$3"
		;;
	"-d") # delete from map
		[ $# -ne 2 ] || [ -z "$2" ] && echo "$ATP_PROJECT_USAGE" && return 0
		atp_project_delete "$2"
		;;
	*) # open the project directory
		[ -z "$1" ] && echo "$ATP_PROJECT_USAGE" && return 0
		atp_project_go "$1"
		;;
	esac

	return "$?"
}

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || atp_project_do "$@"
