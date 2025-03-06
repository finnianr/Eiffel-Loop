note
	description: "[
		Intercept hacking attempts, returning 404 `file not found' message as plaintext
		and creating firewall rule blocking IP address for malicious requests.
		
		Also scans auth.log and mail.log for attacks and blocks those as well.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-05 18:33:21 GMT (Wednesday 5th March 2025)"
	revision: "56"

class
	EL_404_INTERCEPT_SERVLET

inherit
	FCGI_HTTP_SERVLET
		rename
			make as make_servlet
		redefine
			on_shutdown, service
		end

	EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE

	EL_MODULE_GEOLOCATION; EL_MODULE_TUPLE; EL_MODULE_USER_INPUT

	EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_404_INTERCEPT_SERVICE)
		do
			make_servlet (a_service)

			create banned_list.make (5)
			create banned_tables.make_from_keys (
				<< Service_port.HTTP, Service_port.SMTP, Service_port.SSH >>,
				agent new_banned_table, False
			)
			banned_tables [Service_port.HTTP].set_related_port (Service_port.HTTPS)

			lio.put_line ("BANNED IP RULES")
			across banned_tables as table loop
				lio.put_integer_field (table.item.port_name, table.item.count)
				lio.put_new_line
			end
			create file_mutex.make (rules_path.parent + "iptables.lock")
			create timer.make
			filter_table := a_service.config.filter_table
			Geolocation.try_restore (Directory.Sub_app_data)
		end

feature -- Basic operations

	serve
		do
			banned_list.wipe_out
			if attached system_log as sys_log then
				port := sys_log.port
			-- checked mail.log and auth.log for hacker intrusions
				if banned_tables.has_key (port) then
					sys_log.intruder_list.do_all (agent categorize_request)
				end
			else
				port := Service_port.HTTP
				if banned_tables.has_key (port) then
					categorize_request (request_remote_address_32)
				end
			end
			if banned_list.count > 0 then
				log.enter ("serve")

				if banned_list.has_value (Status.malicious) and then banned_tables.found then
					update_rules (banned_tables.found_item)
				end

			-- While geo-location is being looked up for address, (which can take a second or two)
			-- a firewall rule is being added in time for next intrusion from same address

				timer.start -- time geolocation lookups which involve network calls
				across banned_list as list loop
					log.put_labeled_string (Service_port.name (port), list.value)
					log.put_spaces (1)
					if attached request.relative_path_info as path
						and then attached Geolocation.for_number (list.key) as location
					then
						log.put_string (path)
						if path.count + location.count <= 70 then
							log.put_spaces (1) -- fits on one line
						else
							log.put_new_line -- split on two lines
						end
						log.put_labeled_string (address_string (list.key), location)
						log.put_new_line
					end
				end
				timer.stop
				if banned_list.has_value (Status.pending_rule) then
				-- stall for time while ufw finishes reloading updated rules
					lio.put_line ("Waiting for 0.2 seconds for rule to take effect..")
					execution.sleep ((200 - timer.elapsed_millisecs).max (0))
				end
				if port = Service_port.HTTP then
					response.send_error (
						Http_status.not_found, once "File not found", Text_type.plain, {EL_ENCODING_TYPE}.Latin_1
					)
				else
					response.set_content_ok
				end
				log.exit
			end
		end

feature -- Access

	system_log: detachable EL_RECENT_LOG_ENTRIES

feature -- Element change

	set_system_log (a_system_log: like system_log)
		do
			system_log := a_system_log
		end

feature -- Status query

	has_system_log: BOOLEAN
		do
			Result := attached system_log
		end

feature {NONE} -- Implementation

	address_string (ip_number: NATURAL): STRING
		do
			Result := IP_address.to_string (ip_number)
		end

	categorize_request (ip_number: NATURAL)
		require
			banned_table_found: banned_tables.found
		do
			if banned_tables.found_item.has_address (ip_number) then
			-- Firewall rule exists but has not yet taken effect
				banned_list.extend (ip_number, Status.pending_rule)

			elseif port = Service_port.HTTP and then attached request.relative_path_info.as_lower.to_utf_8 as path then
				if request.headers.user_agent.is_empty then
					banned_list.extend (ip_number, Status.malicious)

				elseif filter_table.is_whitelisted (path) then
					banned_list.extend (ip_number, Status.whitelisted)

				elseif filter_table.is_hacker_probe (path) then
					banned_list.extend (ip_number, Status.malicious)
				else
					banned_list.extend (ip_number, Status.suspicious)
				end
			else -- is mail spammer or ssh hacker
				banned_list.extend (ip_number, Status.malicious)
			end
		end

	new_banned_table (a_port: NATURAL_16): EL_BANNED_IP_TABLES_SET
		do
			create Result.make (a_port, rules_path.parent, 100)
			if a_port = Service_port.http then
				Result.set_related_port (Service_port.https)
			end
		end

	on_shutdown
		local
			ports_table: EL_PORT_BIT_MAP_TABLE; inserts: TUPLE
		do
			create ports_table.make (Port_list, rule_count)
			across banned_tables as table loop
				if attached table.item as ip_set then
					ports_table.append (ip_set) -- merge 3 tables into one
					ip_set.limit_entries (service.config.maximum_rule_count)
					lio.put_labeled_substitution ("Saving", "%S %S rules", [ip_set.count, ip_set.port_name])
					lio.put_new_line
					ip_set.serialize_all
				end
			end
		-- Report on any multi-port attacks
			if attached ports_table.multi_port_map_list as map_list and then map_list.count > 0 then
				lio.put_new_line
				lio.put_line ("MULTI-PORT ATTACKS")
				across map_list as list loop
					inserts := [list.value, Ip_address.to_string (list.key)]
					lio.put_labeled_substitution (Geolocation.for_number (list.key), "%S (%S)", inserts)
					lio.put_new_line
				end
				lio.put_new_line
				User_input.press_enter
			end
			Geolocation.store (Directory.Sub_app_data)
		end

	request_remote_address_32: NATURAL
		-- redefined in test servlet
		do
			Result := request.remote_address_32
		end

	rule_count: INTEGER
		do
			Result := banned_tables.sum_integer (agent {EL_BANNED_IP_TABLES_SET}.count)
		end

	rules_path: FILE_PATH
		do
			Result := service.rules_path
		end

	update_rules (ip_tables_set: EL_BANNED_IP_TABLES_SET)
		-- update firewall rules from `banned_list' using Bash script monitoring `rules_path'
		-- (run_service_update_ip_bans.sh)
		local
			malicious_count: INTEGER
		do
			across banned_list as list loop
				if list.value = Status.malicious then
					ip_tables_set.put (list.key)
					malicious_count := malicious_count + 1
				end
			end
			file_mutex.try_until_locked (50)
			log.put_labeled_substitution (once "Storing", once "%S additional rules.", [malicious_count])

			ip_tables_set.serialize_recent -- closing file notifies Bash script line
		--	while inotifywait -q -e close_write $rules_path 1>/dev/null; do

			lio.put_integer_field (once " New count", rule_count)
			lio.put_new_line_x2
			file_mutex.unlock
		end

feature {NONE} -- Internal attributes

	banned_list: EL_ARRAYED_MAP_LIST [NATURAL, IMMUTABLE_STRING_8]
		-- banned list of IP address mapped to thread status

	banned_tables: EL_HASH_TABLE [EL_BANNED_IP_TABLES_SET, NATURAL_16]

	file_mutex: EL_NAMED_FILE_LOCK
		-- file_mutex for writing to `rules_path' so that script reading file must wait to process

	filter_table: EL_URI_FILTER_TABLE

	port: NATURAL_16
		-- port of attack

	service: EL_404_INTERCEPT_SERVICE

	timer: EL_EXECUTION_TIMER

feature {NONE} -- Constants

	Port_list: ARRAY [NATURAL_16]
		once
			Result := << Service_port.HTTP, Service_port.SMTP, Service_port.SSH >>
		end

	Status: TUPLE [malicious, pending_rule, suspicious, whitelisted: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "Malicious, Pending rule, Suspicious, Whitelisted")
		end

note
	notes: "[
		This servlet communicates with the Bash script below to add firewall rules
		for HTTP and HTTPS ports. The script must be running as root to invoke ufw command.
		
		To install the script for testing type:
		
			sudo cp --update $EIFFEL_LOOP/Bash_library/network/run_service_update_ip_bans.sh /usr/local/bin

		The configuration file for ${EL_SERVICE_CONFIGURATION} needs an entry like the following to invoke
		the script:

			service_configuration:
				screen_list:
					# Scripts
					item:
						name = "Firewall updating service"; history_count = 200; sudo = true
						bash_command:
							"""
								run_service_update_ip_bans.sh myching.software
							"""

	]"

end