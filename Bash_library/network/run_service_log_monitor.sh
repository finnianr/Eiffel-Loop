#!/usr/bin/env bash

# MASTER COPY of this script is in: Eiffel-Loop/Bash_library

# Description: 
#	Notify EL_404_INTERCEPT_SERVLET each time the log file "/var/log/$2.log" changes
#	and make last 10 lines of log file available for attack analysis in /var/local/$1

#	ARGUMENTS:
#		$1 domain name of website
#		$2 base name of log. Eg. "auth"
#		$3 value of $USER variable in calling process

# author: "Finnian Reilly"
# copyright: "Copyright (c) 2011-2025 Finnian Reilly"
# contact: "finnian at eiffel hyphen loop dot com"

# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

echo_waiting (){
	echo "Waiting for change to: $log_path"
}

copy_log_tail (){
#	copy last 10 lines and get ownership for normal user
	tail -n 10 $log_path > $tail_path
	chown $user:www-data $tail_path
	chmod 644 $tail_path
}

set_tail_digest (){
	local output=$(md5sum $tail_path)
	tail_digest=${output%% *}
}

# SCRIPT START

domain_name=$1; log_name=$2; user=$3
name=${domain_name%%.*}
description="$log_name.log notification service"
log_path=/var/log/$log_name.log
tail_path=/var/local/$domain_name/tail-$log_name.log
last_tail_digest=""

# Check if live host or dev machine
if [[ $(hostname) != $domain_name ]]; then
	is_dev_machine=true
	echo Service is in testing mode on development machine
	http_options=http
else
	unset is_dev_machine
	http_options="--insecure https"
fi

echo Monitoring /var/log/$log_name.log

echo_waiting

inotifywait -m -e modify $log_path | while read -r log_path event; do
	copy_log_tail; set_tail_digest
#	while log tail keeps changing
	while [[ $tail_digest != $last_tail_digest ]]; do
		echo "$log_path was modified"
		tail -n 5 $tail_path
	#	Notify EL_404_INTERCEPT_SERVLET to update IP table rules
		curl $http_options://localhost/${log_name}_log_modified > /dev/null
		echo Notified 404 intercept servlet

		last_tail_digest="$tail_digest"
		copy_log_tail; set_tail_digest
		printf 'Digest: %s\n' "$tail_digest"
		printf 'Last  : %s\n' "$last_tail_digest"
	done
	echo_waiting
done
