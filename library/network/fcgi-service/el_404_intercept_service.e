note
	description: "[
		Set as the default handler for a web server, this service
		intercept hacking attempts, returning 404 `file not found' message as plaintext
		and updating firewall rules blocking the IP address.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-05 12:31:33 GMT (Wednesday 5th March 2025)"
	revision: "33"

class
	EL_404_INTERCEPT_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			config, error_check, description, make, log_request, on_served
		end

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE; EL_MODULE_IP_ADDRESS; EL_MODULE_TUPLE

create
	make_port, make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH)
		local
			ip_tables_set: EL_BANNED_IP_TABLES_SET
		do
			Precursor (config_path)

		-- From script: run_service_update_ip_bans.sh	
		-- dir_path=/var/local/$domain_name
		-- rules_path=$dir_path/iptable-$1.rules
			create ip_tables_set.make_empty
			rules_path := config.server_socket_path.parent + ip_tables_set.updates_name

			create monitored_logs.make_equal (2)
			monitored_logs [URI.auth_log_modified] := new_authorization_log
			monitored_logs [URI.mail_log_modified] := new_sendmail_log
		end

feature -- Access

	Description: STRING = "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating iptables rule blocking IP address
	]"

	config: EL_404_INTERCEPT_CONFIG

	rules_path: FILE_PATH
		-- path to file: /var/local/<$domain>/iptable-new.rules

feature -- Basic operations

	error_check (application: EL_FALLIBLE)
		-- check for errors before execution
		local
			sendmail: EL_RECENT_MAIL_LOG_ENTRIES; error: EL_ERROR_DESCRIPTION
		do
			create sendmail.make (30)
			if attached config.missing_match_files as name_list and then name_list.count > 0 then
				create error.make ("Missing URI matching lists in configuration directory")
				across name_list as list loop
					error.extend (list.item)
				end
				application.put (error)
			end
			if not rules_path.exists then
				create error.make ("missing rules file")
				error.extend (rules_path)
				application.put (error)

			end
			if not is_update_script_operational then
				create error.make (Update_firewall_script_name)
				error.extend_substituted ("Active screen session name %"%S%" not found", [config.screen_session_name])
				application.put (error)

			end
			if not sendmail.is_log_readable then
				create error.make (sendmail.Default_log_path)
				if is_user_in_admin_group then
					error.set_lines ("File not readable")
				else
					error.set_lines ("[
						Current user not part of 'adm' group.
						Use command:
						
							sudo usermod -aG adm <username>
						
						Then re-login for command to take effect.
					]")
				end
				application.put (error)
			end
		end

feature -- Status query

	is_update_script_operational: BOOLEAN
		-- `True' if run_service_update_ip_bans.sh script is operational
		-- as a screen command session
		do
			Screen_list_command.execute
			Result := Screen_list_command.name_list.has (config.screen_session_name)
		end

feature {NONE} -- Implementation

	initialize_servlets
		do
			servlet := new_servlet
			servlet_table [Default_servlet_key] := servlet
		end

	is_user_in_admin_group: BOOLEAN
		local
			groups: EL_CAPTURED_OS_COMMAND
		do
			create groups.make ("groups")
			groups.execute
			if groups.lines.count > 0 then
				Result := groups.lines.first.split (' ').has_item ("adm")
			end
		end

	log_request (relative_path: ZSTRING; servlet_info: STRING)
		do
			if monitored_logs.has_key (relative_path.to_shared_immutable_8)
				and then attached monitored_logs.found_item as system_log
			then
			-- check mail.log or auth.log for hacker intrusions
				system_log.update_intruder_list
				servlet.set_system_log (system_log)
				if system_log.has_intruder then
					Precursor (relative_path, servlet_info)
				end
			else
				servlet.set_system_log (Void)
				Precursor (relative_path, servlet_info)
			end
		end

	on_served
		-- called each time a request as been served
		do
			if attached servlet.system_log as sys_log then
				if sys_log.has_intruder then
					log.put_new_line
				end
			else
				log.put_new_line
			end
		end

feature {NONE} -- Factory

	new_authorization_log: EL_RECENT_AUTH_LOG_ENTRIES
		do
			create Result.make (config.log_tail_count)
		end

	new_sendmail_log: EL_RECENT_MAIL_LOG_ENTRIES
		do
			create Result.make (config.log_tail_count)
		end

	new_servlet: EL_404_INTERCEPT_SERVLET
		do
			create Result.make (Current)
		end

feature {NONE} -- Internal attributes

	monitored_logs: HASH_TABLE [EL_RECENT_LOG_ENTRIES, IMMUTABLE_STRING_8]

	servlet: EL_404_INTERCEPT_SERVLET

feature {EL_404_INTERCEPT_SERVLET} -- Constants

	Screen_list_command: EL_SCREEN_SESSIONS_COMMAND
		once
			create Result.make
		end

	URI: TUPLE [auth_log_modified, mail_log_modified: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "auth_log_modified, mail_log_modified")
		end

	Update_firewall_script_name: STRING = "run_service_update_ip_bans.sh"

end