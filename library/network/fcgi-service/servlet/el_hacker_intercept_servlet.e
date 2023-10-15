note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address. The ban is temporary and lasts for
		the number of days specified by {[$source EL_HACKER_INTERCEPT_CONFIG]}.ban_rule_duration.
	]"
	notes: "See end of class"
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-02-14 18:09:30 GMT (Tuesday 14th February 2023)"
	revision: "15"

class
	EL_HACKER_INTERCEPT_SERVLET

inherit
	FCGI_HTTP_SERVLET
		rename
			make as make_servlet
		end

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_IP_ADDRESS; EL_MODULE_REUSEABLE

	EL_STRING_8_CONSTANTS

	EL_SHARED_IP_ADDRESS_GEOLOCATION

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_HACKER_INTERCEPT_SERVICE)
		do
			make_servlet (a_service)
			create date.make_now

			create day_list.make (a_service.config.ban_rule_duration + 1)
			day_list.extend (date.ordered_compact_date)

			block_ip_path := a_service.config.server_socket_path.parent + "block-ip.txt"
			create mutex.make (block_ip_path.with_new_extension ("lock"))

			if not block_ip_path.exists then
				File.write_text (block_ip_path, IP_address.to_string (0) + Line_ending.block)
			end
			filter_table := a_service.config.filter_table
			create firewall_status_table.make (70, agent new_firewall_status)
		end

feature {NONE} -- Basic operations

	serve
		local
			ip_number: NATURAL; firewall_status: like new_firewall_status
			ip_4_address: STRING
		do
			log.enter_no_header ("serve")

			ip_number := request_remote_address_32
			ip_4_address := IP_address.to_string (ip_number)
			firewall_status := firewall_status_table.item (ip_number)
			if firewall_status.is_blocked then
				log.put_labeled_string (ip_4_address, "is blocked")
				firewall_status.is_blocked := False -- Try again to set firewall rule

			elseif filter_table.is_hacker_probe (request.relative_path_info.as_lower) then
				log.put_labeled_string ("Blocking", ip_4_address)
				block (ip_4_address)
				firewall_status.is_blocked := True
			end
			log.put_new_line
			response.send_error (Http_status.not_found, once "File not found", Doc_type_plain_latin_1)

			update_day_list

		-- While geo-location is being looked up for address, (which can take a second or two)
		-- a firewall rule is being added in time for next intrusion from same address

			log.put_labeled_string ("Located", IP_location_table.item (ip_number))
			log.put_new_line

			log.exit_no_trailer
		end

feature {NONE} -- Implementation

	allow (redeemed_ip_list: ARRAYED_LIST [NATURAL])
		do
			across Reuseable.string_8 as reuse loop
				if attached reuse.item as command_lines then
					across redeemed_ip_list as list loop
						if attached Ip_address.to_string (list.item) as ip_4_address then
							lio.put_labeled_string ("Allowing", ip_4_address)
							lio.put_new_line
							command_lines.append (ip_4_address + Line_ending.allow)
						end
					end
					mutex.try_locking_until (50)
					File.write_text (block_ip_path, command_lines)
					mutex.unlock
				end
			end
		end

	block (ip_4_address: STRING)
		do
			mutex.try_locking_until (50)
		-- New line at end necessary to for Bash "while read line; do" loop to work
			File.write_text (block_ip_path, ip_4_address + Line_ending.block)
			mutex.unlock
		end

	day_now: INTEGER
		do
			date.make_now
			Result := date.ordered_compact_date
		end

	new_firewall_status (ip: NATURAL): TUPLE [compact_date: INTEGER; is_blocked: BOOLEAN]
		do
			Result := [day_list.last, False]
		end

	request_remote_address_32: NATURAL
		do
			Result := request.remote_address_32
		end

	update_day_list
		local
			first_date, l_day_now: INTEGER; redeemed_ip_list: ARRAYED_LIST [NATURAL]
		do
			l_day_now := day_now
			if l_day_now > day_list.last then
				day_list.extend (l_day_now)
			end
			if day_list.full then
			-- allow previously blocked ip address > config.ban_rule_duration
				first_date := day_list.first
				day_list.remove_head (1)
				create redeemed_ip_list.make (firewall_status_table.count // day_list.count)
				across firewall_status_table as table loop
					if table.item.compact_date = first_date then
						redeemed_ip_list.extend (table.key)
					end
				end
				redeemed_ip_list.do_all (agent firewall_status_table.remove)
				allow (redeemed_ip_list)
			end
		end

feature {NONE} -- Implementation: attributes

	block_ip_path: FILE_PATH

	date: DATE

	day_list: EL_ARRAYED_LIST [INTEGER]

	filter_table: EL_URL_FILTER_TABLE

	firewall_status_table: EL_CACHE_TABLE [like new_firewall_status, NATURAL]

	mutex: EL_FILE_MUTEX
		-- mutex for writing to `block_ip_path'

feature {NONE} -- Constants

	Line_ending: TUPLE [allow, block: STRING]
		-- commands with new line character
		once
			Result := [":allow%N", ":block%N"]
		end

note
	notes: "[
		This servlet communicates with a Bash script like the following to add firewall rules
		for HTTP and HTTPS ports. Use this script as a guideline. The script must be running as root
		to call ufw command.

			#!/usr/bin/env bash

			dir_path=/var/local/myching.software
			txt_path=$dir_path/block-ip.txt
			lock_path=$dir_path/block-ip.lock

			echo "Listening for changes to: $txt_path"

			while inotifywait -q -e close_write $txt_path 1>/dev/null; do

				exec {lock_fd}>$lock_path || exit 1
				flock --exclusive "$lock_fd"

				cat $txt_path

				while read line; do
					# remove IP from start
					ip=${line%%\:*}
					if [[ "$ip" != "0.0.0.0" ]]
					then
						if [[ "${line#*\:}" == "block" ]]
						then
							cmd="ufw insert 1 deny from $ip to any port $port"
						else
							cmd="ufw delete deny from $ip to any port $port"
						fi
						echo $cmd
						# do command
						$cmd
					fi
				done < $txt_path

				flock --unlock "$lock_fd"
			done
	]"

end
