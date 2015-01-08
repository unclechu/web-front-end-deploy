#!/bin/bash
#
# Version: r2
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info_inline "Creating symbolic link to gulp-cli"
rm ./gulp &>/dev/null

target='./node_modules/.bin/gulp'

if [ ! -f "$target" ] || [ ! -x "$target" ]; then
	err 1
	info_err_clean "target file '$target' not found";
	exit 1
fi

if ln -s "$target" ./gulp &>/dev/null; then ok; else err; fi
