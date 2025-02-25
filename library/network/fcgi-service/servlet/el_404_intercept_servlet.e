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
	date: "2025-02-25 15:23:46 GMT (Tuesday 25th February 2025)"
	revision: "54"

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

	EL_MODULE_GEOLOCATION; EL_MODULE_TUPLE

	EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_404_INTERCEPT_SERVICE)
		local
			mutex_path: FILE_PATH
		do
			make_servlet (a_service)

			create banned_list.make (5)
			create rules.make (a_service.rules_path)

			rules.display_summary (log, "FIREWALL DENY RULES")
			mutex_path := rules.path.twin
			mutex_path.add_extension ("lock")
			create file_mutex.make (mutex_path)
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
				sys_log.intruder_list.do_all (agent categorize_request)
			else
				port := Service_port.HTTP
				categorize_request (request_remote_address_32)
			end
			if banned_list.count > 0 then
				log.enter ("serve")

				if banned_list.has_value (Status.malicious) then
					update_firewall
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
					lio.put_line ("Waiting for 1/2 second for rule to take effect..")
					execution.sleep ((500 - timer.elapsed_millisecs).max (0))
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
		do
			if rules.is_denied (ip_number, port) then
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

	on_shutdown
		do
			Geolocation.store (Directory.Sub_app_data)
		end

	request_remote_address_32: NATURAL
		-- redefined in test servlet
		do
			Result := request.remote_address_32
		end

	update_firewall
		-- update firewall rules from `banned_list' using Bash script monitoring `rules_path'
		-- (run_service_update_firewall.sh)
		local
			ip_number: NATURAL
		do
			across banned_list as list loop
				if list.value = Status.malicious then
					ip_number := list.key
					Service_port.related (port).do_all (agent rules.put_entry (ip_number, ?))
					if rules.denied_count (ip_number) > 2
						and then attached rules.denied_list (ip_number).joined_with_string (", ") as port_list
					then
						log.put_labeled_string (once "Multi-port attack " + port_list, address_string (ip_number))
						log.put_new_line
					end
				end
			end
			rules.limit_entries (service.config.maximum_rule_count)
			file_mutex.try_until_locked (50)
			log.put_labeled_substitution (once "Storing", once "%S additional rules.", [banned_list.count])
			rules.store
			lio.put_integer_field (once " New count", rules.ip_address_count)
			lio.put_new_line_x2
			file_mutex.unlock
		end

feature {NONE} -- Internal attributes

	banned_list: EL_ARRAYED_MAP_LIST [NATURAL, IMMUTABLE_STRING_8]
		-- banned list of IP address mapped to thread status

	file_mutex: EL_NAMED_FILE_LOCK
		-- file_mutex for writing to `rules_path' so that script reading file must wait to process

	filter_table: EL_URI_FILTER_TABLE

	port: NATURAL_16
		-- port of attack

	rules: EL_UFW_USER_RULES

	service: EL_404_INTERCEPT_SERVICE

	timer: EL_EXECUTION_TIMER

feature {NONE} -- Constants

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
		
			sudo cp --update $EIFFEL_LOOP/Bash_library/network/run_service_update_firewall.sh /usr/local/bin

		The configuration file for ${EL_SERVICE_CONFIGURATION} needs an entry like the following to invoke
		the script:

			service_configuration:
				screen_list:
					# Scripts
					item:
						name = "Firewall updating service"; history_count = 200; sudo = true
						bash_command:
							"""
								run_service_update_firewall.sh myching.software
							"""

	]"

end