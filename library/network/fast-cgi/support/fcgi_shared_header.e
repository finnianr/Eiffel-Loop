note
	description: "Shared header keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-04 10:11:22 GMT (Monday 4th November 2024)"
	revision: "4"

deferred class
	FCGI_SHARED_HEADER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Header: FCGI_HEADER_ENUMERATION
		once
			create Result.make
		end

end