note
	description: "Access to routines of [$source EL_ZSTRING_BUFFER_ROUTINES] via `buffer'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-16 12:06:26 GMT (Sunday 16th May 2021)"
	revision: "14"

deferred class
	EL_MODULE_BUFFER

inherit
	EL_MODULE

feature {NONE} -- Implementation

	Buffer: EL_ZSTRING_BUFFER
		once
			create Result
		end

end