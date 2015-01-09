#!/bin/bash
#
# Version: r1
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info "Starting default front-end-gulp-pattern tasks (with production flag)"
if ./front-end-gulp --production; then
	info_inline "Default front-end-gulp-pattern tasks status:"; ok;
else err; fi
