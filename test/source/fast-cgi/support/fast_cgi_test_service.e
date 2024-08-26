note
	description: "Fast CGI test service"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 8:16:05 GMT (Monday 26th August 2024)"
	revision: "8"

class
	FAST_CGI_TEST_SERVICE

inherit
	FCGI_SERVLET_SERVICE
		redefine
			description
		end

create
	make_port

feature -- Constants

	Description: STRING = "Serves HTML test page for Fast CGI"

feature {NONE} -- Implementation

	initialize_servlets
		do
			servlet_table [Default_servlet_key] := create {TEST_SERVLET}.make (Current)
		end
end