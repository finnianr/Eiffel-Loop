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
	date: "2023-10-29 17:44:53 GMT (Sunday 29th October 2023)"
	revision: "22"

class
	EL_HACKER_INTERCEPT_SERVLET

inherit
	FCGI_HTTP_SERVLET
		rename
			make as make_servlet
		end

	EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM
	EL_MODULE_IP_ADDRESS

	EL_STRING_8_CONSTANTS

	EL_SHARED_IP_ADDRESS_GEOLOCATION; EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_HACKER_INTERCEPT_SERVICE)
		do
			make_servlet (a_service)
			create date.make_now
			create rule_buffer.make (50)

			monitored_logs := <<
				create {EL_TODAYS_AUTHORIZATION_LOG}.make,
				create {EL_TODAYS_SENDMAIL_LOG}.make
			>>

			create day_list.make (a_service.config.ban_rule_duration + 1)
			day_list.extend (date.ordered_compact_date)

			block_ip_path := a_service.config.server_socket_path.parent + "block-ip.txt"
			create file_mutex.make (block_ip_path.with_new_extension ("lock"))

			if not block_ip_path.exists then
				File.write_text (block_ip_path, "block:0.0.0.0:80%N") -- ignored by script
			end
			filter_table := a_service.config.filter_table
			if attached a_service.Legacy_firewall_status_data_path as path and then path.exists then
				load_legacy_status_table (path)
				File_system.remove_file (path)

			elseif attached a_service.Firewall_status_data_path as path and then path.exists then
				load_status_table (path)
			else
				create firewall_status_table.make (70)
			end
			if firewall_status_table.count > 0 then
			-- Restore `day_list' state
				if attached Firewall_status as status then
					across firewall_status_table as table loop
						status.set_from_compact (table.item)
						if day_list.is_empty then
							day_list.extend (status.compact_date)

						elseif status.compact_date > day_list.last then
							day_list.extend (status.compact_date)
							if day_list.full then
								day_list.remove_head (1)
							end
						end
					end
				end
			end
		end

feature -- Access

	firewall_status_table: HASH_TABLE [NATURAL_64, NATURAL]
		-- map IP number to compact form of `EL_FIREWALL_STATUS' data

feature -- Basic operations

	serve
		local
			ip_number: NATURAL
		do
			log.enter_no_header ("serve")

			check_logs

			ip_number := request_remote_address_32
			check_ip_address (ip_number, Service_port.HTTP)

			response.send_error (Http_status.not_found, once "File not found", Doc_type_plain_latin_1)

			update_day_list

			update_firewall

		-- While geo-location is being looked up for address, (which can take a second or two)
		-- a firewall rule is being added in time for next intrusion from same address

			log.put_labeled_string ("Located", IP_location_table.item (ip_number))
			log.put_new_line

			log.exit_no_trailer
		end

	store_status_table (path: FILE_PATH)
		local
			status_list: ECD_STORABLE_ARRAYED_LIST [EL_ADDRESS_FIREWALL_STATUS]
		do
			log.put_labeled_substitution ("Storing", "%S entries", [firewall_status_table.count])
			log.put_new_line
			create status_list.make (firewall_status_table.count)
			across firewall_status_table as table loop
				status_list.extend (create {EL_ADDRESS_FIREWALL_STATUS}.make (table.item, table.key))
			end
			status_list.store_as (path)
		end

feature {NONE} -- Implementation

	allow (redeemed_ip_list: like new_redeemed_ip_list)
		do
			if attached redeemed_ip_list as list then
				from list.start until list.after loop
					if attached Ip_address.to_string (list.item_key) as ip_4_address then
						lio.put_labeled_string ("Allowing", ip_4_address)
						lio.put_new_line
						list.item_value.do_all (agent put_rule (Command.allow, list.item_key, ?))
					end
					list.forth
				end
			end
		end

	check_ip_address (ip_number: NATURAL; port: NATURAL_16)
		local
			put_block_rule: BOOLEAN
		do
			if attached Firewall_status as status then

				if firewall_status_table.has_key (ip_number) then
					status.set_from_compact (firewall_status_table.found_item)
				else
					status.wipe_out
					status.set_block (day_list.last, port)
					firewall_status_table.extend (status.compact_status, ip_number)
				end
				if port = Service_port.HTTP then
					if status.http_blocked then
						log_status (ip_number, port, True)
						status.allow (port) -- Try again to set firewall rule

					elseif filter_table.is_hacker_probe (request.relative_path_info.as_lower) then
						put_block_rule := True
					end
				else -- is mail spammer or ssh hacker
					if status.is_blocked (port) then
						log_status (ip_number, port, True)
					else
						put_block_rule := True
					end
				end
				if put_block_rule then
					log_status (ip_number, port, False)
					status.related_ports (port).do_all (agent put_rule (Command.block, ip_number, ?))
					status.set_block (day_list.last, port)
				end
			-- update table entry
				firewall_status_table [ip_number] := status.compact_status
				log.put_new_line
			end
		end

	check_logs
		-- check mail.log and auth.log for hacker intrusions
		do
			across monitored_logs as list loop
				list.item.update_hacker_ip_list
				if attached list.item.generating_type as type then
					across list.item.new_hacker_ip_list as address loop
						if type ~ {EL_TODAYS_SENDMAIL_LOG} then
							check_ip_address (address.item, Service_port.SMTP)

						elseif type ~ {EL_TODAYS_AUTHORIZATION_LOG} then
							check_ip_address (address.item, Service_port.SSH)
						end
					end
				end
			end
		end

	day_now: INTEGER
		do
			date.make_now
			Result := date.ordered_compact_date
		end

	load_status_table (path: FILE_PATH)
		local
			status_list: ECD_STORABLE_ARRAYED_LIST [EL_ADDRESS_FIREWALL_STATUS]
		do
			create status_list.make_from_file (path)
			create firewall_status_table.make (status_list.count)
			across status_list as list loop
				firewall_status_table.extend (list.item.compact_status, list.item.ip4_number)
			end
		end

	load_legacy_status_table (path: FILE_PATH)
		local
			data: RAW_FILE; ip_number: NATURAL; entry_count: INTEGER
			legacy_status: EL_LEGACY_FIREWALL_STATUS
		do
			create data.make_open_read (path)
			log.put_path_field ("Loading data %S", path.relative_path (Directory.App_data))
			log.put_new_line
			data.read_integer; entry_count := data.last_integer

			create firewall_status_table.make (entry_count)

			if attached Firewall_status as status then
				create legacy_status

				across 1 |..| entry_count as n until data.end_of_file loop
					data.read_natural_32; ip_number := data.last_natural

					data.read_natural_64 -- compact status `EL_LEGACY_FIREWALL_STATUS'
					legacy_status.set_from_compact (data.last_natural_64)
					status.wipe_out
					status.set_block (legacy_status.compact_date, legacy_status.port)
					if not legacy_status.is_blocked then
						status.allow (legacy_status.port)
					end

					firewall_status_table.extend (status.compact_status, ip_number)
				end
			end
			data.close
			log.put_integer_field ("Entries read", entry_count)
			log.put_new_line
		end

	log_status (ip_number: NATURAL; port: NATURAL_16; is_blocked: BOOLEAN)
		local
			ip_4_address: STRING
		do
			ip_4_address := IP_address.to_string (ip_number)
			if is_blocked then
				log.put_labeled_string ("Is blocked on port " + Service_port.name (port), ip_4_address)
			else
				log.put_labeled_string ("Blocking on port " + Service_port.name (port), ip_4_address)
			end
		end

	new_redeemed_ip_list (first_date: INTEGER): EL_ARRAYED_MAP_LIST [NATURAL, ARRAY [NATURAL_16]]
		-- map ip number to array of ports
		do
			create Result.make (firewall_status_table.count // day_list.count)
			across firewall_status_table as table loop
				Firewall_status.set_from_compact (table.item)
				if Firewall_status.compact_date = first_date then
					Result.extend (table.key, Firewall_status.blocked_ports)
				end
			end
		end

	put_rule (a_command: STRING; address: NATURAL_32; port: NATURAL_16)
		do
			if attached rule_buffer as buffer then
				buffer.append (a_command)
				buffer.append_character (':')
				IP_address.append_to_string (address, buffer)
				buffer.append_character (':')
				buffer.append_natural_16 (port)
			-- New line at end of all rules necessary for Bash "while read line; do" loop to work
				buffer.append_character ('%N')
			end
		end

	request_remote_address_32: NATURAL
		do
			Result := request.remote_address_32
		end

	update_day_list
		-- redeem any ip addresses older than `config.ban_rule_duration' days
		local
			first_date, l_day_now: INTEGER
		do
			l_day_now := day_now
			if l_day_now > day_list.last then
				day_list.extend (l_day_now)
			end
			if day_list.full then
			-- allow previously blocked ip address > config.ban_rule_duration
				first_date := day_list.first
				day_list.remove_head (1)
				if attached new_redeemed_ip_list (first_date) as list then
					list.to_array.do_all (agent firewall_status_table.remove)
					allow (list)
				end
			end
		end

	update_firewall
		-- update firewall rules using script at location `block_ip_path'
		require
			ends_with_new_line: rule_buffer.count > 0 implies rule_buffer [rule_buffer.count] = '%N'
		do
			if rule_buffer.count > 0 then
				file_mutex.try_locking_until (50)
				File.write_text (block_ip_path, rule_buffer)
				file_mutex.unlock
			end
			rule_buffer.wipe_out
		end

feature {NONE} -- Internal attributes

	block_ip_path: FILE_PATH
		-- path to list of commands that is monitored by Bash script for changes

	date: DATE

	day_list: EL_ARRAYED_LIST [INTEGER]

	filter_table: EL_URL_FILTER_TABLE

	file_mutex: EL_FILE_MUTEX
		-- file_mutex for writing to `block_ip_path' so that script reading file must wait to process

	monitored_logs: ARRAY [EL_TODAYS_LOG_ENTRIES]

	rule_buffer: STRING

feature {NONE} -- Constants

	Command: TUPLE [allow, block: STRING]
		-- commands with new line character
		once
			Result := ["allow", "block"]
		end

	Firewall_status: EL_FIREWALL_STATUS
		once
			create Result
		end

note
	notes: "[
		This servlet communicates with the Bash script below to add firewall rules
		for HTTP and HTTPS ports. The script must be running as root to invoke ufw command.
		
		To install the script for testing type:
		
			sudo cp --update $EIFFEL_LOOP/Bash_library/network/run_service_ip_address_blocking.sh /usr/local/bin

		The configuration file for [$source EL_SERVICE_CONFIGURATION] needs an entry like the following to invoke
		the script:

			service_configuration:
				screen_list:
					# Scripts
					item:
						name = "IP address blocking"; history_count = 200; sudo = true
						bash_script_name = "run_service_ip_address_blocking.sh myching.software"

	]"

end