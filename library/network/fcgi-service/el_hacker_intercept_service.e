note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 7:20:44 GMT (Monday 26th August 2024)"
	revision: "20"

class
	EL_HACKER_INTERCEPT_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			config, error_check, description, on_shutdown, log_separator
		end

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE

create
	make_port

feature -- Access

	Description: STRING = "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating iptables rule blocking IP address
	]"

	config: EL_HACKER_INTERCEPT_CONFIG

feature -- Basic operations

	error_check (application: EL_FALLIBLE)
		-- check for errors before execution
		local
			sendmail: EL_TODAYS_SENDMAIL_LOG; error: EL_ERROR_DESCRIPTION
		do
			create sendmail.make
			if not sendmail.is_log_readable then
				create error.make (sendmail.Default_log_path)
				application.put (error)
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
			end
		end

	send_blocking_script_alert
		do
			do_nothing
		end

feature -- Status query

	is_blocking_script_operational: BOOLEAN
		-- `True' if run_service_ip_address_blocking.sh script is operational
		do
			Result := True
		end

feature {NONE} -- Event handling

	on_shutdown
		do
			if servlet_table.has_key (Default_servlet_key)
				and then attached {EL_HACKER_INTERCEPT_SERVLET} servlet_table.found_item as servlet
			then
				servlet.store_status_table (Firewall_status_data_path)
			end
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

	new_servlet: EL_HACKER_INTERCEPT_SERVLET
		do
			create Result.make (Current)
		end

feature {EL_HACKER_INTERCEPT_SERVLET} -- Constants

	IP_blocking_script_name: STRING = "run_service_ip_address_blocking.sh"

	Firewall_status_data_path: FILE_PATH
		once
			Result := Directory.Sub_app_data + "firewall-status.dat"
		end

end