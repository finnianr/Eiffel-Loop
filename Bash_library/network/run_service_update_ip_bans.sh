#!/usr/bin/env bash

# MASTER COPY of this script is in: Eiffel-Loop/Bash_library

# Description: 
#	Monitors IP tables importable rules written to /var/local/<$domain_name>/iptable-new.rules
#	by EL_404_INTERCEPT_SERVLET.

# author: "Finnian Reilly"
# copyright: "Copyright (c) 2011-2025 Finnian Reilly"
# contact: "finnian at eiffel hyphen loop dot com"

# license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"

# date: "2025-03-04"

# Routines

echo_waiting (){
	echo "Waiting for change to: $rules_path"
}

append_rules (){
	exec {lock_fd}>$dir_path/iptables.lock || exit 1
	flock --exclusive "$lock_fd"

	iptables-restore --noflush < $1
	cat $1
	echo

	flock --unlock "$lock_fd"
}

set_rules_path (){
	rules_path=$dir_path/iptable-$1.rules
}

# Script begin

domain_name=$1
user=$2
name=${domain_name%%.*}

dir_path=/var/local/$domain_name
description="Intruder banning service"

if [[ ! -d "$dir_path" ]]; then
	mkdir $dir_path
fi

# Check if live host or dev machine
if [[ $(hostname) != $domain_name ]]; then
	is_dev_machine=true

	echo Service is in testing mode on development machine

	# start fresh on dev machine
	if [[ -e $rules_path ]]; then
		rm $rules_path
	fi
else
	unset is_dev_machine
fi

for protocol in HTTP SSH SMTP; do
	set_rules_path $protocol
#	If flushing named chain fails then create it
	if ! iptables -F banned-$protocol 2> /dev/null; then
		echo Creating chain banned-$protocol
		iptables -N banned-$protocol
	else
		echo Flushed chain banned-$protocol
	fi
	if [[ -e "$rules_path" ]]; then
		echo Restoring rules from $rules_path
		iptables-restore --noflush < $rules_path
	fi
done

set_rules_path new

# make sure iptables-new.rules writeable by www-data group (EL_404_INTERCEPT_SERVLET.update_rules)
if [[ ! -e "$rules_path" ]]; then
	touch $rules_path
	chown $user:www-data $rules_path
	chmod 644 $rules_path
fi

# make sure updateable rules file exists
touch $rules_path

echo_waiting

while inotifywait -q -e close_write $rules_path 1>/dev/null; do
	if [[ -v is_dev_machine ]]; then
		echo SKIP\: append_rules $rules_path
		cat $rules_path
		echo
	else
		echo append_rules $rules_path
		append_rules $rules_path
	fi
	echo_waiting
done
