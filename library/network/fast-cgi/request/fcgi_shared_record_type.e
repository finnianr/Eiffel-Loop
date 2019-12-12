note
	description: "Fcgi shared record type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-12 11:33:16 GMT (Thursday 12th December 2019)"
	revision: "1"

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
