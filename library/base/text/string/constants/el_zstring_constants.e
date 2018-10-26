note
	description: "Constants for class [$source EL_ZSTRING] (AKA `ZSTRING')"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-18 9:37:02 GMT (Thursday 18th October 2018)"
	revision: "6"

class
	EL_ZSTRING_CONSTANTS

feature {NONE} -- Implemenation

	character_string (uc: CHARACTER_32): ZSTRING
		do
			Result := n_character_string (uc, 1)
		end

	n_character_string (uc: CHARACTER_32; n: NATURAL): ZSTRING
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
