#!/bin/bash
#
# Version: r1
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info_inline "Creating symbolic link to front-end-gulp-pattern cli"
rm ./front-end-gulp &>/dev/null

target='./node_modules/.bin/front-end-gulp'

if [ ! -f "$target" ] || [ ! -x "$target" ]; then
	err 1
	info_err_clean "target file '$target' not found";
	exit 1
fi

if ln -s "$target" ./front-end-gulp &>/dev/null; then ok; else err; fi
