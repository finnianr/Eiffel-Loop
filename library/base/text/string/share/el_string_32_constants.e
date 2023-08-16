note
	description: "Constants for class STRING_32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-03 10:12:35 GMT (Thursday 3rd August 2023)"
	revision: "19"

deferred class
	EL_STRING_32_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	EL_string_32: EL_STRING_32
		-- provides access to unexported attributes and constants
		once
			create Result.make_empty
		end

	Empty_string_32: STRING_32
		once
			create Result.make_empty
		end

	String_32_searcher: STRING_32_SEARCHER
		once
			Result := EL_string_32.String_searcher
		end

invariant
	string_32_always_empty: Empty_string_32.is_empty
end