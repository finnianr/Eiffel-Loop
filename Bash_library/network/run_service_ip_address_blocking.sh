#!/usr/bin/env bash

# MASTER COPY of this script is in: Eiffel-Loop/Bash_library

# Description: 
#	Notifications received from service HACKER_INTERCEPT_SERVICE_APP

# author: "Finnian Reilly"
# copyright: "Copyright (c) 2011-2025 Finnian Reilly"
# contact: "finnian at eiffel hyphen loop dot com"

# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"


domain_name=$1
name=${domain_name%%.*}

dir_path=/var/local/$domain_name
txt_path=$dir_path/block-ip.txt
lock_path=$dir_path/block-ip.lock

if [[ ! -d "$dir_path" ]]; then
	mkdir dir_path
fi

if [[ ! -e "$txt_path" ]]; then
	touch "$txt_path"
fi

# Dry run on dev machine
if [[ "$(hostname)" != "$domain_name" ]]; then
	dry_run="True"
else
	unset dry_run
fi

echo "Listening for changes to: $txt_path"

while inotifywait -q -e close_write $txt_path 1>/dev/null; do

	exec {lock_fd}>$lock_path || exit 1
	flock --exclusive "$lock_fd"

	cat $txt_path

	while read line; do
		# Use IFS (Internal Field Separator) to split the line into a parts array
		IFS=':' read -ra part <<< "$line"
		command=${part[0]}; ip=${part[1]}; port=${part[2]}

		if [[ "$ip" != "0.0.0.0" ]]; then
			if [[ "$command" == "block" ]]; then
				cmd="ufw insert 1 deny from $ip to any port $port"
			else
				cmd="ufw delete deny from $ip to any port $port"
			fi
			echo $cmd
			# if not a dry run on dev machine
			if [[ ! -v dry_run ]]; then
				# log command
				echo $(date) $cmd >> /var/log/ip_address_blocking.log
				# execute command
				$cmd
			fi
		fi
	done < $txt_path
	 
	flock --unlock "$lock_fd"
done
