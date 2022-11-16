note
	description: "Constants for class [$source EL_ZSTRING] (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "16"

deferred class
	EL_ZSTRING_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

invariant
	string_always_empty: Empty_string.is_empty
end