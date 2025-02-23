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
	date: "2025-02-23 14:00:54 GMT (Sunday 23rd February 2025)"
	revision: "46"

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
			create monitored_logs.make_equal (2)
			monitored_logs [URI.auth_log_modified] := new_authorization_log
			monitored_logs [URI.mail_log_modified] := new_sendmail_log

			create additional_rules_table.make (4)
			create address_list.make (10)
			create ip_address_set.make (10)
			create rules.make (a_service.rules_path)

			rules.display_summary (log, "FIREWALL DENY RULES")
			mutex_path := rules.path.twin
			mutex_path.add_extension ("lock")
			create file_mutex.make (mutex_path)
			filter_table := a_service.config.filter_table
			Geolocation.try_restore (Directory.Sub_app_data)
		end

feature -- Basic operations

	serve
		local
			ip_number: NATURAL; log_notification_received: BOOLEAN
		do
			log.enter ("serve")

		-- check mail.log and auth.log for hacker intrusions
			if attached request.relative_path_info.to_shared_immutable_8 as path
				and then monitored_logs.has_key (path)
				and then attached monitored_logs.found_item as system_log
			then
				log_notification_received := True
				system_log.update_hacker_ip_list
				across system_log.new_hacker_ip_list as address loop
					check_ip_address (address.item, system_log.port)
				end
			end

			request_status := Threat.default_
			ip_number := request_remote_address_32

			if not log_notification_received then
				check_ip_address (ip_number, Service_port.HTTP)
			end

			if additional_rules_table.count > 0 then
				update_firewall
				additional_rules_table.wipe_out
			end

		-- While geo-location is being looked up for address, (which can take a second or two)
		-- a firewall rule is being added in time for next intrusion from same address
			log.put_string (request_status)
			log.put_labeled_string (once " URI", request.relative_path_info)
			log.put_new_line
			if not log_notification_received then
				log.put_labeled_string (once "HTTP " + address_string (ip_number), Geolocation.for_number (ip_number))
				log.put_new_line
			end

			response.send_error (
				Http_status.not_found, once "File not found", Text_type.plain, {EL_ENCODING_TYPE}.Latin_1
			)
			log.exit
		end

feature {NONE} -- Implementation

	address_string (ip_number: NATURAL): STRING
		do
			Result := IP_address.to_string (ip_number)
		end

	check_ip_address (ip_number: NATURAL; port: NATURAL_16)
		do
			if rules.is_denied (ip_number, port) then
			-- Firewall rule exists but has not yet taken effect
				log.put_labeled_string (Service_port.name (port) + once " denied to", address_string (ip_number))
				log.put_new_line
				if port = Service_port.HTTP then
					request_status := Threat.malicious
				-- stall for time while ufw finishes reloading updated rules
					execution.sleep (500)
				end

			elseif port = Service_port.HTTP
				and then attached request.relative_path_info.as_lower.to_utf_8 as path
			then
				if request.headers.user_agent.is_empty then
					additional_rules_table.extend (port, ip_number)
					request_status := Threat.malicious

				elseif filter_table.is_whitelisted (path) then
					request_status := Threat.whitelisted

				elseif filter_table.is_hacker_probe (path) then
					additional_rules_table.extend (port, ip_number)
					request_status := Threat.malicious
				else
					request_status := Threat.suspicious
				end
			else -- is mail spammer or ssh hacker
				additional_rules_table.extend (port, ip_number)
			end
		end

	new_authorization_log: EL_TODAYS_AUTHORIZATION_LOG
		do
			create Result.make
		end

	new_sendmail_log: EL_TODAYS_SENDMAIL_LOG
		do
			create Result.make
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
		-- update firewall rules from `additional_rules_table' using Bash script monitoring `rules_path'
		-- (run_service_update_firewall.sh)
		local
			port: NATURAL_16; ip_number: NATURAL
		do
			ip_address_set.wipe_out
			across additional_rules_table as table loop
				port := table.key
				lio.put_labeled_string (once "Port", Service_port.name (port))
				lio.put_new_line
				address_list.wipe_out
				across table.item_area as list loop
					ip_number := list.item
					address_list.extend (address_string (ip_number))
					ip_address_set.put (ip_number)
					Service_port.related (port).do_all (agent rules.put_entry (ip_number, ?))
				end
				lio.put_columns (address_list, 5, 0)
			end
			lio.put_new_line

			across ip_address_set as set loop
				ip_number := set.item
				if rules.denied_count (ip_number) > 2
					and then attached rules.denied_list (ip_number).joined_with_string (", ") as port_list
				then
					log.put_labeled_string (once "Multi-port attack " + port_list, address_string (ip_number))
					log.put_new_line
				end
			end
			rules.limit_entries (service.config.maximum_rule_count)
			file_mutex.try_until_locked (50)
			log.put_labeled_substitution (once "Storing", once "%S additional rules.", [additional_rules_table.sum_item_count])
			rules.store
			lio.put_integer_field (once " New count", rules.ip_address_count)
			lio.put_new_line_x2
			file_mutex.unlock
		end

feature {NONE} -- Internal attributes

	additional_rules_table: EL_GROUPED_LIST_TABLE [NATURAL, NATURAL_16]

	address_list: EL_STRING_8_LIST

	file_mutex: EL_NAMED_FILE_LOCK
		-- file_mutex for writing to `rules_path' so that script reading file must wait to process

	filter_table: EL_URI_FILTER_TABLE

	ip_address_set: EL_HASH_SET [NATURAL]

	request_status: IMMUTABLE_STRING_8
		-- URI request security status

	monitored_logs: HASH_TABLE [EL_TODAYS_LOG_ENTRIES, IMMUTABLE_STRING_8]

	rules: EL_UFW_USER_RULES

	service: EL_404_INTERCEPT_SERVICE

feature {NONE} -- Constants

	Threat: TUPLE [default_, malicious, suspicious, whitelisted: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "Default, Malicious, Suspicious, Whitelisted")
		end

	URI: TUPLE [auth_log_modified, mail_log_modified: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "auth_log_modified, mail_log_modified")
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