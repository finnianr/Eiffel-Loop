note
	description: "Servlet that returns `OK' as a response."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-02 12:37:15 GMT (Friday 2nd March 2018)"
	revision: "5"

class
	FCGI_OK_SERVLET

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
