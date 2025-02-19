#!/usr/bin/env bash

# MASTER COPY of this script is in: Eiffel-Loop/Bash_library

# Description: 
#	Monitors UFW firewall rules written to /var/local/<$domain_name>/user.rules
#	by EL_404_INTERCEPT_SERVLET. Each time the rules change the new rules
#	are installed in /lib/ufw and the ufw service is reloaded

# author: "Finnian Reilly"
# copyright: "Copyright (c) 2011-2025 Finnian Reilly"
# contact: "finnian at eiffel hyphen loop dot com"

# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

echo_waiting (){
	echo "Waiting for change to: $rules_path"
}

install_rules (){
	exec {lock_fd}>$lock_path || exit 1
	flock --exclusive "$lock_fd"

	cp $rules_path /lib/ufw

	flock --unlock "$lock_fd"
}

set_digest (){
	exec {lock_fd}>$lock_path || exit 1
	flock --exclusive "$lock_fd"

	local output=$(md5sum $rules_path)
	digest=${output%% *}

	flock --unlock "$lock_fd"
}

# SCRIPT START

domain_name=$1
user=$2
name=${domain_name%%.*}

dir_path=/var/local/$domain_name
rules_path=$dir_path/user.rules
lock_path=$rules_path.lock
last_digest=""

if [[ ! -d "$dir_path" ]]; then
	mkdir $dir_path
fi

if [[ ! -e "$rules_path" ]]; then
	echo Copying "/lib/ufw/user.rules"
	cp /lib/ufw/user.rules $dir_path
	chown $user:www-data $rules_path
	chmod 644 $rules_path
fi

# Dry run on dev machine
if [[ "$(hostname)" != "$domain_name" ]]; then
	dry_run=true
else
	unset dry_run
fi

echo_waiting

while inotifywait -q -e close_write $rules_path 1>/dev/null; do
	set_digest
	while [[ "$digest" != "$last_digest" ]]; do
		if [[ -v dry_run ]]; then
		#	Is dev machine
			echo SKIP\: install_rules\; ufw reload
		else
			echo install_rules\; ufw reload
			install_rules; ufw reload
			echo reloaded
		fi
		last_digest="$digest"
		set_digest
		printf 'Digest: %s\n' "$digest"
		printf 'Last  : %s\n' "$last_digest"
	done
	echo_waiting
done
