note
	description: "Servlet that returns `OK' as a response."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

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