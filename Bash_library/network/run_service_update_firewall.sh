#!/usr/bin/env bash

# MASTER COPY of this script is in: Eiffel-Loop/Bash_library

# Description: 
#	Install new firewall rules in /var/local
# HACKER_INTERCEPT_SERVICE_APP

# author: "Finnian Reilly"
# copyright: "Copyright (c) 2011-2025 Finnian Reilly"
# contact: "finnian at eiffel hyphen loop dot com"

# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"


domain_name=$1
name=${domain_name%%.*}

dir_path=/var/local/$domain_name
rules_path=$dir_path/user.rules
lock_path=$dir_path/rules.lock
last_digest=""

set_digest (){
	exec {lock_fd}>$lock_path || exit 1
	flock --exclusive "$lock_fd"

	local output=$(md5sum $rules_path)
	digest=${output%% *}
	flock --unlock "$lock_fd"
}

install_rules (){
	exec {lock_fd}>$lock_path || exit 1
	flock --exclusive "$lock_fd"
	cp $rules_path /lib/ufw
	flock --unlock "$lock_fd"
}

if [[ ! -d "$dir_path" ]]; then
	mkdir dir_path
fi

if [[ ! -e "$rules_path" ]]; then
	touch "$rules_path"
fi

# Dry run on dev machine
if [[ "$(hostname)" != "$domain_name" ]]; then
	dry_run=true
else
	unset dry_run
fi

echo "Listening for changes to: $rules_path"

while inotifywait -q -e close_write $rules_path 1>/dev/null; do
	set_digest
	while "$digest" != "$last_digest"; do
		echo Updating firewall rules
		# if not a dry run on dev machine
		if [[ -v dry_run ]]; then
			install_rules;	ufw reload
		else
			echo ufw reload
		fi
		last_digest="$digest"
		set_digest
	done
done
