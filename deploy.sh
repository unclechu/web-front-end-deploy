#!/bin/bash
#
# Version: r2
# Author: Viacheslav Lotsmanov
# License: GNU/GPLv3 (https://github.com/unclechu/web-front-end-deploy/blob/master/LICENSE)
#

PARENT_DEPLOY_SCRIPT=1

[ -n "$WD" ] && cd "$WD" && unset WD

clr_info='\e[0;36m'
clr_ok='\e[0;32m'
clr_ask='\e[0;34m'
clr_err='\e[1;31m'
clr_end='\e[0m'

# private
# args:
#   $1 - additional flags for 'echo'
#   $2 - write to (1 - stdout, 2 - stderr)
#   $3 - color
#   $4 - suffix (no color)
#   $@ - info text
function _info_pattern {
	color="$clr_info"

	flags=$1
	shift
	write_to=$1
	shift
	color=$1
	shift
	suffix=$1
	shift

	echo -e $flags "${color}${@}${clr_end}${suffix}" 1>&$write_to
}

# simple info

function info {
	_info_pattern "" 1 "$clr_info" " ... " "$@"
}

function info_ok {
	_info_pattern "" 1 "$clr_ok" " ... " "$@"
}

function info_err {
	_info_pattern "" 2 "$clr_err" " ... " "$@"
}

# inline info

function info_inline {
	_info_pattern "-n" 1 "$clr_info" " ... " "$@"
}

function info_ok_inline {
	_info_pattern "-n" 1 "$clr_ok" " ... " "$@"
}

function info_err_inline {
	_info_pattern "-n" 2 "$clr_err" " ... " "$@"
}

# info clean

function info_clean {
	_info_pattern "" 1 "$clr_info" "" "$@"
}

function info_ok_clean {
	_info_pattern "" 1 "$clr_ok" "" "$@"
}

function info_err_clean {
	_info_pattern "" 2 "$clr_err" "" "$@"
}

# info inline clean

function info_inline_clean {
	_info_pattern "-n" 1 "$clr_info" "" "$@"
}

function info_inline_ok_clean {
	_info_pattern "-n" 1 "$clr_ok" "" "$@"
}

function info_inline_err_clean {
	_info_pattern "-n" 2 "$clr_err" "" "$@"
}

# run wrappers

function run_inline_answer_silent {
	errlog=$("${@}" 2>&1)
	if [ $? -ne 0 ]; then
		err 1
		info_clean "Command: '${@}'"
		info_err_clean "Error log: '${errlog}'"
		exit 1
	fi
}

function run_inline_answer {
	run_inline_answer_silent "${@}"
	ok
}

# statuses

function ok {
	echo -e "${clr_ok}[ OK ]${clr_end}"
	return 0
}

function err {
	echo -e "${clr_err}[ ERR ]${clr_end}" 1>&2
	[ -z $1 ] && exit 1
}

function ask {
	echo -en "${clr_ask}${@}${clr_end} [Y/n] "
	read answer

	if echo "$answer" | grep -i '^y\(es\)\?$' &>/dev/null; then
		return 0
	elif echo "$answer" | grep -i '^n\(o\)\?$' &>/dev/null; then
		return 1
	else
		info_err_clean "Incorrect answer!"
		exit 1
	fi
}

function please_type {
	echo -en "${clr_ask}${@}${clr_end}: "
}

# deploy tasks

if [ -n "$YOUR_SUBJECT" ]; then
	source "$YOUR_SUBJECT"
	unset YOUR_SUBJECT
else
	tasks=$(find -L ./_deploy -maxdepth 1 -type f | grep '\.sh$' | sort | tr '\n' ':')

	while [ -n "$tasks" ]; do
		task="${tasks#*:}"
		task="${tasks:0:$[ ${#tasks} - ${#task} - 1 ]}"

		info "Started task \"$task\""
		source "$task"
		info_inline "Task \"$task\" successfully finished" && ok

		tasks="${tasks#*:}"
	done
fi

# finishing of deploying

if [ -z "$YOUR_SUBJECT" ]; then
	info_ok_clean "This repository is successfully deployed!"
fi

exit 0
