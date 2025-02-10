#!/usr/bin/env bash

# notifications received from service HACKER_INTERCEPT_SERVICE_APP
# MASTER COPY is in Eiffel-Loop/Bash_library

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

echo "Listening for changes to: $txt_path"

while inotifywait -q -e close_write $txt_path 1>/dev/null; do

	exec {lock_fd}>$lock_path || exit 1
	flock --exclusive "$lock_fd"

	cat $txt_path

	while read line; do
		# Use IFS (Internal Field Separator) to split the line into a parts array
		IFS=':' read -ra part <<< "$line"
		command=${part[0]}; ip=${part[1]}; port=${part[2]}

		if [[ "$ip" != "0.0.0.0" ]]
		then
			if [[ "$command" == "block" ]]
			then
				cmd="ufw insert 1 deny from $ip to any port $port"
			else
				cmd="ufw delete deny from $ip to any port $port"
			fi
			echo $cmd
			if [[ "$2" != "-test" ]]
			then
				# log command
				echo $cmd >> /var/log/ip_address_blocking.log
				# execute command
				$cmd
			fi
		fi
	done < $txt_path
	 
	flock --unlock "$lock_fd"
done
