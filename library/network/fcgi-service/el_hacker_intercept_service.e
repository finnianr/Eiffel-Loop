note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-23 9:12:46 GMT (Monday 23rd October 2023)"
	revision: "10"

class
	EL_HACKER_INTERCEPT_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			config, error_check, description
		end

	EL_MODULE_EXECUTABLE

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
			sendmail: EL_SENDMAIL_LOG; error: EL_ERROR_DESCRIPTION
		do
			create sendmail.make_default
			if not sendmail.is_log_readable then
				create error.make (sendmail.Default_log_path)
				error.set_lines ("[
					Current user not part of 'adm' group.
					Use command:
					
						sudo usermod -aG adm <username>
					
					Then re-login for command to take effect.
				]")
				application.put (error)
			end
		end

feature {NONE} -- Implementation

	initialize_servlets
		do
			servlet_table [Default_servlet_key] := new_servlet
		end

	new_servlet: EL_HACKER_INTERCEPT_SERVLET
		do
			if Executable.Is_work_bench then
				create {EL_HACKER_INTERCEPT_TEST_SERVLET} Result.make (Current)
			else
				create Result.make (Current)
			end
		end

end