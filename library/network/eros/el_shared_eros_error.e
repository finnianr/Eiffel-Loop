note
	description: "Shared eros error"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-13 19:43:15 GMT (Monday 13th January 2020)"
	revision: "1"

deferred class
	EL_SHARED_EROS_ERROR

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Error: EL_EROS_ERRORS_ENUM
		once
			create Result.make
		end
end
