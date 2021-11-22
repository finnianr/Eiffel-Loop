note
	description: "Constants for class STRING_32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-21 16:37:35 GMT (Sunday 21st November 2021)"
	revision: "15"

deferred class
	EL_STRING_32_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Empty_string_32: STRING_32
		once
			create Result.make_empty
		end

invariant
	string_32_always_empty: Empty_string_32.is_empty
end