note
	description: "Access to routines of [$source EL_ZSTRING_BUFFER_ROUTINES] via `buffer'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-09-25 15:35:58 GMT (Sunday 25th September 2022)"
	revision: "15"

deferred class
	EL_MODULE_BUFFER

inherit
	EL_MODULE

feature {NONE} -- Constants

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end