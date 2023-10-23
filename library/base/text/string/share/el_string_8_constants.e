note
	description: "Constants related to class [$source STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-22 9:42:31 GMT (Friday 22nd September 2023)"
	revision: "22"

deferred class
	EL_STRING_8_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Comma_space: STRING = ", "

	EL_string_8: EL_STRING_8
		-- provides access to unexported attributes and constants
		once
			create Result.make_empty
		end

	Empty_string_8: STRING = ""

	String_8_searcher: STRING_8_SEARCHER
		once
			Result := EL_string_8.String_searcher
		end

invariant
	string_8_always_empty: Empty_string_8.is_empty
end