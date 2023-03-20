note
	description: "Constants for class STRING"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-20 9:07:31 GMT (Monday 20th March 2023)"
	revision: "18"

deferred class
	EL_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Comma_space: STRING = ", "

	Comma_only: STRING = ","

	Ellipsis_dots: STRING
		once
			create Result.make_filled ('.', 2)
		end

	Empty_string_8: STRING = ""

	accessible_string_8: EL_STRING_8
		-- to provide access to unexported constants
		once
			create Result.make_empty
		end

invariant
	string_8_always_empty: Empty_string_8.is_empty
end