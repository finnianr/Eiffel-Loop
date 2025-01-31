note
	description: "Shared instance of ${FCGI_HEADER_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-01-31 8:34:00 GMT (Friday 31st January 2025)"
	revision: "5"

deferred class
	FCGI_SHARED_HEADER

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Header: FCGI_HEADER_ENUM
		once
			create Result.make
		end

end