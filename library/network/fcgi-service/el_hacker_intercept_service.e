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
			description, config
		end

create
	make_port

feature -- Access

	Description: STRING = "[
		Intercept hacking attempts, returning 404 file not found message as plaintext
		and creating iptables rule blocking IP address
	]"

	config: EL_HACKER_INTERCEPT_CONFIG

feature {NONE} -- Implementation

	initialize_servlets
		do
			servlet_table [Default_servlet_key] := new_servlet
		end

	new_servlet: EL_HACKER_INTERCEPT_SERVLET
		do
			if config.test_mode then
				create {EL_HACKER_INTERCEPT_TEST_SERVLET} Result.make (Current)
			else
				create Result.make (Current)
			end
		end
end
