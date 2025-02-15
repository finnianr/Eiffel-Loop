note
	description: "[
		Intercept hacking attempts, returning 404 `file not found' message as plaintext
		and creating firewall rule blocking IP address.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-15 16:22:53 GMT (Saturday 15th February 2025)"
	revision: "40"

class
	EL_404_INTERCEPT_SERVLET

inherit
	FCGI_HTTP_SERVLET
		rename
			make as make_servlet
		redefine
			service
		end

	EL_MODULE_COMMAND; EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_FILE; EL_MODULE_FILE_SYSTEM

	EL_MODULE_GEOLOCATION

	EL_STRING_8_CONSTANTS

	EL_SHARED_SERVICE_PORT

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_404_INTERCEPT_SERVICE)
		local
			mutex_path: FILE_PATH
		do
			make_servlet (a_service)
			monitored_logs := << new_authorization_log, new_sendmail_log >>

			create rules.make (a_service.rules_path)
			rules.display_summary (log, "FIREWALL DENY RULES")

			mutex_path := rules.path.twin
			mutex_path.add_extension ("lock")
			create file_mutex.make (mutex_path)
			filter_table := a_service.config.filter_table
		end

feature -- Basic operations

	serve
		local
			ip_number: NATURAL
		do
			log.enter ("serve")

		-- check mail.log and auth.log for hacker intrusions
			across monitored_logs as list loop
				list.item.update_hacker_ip_list
				across list.item.new_hacker_ip_list as address loop
					check_ip_address (address.item, list.item.port)
				end
			end
			ip_number := request_remote_address_32

			check_ip_address (ip_number, Service_port.HTTP)

			if update_pending then
				update_firewall
			end

		-- While geo-location is being looked up for address, (which can take a second or two)
		-- a firewall rule is being added in time for next intrusion from same address
			log.put_labeled_string ("Located", Geolocation.for_number (ip_number))
			log.put_new_line

			response.send_error (
				Http_status.not_found, once "File not found", Text_type.plain, {EL_ENCODING_TYPE}.Latin_1
			)
			log.exit
		end

feature {NONE} -- Implementation

	check_ip_address (ip_number: NATURAL; port: NATURAL_16)
		do
			if port = Service_port.HTTP then
				if rules.is_denied (ip_number, port) then
					log_status (ip_number, port, True)

				elseif attached request.relative_path_info.as_lower as lower_path
					and then filter_table.is_hacker_probe (lower_path, request.headers.user_agent)
				then
					update_pending := True
				else
					log.put_labeled_string ("Permitted 404", request.relative_path_info)
					log.put_new_line
				end
			else -- is mail spammer or ssh hacker
				if rules.is_denied (ip_number, port) then
					log_status (ip_number, port, True)
				else
					update_pending := True
				end
			end
			if update_pending then
				log_status (ip_number, port, False)
				Service_port.related (port).do_all (agent rules.put_entry (ip_number, ?))
			end
			if rules.denied_count (ip_number) > 2
				and then attached rules.denied_list (ip_number).joined (';') as port_list
			then
				log.put_labeled_substitution (
					"Multi-port attack", "%S {%S}", [IP_address.to_string (ip_number), port_list]
				)
				log.put_new_line
			end
		end

	log_status (ip_number: NATURAL; port: NATURAL_16; is_blocked: BOOLEAN)
		local
			ip_4_address, name: STRING
		do
			ip_4_address := IP_address.to_string (ip_number)
			name := Service_port.name (port)
			if is_blocked then
				log.put_labeled_string ("Is blocked on port " + name, ip_4_address)
			else
				log.put_labeled_string ("Blocking on port " + name, ip_4_address)
			end
			log.put_new_line
		end

	new_authorization_log: EL_TODAYS_AUTHORIZATION_LOG
		do
			create Result.make
		end

	new_sendmail_log: EL_TODAYS_SENDMAIL_LOG
		do
			create Result.make
		end

	request_remote_address_32: NATURAL
		do
			Result := request.remote_address_32
		end

	update_firewall
		-- update firewall rules using Bash script monitoring `rules_path'
		-- (run_service_update_firewall.sh)
		do
			log.enter ("update_firewall")
			rules.limit_entries (service.config.maximum_rule_count)
			lio.put_integer_field ("Count of blocked addresses", rules.ip_address_count)
			lio.put_new_line
			file_mutex.try_until_locked (50)
			rules.store
			file_mutex.unlock
			update_pending := False
			log.exit
		end

feature {NONE} -- Internal attributes

	update_pending: BOOLEAN

	file_mutex: EL_NAMED_FILE_LOCK
		-- file_mutex for writing to `rules_path' so that script reading file must wait to process

	filter_table: EL_URI_FILTER_TABLE

	monitored_logs: ARRAY [EL_TODAYS_LOG_ENTRIES]

	rules: EL_UFW_USER_RULES

	service: EL_404_INTERCEPT_SERVICE;

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
						name = "IP address blocking"; history_count = 200; sudo = true
						bash_command:
							"""
								run_service_update_firewall.sh myching.software
							"""

	]"

end