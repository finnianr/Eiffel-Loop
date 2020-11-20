note
	description: "Shared header keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-20 15:43:55 GMT (Friday 20th November 2020)"
	revision: "2"

deferred class
	FCGI_SHARED_HEADER

inherit
	EL_MODULE_TUPLE

feature {NONE} -- Constants

	Header: FCGI_HEADER_ENUMERATION
		once
			create Result.make
		end

end