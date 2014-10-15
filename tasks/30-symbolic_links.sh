#!/bin/bash
#
# Creating absolute symbolic links to master site
#
# Put serapator "#SYMBOLIC_LINKS_START#" to ".gitignore"
# Will be created symbolic links for all paths that after separator in .gitignore
#
# Put file ".source_of_symbolic_links" to site root for ignoring this action for master site
#
# Version: r4
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info "Creating symbolic links"
if [ -f '.source_of_symbolic_links' ]; then
	info "Is source of symbolic links [ SKIPPED ]"
elif ask "Create symbolic links to master project?"; then
	please_type "Please enter the absolute path to master project"
	read master_path

	list=$(cat .gitignore)
	count=$(echo "$list" | wc -l)
	symlinks_flag=0
	for (( i="$count"; i>=0; i-- )) do
		line=$(echo "$list" | tail -n $i | head -n 1)

		if [ "$line" == "#SYMBOLIC_LINKS_START#" ]; then
			symlinks_flag=1
		fi

		# cut off comments
		line=$(echo "$line" | sed -e 's/#.*$//g')

		if [ $symlinks_flag -eq 1 ] && [ "${line}x" != "x" ]; then
			if [ -h "$line" ] || ! test -e "$line"; then
				if [ -h "$line" ]; then
					info "rm \"$line\""
					rm "$line"
				fi

				abs_target_path="${master_path}/${line}"
				if [ -f "$abs_target_path" ] || [ -d "$abs_target_path" ] || [ -L "$abs_target_path" ]; then
					info "ln -s \"$abs_target_path\" \"$line\""
					ln -s "$abs_target_path" "$line"
				else
					info_err_clean "[ SKIPPED ] \"$abs_target_path\" is not exists"
				fi
			else
				info_err_clean "[ SKIPPED ] \"$line\" is not symbolic link"
			fi
		fi
	done
else
	info "[ SKIPPED ]"
fi
