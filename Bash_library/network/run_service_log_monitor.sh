#!/usr/bin/env bash

# MASTER COPY of this script is in: Eiffel-Loop/Bash_library

# Description: 
#	Notify EL_404_INTERCEPT_SERVLET if log file: /var/log/$1.log

# author: "Finnian Reilly"
# copyright: "Copyright (c) 2011-2025 Finnian Reilly"
# contact: "finnian at eiffel hyphen loop dot com"

# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

domain_name=$1
log_name=$2
name=${domain_name%%.*}
description="$log_name.log notification service"

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

inotifywait -m -e modify /var/log/$log_name.log | while read -r log_path event; do
	echo "$log_path was modified"
	# Wait 1/2 second until batch of lines added
	sleep 0.5
	tail -n 5 $log_path
#	Notify EL_404_INTERCEPT_SERVLET to update firewall rules
	curl $http_options://localhost/${log_name}_log_modified > /dev/null
	echo Notified servlet
done
