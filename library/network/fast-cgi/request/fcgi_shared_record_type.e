note
	description: "Fast-CGI shared record type enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	FCGI_SHARED_RECORD_TYPE

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Record_type: FCGI_RECORD_TYPE_ENUM
		once
			create Result.make
		end
end