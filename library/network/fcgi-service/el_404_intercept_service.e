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
	date: "2025-02-14 17:40:35 GMT (Friday 14th February 2025)"
	revision: "22"

class
	EL_404_INTERCEPT_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			config, error_check, description, log_separator
		end

	EL_MODULE_ARGS; EL_MODULE_EXECUTABLE

create
	make_port, make

feature -- Access

	Description: STRING = "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating iptables rule blocking IP address
	]"

	config: EL_404_INTERCEPT_CONFIG

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

	Update_firewall_script_name: STRING = "run_service_update_firewall.sh"

end