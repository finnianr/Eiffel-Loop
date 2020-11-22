note
	description: "Servlet that returns `OK' as a response."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-22 17:04:04 GMT (Sunday 22nd November 2020)"
	revision: "8"

class
	EL_OK_SERVLET

inherit
	FCGI_HTTP_SERVLET

create
	make

feature {NONE} -- Basic operations

	serve
		do
			response.set_content_ok
		end
end