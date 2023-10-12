note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
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

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_IP_ADDRESS

	EL_SHARED_IP_ADDRESS_GEOLOCATION

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_HACKER_INTERCEPT_SERVICE)
		do
			make_servlet (a_service)
			create date.make_now

			create day_list.make (a_service.config.block_life_span + 1)
			block_ip_path := a_service.config.server_socket_path.parent + "block-ip.txt"
			create mutex.make (block_ip_path.with_new_extension ("lock"))

			if not block_ip_path.exists then
				File.write_text (block_ip_path, IP_address.to_string (0))
			end
			filter_table := a_service.config.filter_table
			create location_status_table.make (70, agent new_location_status)
		end

feature {NONE} -- Basic operations

	serve
		local
			ip_number: NATURAL; location_status: like new_location_status
		do
			log.enter_no_header ("serve")
			if request.remote_address_32 = Local_host_address then
				ip_number := Test_ip_number
			else
				ip_number := request.remote_address_32
			end
			location_status := location_status_table.item (ip_number)
			log.put_labeled_string (IP_address.to_string (ip_number), location_status.location)
			if location_status.is_blocked then
				log.put_line (" (blocked)")
				location_status.is_blocked := False -- Try again to set firewall rule

			elseif filter_table.is_hacker_probe (request.relative_path_info.as_lower) then
				log.put_line (" (blocking)")
				block (ip_number)
				location_status.is_blocked := True
			else
				log.put_new_line
			end
			response.send_error (Http_status.not_found, once "File not found", Doc_type_plain_latin_1)

			update_day_list
			log.exit_no_trailer
		end

feature {NONE} -- Implementation

	allow (redeemed_ip_list: ARRAYED_LIST [NATURAL])
		local
			command_line_list: EL_STRING_8_LIST
		do
			create command_line_list.make (redeemed_ip_list.count)
			across redeemed_ip_list as list loop
				command_line_list.extend (IP_address.to_string (list.item) + once ":allow")
			end
			mutex.try_locking_until (50)
			File.write_text (block_ip_path, command_line_list.joined_lines)
			mutex.unlock
		end

	block (ip_number: NATURAL)
		do
			mutex.try_locking_until (50)
			File.write_text (block_ip_path, IP_address.to_string (ip_number) + once ":block")
			mutex.unlock
		end

	new_location_status (ip: NATURAL): like location_status_table.item
		do
			Result := [IP_location_table.item (ip), day_list.last, False]
		end

	update_day_list
		local
			first_date: INTEGER; redeemed_ip_list: ARRAYED_LIST [NATURAL]
		do
			date.make_now
			if date.ordered_compact_date > day_list.last then
				day_list.extend (date.ordered_compact_date)
			end
			if day_list.full then
			-- allow previously blocked ip address > config.block_life_span
				first_date := day_list.first
				day_list.remove_head (1)
				create redeemed_ip_list.make (location_status_table.count // day_list.count)
				across location_status_table as table loop
					if table.item.compact_date = first_date then
						redeemed_ip_list.extend (table.key)
					end
				end
				redeemed_ip_list.do_all (agent location_status_table.remove)
			end
		end

feature {NONE} -- Implementation: attributes

	block_ip_path: FILE_PATH

	mutex: EL_FILE_MUTEX
		-- mutex for writing to `block_ip_path'

	filter_table: EL_URL_FILTER_TABLE

	location_status_table: EL_CACHE_TABLE [TUPLE [location: ZSTRING; compact_date: INTEGER; is_blocked: BOOLEAN], NATURAL]

	date: DATE

	day_list: EL_ARRAYED_LIST [INTEGER]

feature {NONE} -- Constants

	Local_host_address: NATURAL = 0x7F_00_00_01

feature {NONE} -- String constants

	Test_ip_number: NATURAL
		-- Poland, Łódź Voivodeship"
		once
			Result := IP_address.to_number ("91.196.50.33")
		end
note
	notes: "[
		Example Bash script notified by **block** routine that adds firewall rule for HTTP and HTTPS ports

			dir_path=/var/local/myching.software
			txt_path=$dir_path/block-ip.txt
			lock_path=$dir_path/block-ip.lock

			echo Listening for changes to: $txt_path

			while inotifywait -q -e close_write $txt_path; do

				exec {lock_fd}>$lock_path || exit 1
				flock --exclusive "$lock_fd"

				while read line; do
					ip=${line%%\:*}
					if [[ "$ip" != "0.0.0.0" ]]
						for port in 80 443; do
							if [[ "${line#*\:}" == "block" ]]
							then
								echo sudo ufw insert 1 deny from $ip to any port $port
							else
								echo sudo ufw delete deny from $ip to any port $port
							fi
						done
					fi
				done <$txt_path

				flock -u "$lock_fd"
			done

		This script must be running as root
	]"

end
