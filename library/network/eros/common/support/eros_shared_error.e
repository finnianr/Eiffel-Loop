note
	description: "Shared eros error"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-19 16:20:59 GMT (Sunday 19th January 2020)"
	revision: "2"

deferred class
	EROS_SHARED_ERROR

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Error: EROS_ERRORS_ENUM
		once
			create Result.make
		end
end
