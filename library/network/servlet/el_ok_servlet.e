note
	description: "[
		Servlet that returns `OK' as a response. Useful for closing down a background servlet by
		first calling `{EL_FAST_CGI_SERVLET_SERVICE}.set_end_application' and then invoking this 
		servlet using CURL.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	EL_OK_SERVLET

inherit
	EL_HTTP_SERVLET

create
	make

feature {NONE} -- Basic operations

	serve (request: like new_request; response: like new_response)
		do
			response.set_content_ok
		end
end