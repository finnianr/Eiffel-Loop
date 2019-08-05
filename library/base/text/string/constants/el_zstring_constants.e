note
	description: "Constants for class [$source EL_ZSTRING] (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:35:55 GMT (Monday 5th August 2019)"
	revision: "8"

deferred class
	EL_ZSTRING_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implemenation

	character_string (uc: CHARACTER_32): ZSTRING
		do
			Result := n_character_string (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: NATURAL_64): ZSTRING
		local
			key: NATURAL_64
		do
			key := n |<< 32 | uc.natural_32_code
			if Character_string_table.has_key (key) then
				Result := Character_string_table.found_item
			else
				create Result.make_filled (uc, n.to_integer_32)
				Character_string_table.extend (Result, key)
			end
		ensure
			valid_result: Result.occurrences (uc) = n.to_integer_32
		end

feature {NONE} -- Constants

	Character_string_table: HASH_TABLE [ZSTRING, NATURAL_64]
		once
			create Result.make (7)
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
