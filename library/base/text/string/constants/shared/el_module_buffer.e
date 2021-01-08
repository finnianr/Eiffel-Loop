note
	description: "Access to routines of [$source EL_ZSTRING_BUFFER_ROUTINES] via `buffer'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 15:31:18 GMT (Friday 8th January 2021)"
	revision: "12"

deferred class
	EL_MODULE_BUFFER

inherit
	EL_MODULE

feature {NONE} -- Implementation

	buffer: EL_ZSTRING_BUFFER_ROUTINES
		do
		end

end