note
	description: "Constants for class [$source EL_ZSTRING] (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-01 18:21:14 GMT (Tuesday 1st September 2020)"
	revision: "11"

deferred class
	EL_ZSTRING_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implemenation

	character_string (uc: CHARACTER_32): ZSTRING
		do
			Result := n_character_string (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: INTEGER): ZSTRING
		do
			Result := Character_string_table.item (n.to_natural_64 |<< 32 | uc.natural_32_code)
		ensure
			valid_result: Result.occurrences (uc) = n.to_integer_32
		end

	new_filled_string (key: NATURAL_64): ZSTRING
		do
			create Result.make_filled (key.to_character_32, (key |>> 32).to_integer_32)
		end

feature {NONE} -- Constants

	Character_string_table: EL_CACHE_TABLE [ZSTRING, NATURAL_64]
		once
			create Result.make_equal (7, agent new_filled_string)
		end

	Empty_string: ZSTRING
		once
			create Result.make_empty
		end

	frozen String_pool: EL_STRING_POOL [ZSTRING]
		once
			create Result.make (3)
		end

invariant
	string_always_empty: Empty_string.is_empty
end
