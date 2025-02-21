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
	date: "2025-02-20 11:13:57 GMT (Thursday 20th February 2025)"
	revision: "24"

class
	EL_404_INTERCEPT_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			config, error_check, description, make, log_separator
		end

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE

create
	make_port, make

feature {EL_COMMAND_CLIENT} -- Initialization

	make (config_path: FILE_PATH)
		do
			Precursor (config_path)
			rules_path := config.server_socket_path.parent + Active_rule_path.base
		end

feature -- Access

	Description: STRING = "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating iptables rule blocking IP address
	]"

	config: EL_404_INTERCEPT_CONFIG

	rules_path: FILE_PATH
		-- path to file: /var/local/<$domain>/user.rules

feature -- Basic operations

	error_check (application: EL_FALLIBLE)
		-- check for errors before execution
		local
			sendmail: EL_TODAYS_SENDMAIL_LOG; error: EL_ERROR_DESCRIPTION
		do
			create sendmail.make
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
				error.extend (Error_template #$ [config.screen_session_name])
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
		-- `True' if run_service_update_firewall.sh script is operational
		-- as a screen command session
		do
			Screen_list_command.execute
			Result := Screen_list_command.name_list.has (config.screen_session_name)
		end

feature {NONE} -- Implementation

	initialize_servlets
		do
			servlet_table [Default_servlet_key] := new_servlet
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

	log_separator
		do
			lio.put_new_line
		end

	new_servlet: EL_404_INTERCEPT_SERVLET
		do
			create Result.make (Current)
		end

feature {EL_404_INTERCEPT_SERVLET} -- Constants

	Active_rule_path: FILE_PATH
		-- this file is updated by script run_service_update_firewall.sh
		once
			Result := "/lib/ufw/user.rules"
		end

	Error_template: ZSTRING
		once
			Result := "Active screen session name %"%S%" not found"
		end

	Screen_list_command: EL_SCREEN_SESSIONS_COMMAND
		once
			create Result.make
		end

	Update_firewall_script_name: STRING = "run_service_update_firewall.sh"

end