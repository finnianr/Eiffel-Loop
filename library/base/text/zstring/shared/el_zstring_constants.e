note
	description: "Constants for class ${EL_ZSTRING} (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-20 13:04:28 GMT (Tuesday 20th August 2024)"
	revision: "20"

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
			create Result.make
		end

invariant
	string_always_empty: Empty_string.is_empty
end