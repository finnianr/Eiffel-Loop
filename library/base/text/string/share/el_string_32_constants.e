note
	description: "Constants for class STRING_32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-15 10:55:44 GMT (Wednesday 15th March 2023)"
	revision: "17"

deferred class
	EL_STRING_32_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Empty_string_32: STRING_32
		once
			create Result.make_empty
		end

	Accessible_string_32: EL_STRING_32
		-- to provide access to unexported constants
		once
			create Result.make_empty
		end

invariant
	string_32_always_empty: Empty_string_32.is_empty
end