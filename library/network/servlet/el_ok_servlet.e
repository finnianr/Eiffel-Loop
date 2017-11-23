note
	description: "Servlet that returns `OK' as a response."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-30 12:44:10 GMT (Monday 30th October 2017)"
	revision: "3"

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
