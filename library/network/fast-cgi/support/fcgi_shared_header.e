note
	description: "Shared header keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-17 13:48:16 GMT (Tuesday 17th November 2020)"
	revision: "1"

deferred class
	FCGI_SHARED_HEADER

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Header: TUPLE [
		cache_control, content_length, content_type, expires, last_modified, pragma, set_cookie, server, status: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"Cache-control, Content-Length, Content-Type, Expires, Last-Modified, Pragma, Set-Cookie, Server, Status"
			)
		end

end