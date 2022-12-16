note
	description: "Constants for class STRING"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-16 16:32:49 GMT (Friday 16th December 2022)"
	revision: "16"

deferred class
	EL_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Comma_space: STRING = ", "

	Comma_only: STRING = ","

	Empty_string_8: STRING = ""

invariant
	string_8_always_empty: Empty_string_8.is_empty
end