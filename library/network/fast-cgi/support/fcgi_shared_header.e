note
	description: "Shared header keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

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