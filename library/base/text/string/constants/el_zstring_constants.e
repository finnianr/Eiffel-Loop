note
	description: "Constants for class [$source EL_ZSTRING] (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-18 10:09:16 GMT (Thursday 18th November 2021)"
	revision: "14"

deferred class
	EL_ZSTRING_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

	frozen String_pool: EL_STRING_POOL [ZSTRING]
		once
			create Result.make
		end

invariant
	string_always_empty: Empty_string.is_empty
end