#!/bin/bash
#
# Version: r1
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#
if [ -z "$PARENT_DEPLOY_SCRIPT" ]; then YOUR_SUBJECT="./_deploy/$(basename "$0")" WD="$(dirname "$0")/../" ../deploy.sh; exit "$?"; fi

info_inline "Creating symbolic link to grunt-cli"
rm ./grunt &>/dev/null
if ln -s ./node_modules/.bin/grunt ./grunt &>/dev/null; then ok; else err; fi
