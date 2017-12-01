note
	description: "Servlet that returns `OK' as a response."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-13 11:29:40 GMT (Monday 13th November 2017)"
	revision: "4"

class
	EL_OK_SERVLET

inherit
	FCGI_HTTP_SERVLET

create
	make

feature {NONE} -- Basic operations

	serve (request: like new_request; response: like new_response)
		do
			response.set_content_ok
		end
end
