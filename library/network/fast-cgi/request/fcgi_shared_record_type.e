note
	description: "Fast-CGI shared record type enumeration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-14 10:36:07 GMT (Saturday 14th December 2019)"
	revision: "2"

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
