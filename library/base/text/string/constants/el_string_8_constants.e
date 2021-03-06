note
	description: "Constants for class STRING"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-08 16:29:12 GMT (Friday 8th January 2021)"
	revision: "13"

deferred class
	EL_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Empty_string_8: STRING = ""

	frozen String_8_pool: EL_STRING_POOL [STRING]
		once
			create Result.make
		end

invariant
	string_8_always_empty: Empty_string_8.is_empty
end