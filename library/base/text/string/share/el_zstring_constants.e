note
	description: "Constants for class [$source EL_ZSTRING] (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-03 10:15:55 GMT (Thursday 3rd August 2023)"
	revision: "17"

deferred class
	EL_ZSTRING_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

	String_searcher: EL_ZSTRING_SEARCHER
		once
			Result := Empty_string.String_searcher
		end

invariant
	string_always_empty: Empty_string.is_empty
end