note
	description: "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_HACKER_INTERCEPT_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			description, make_with_config, config
		end

create
	make_port

feature {EL_COMMAND_CLIENT} -- Initialization

	make_with_config (a_config: like config)
		do
			Precursor (a_config)
			if not a_config.Block_ip_path.exists then
				a_config.block ("0.0.0.0")
			end
		end

feature -- Access

	Description: STRING = "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating firewall rule blocking IP address
	]"

	config: EL_HACKER_INTERCEPT_CONFIG

feature {NONE} -- Implementation

	initialize_servlets
		do
			servlet_table [Default_servlet_key] := create {EL_HACKER_INTERCEPT_SERVLET}.make (Current)
		end

end