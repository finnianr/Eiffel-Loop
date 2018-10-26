note
	description: "Constants for class STRING_32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-18 9:37:25 GMT (Thursday 18th October 2018)"
	revision: "6"

class
	EL_STRING_32_CONSTANTS

feature {NONE} -- Implemenation

	character_string_32 (uc: CHARACTER_32): STRING_32
		do
			Result := n_character_string_32 (uc, 1)
		end

	n_character_string_32 (uc: CHARACTER_32; n: NATURAL): STRING_32
		local
			key: NATURAL_64
		do
			key := n |<< 32 | uc.natural_32_code
			if Character_string_32_table.has_key (key) then
				Result := Character_string_32_table.found_item
			else
				create Result.make_filled (uc, n.to_integer_32)
				Character_string_32_table.extend (Result, key)
			end
		end

feature {NONE} -- Constants

	Character_string_32_table: HASH_TABLE [STRING_32, NATURAL_64]
		once
			create Result.make (7)
		end

	Empty_string_32: STRING_32
		once
			create Result.make_empty
		end

	frozen String_32_pool: EL_STRING_POOL [STRING_32]
		once
			create Result.make (3)
		end

invariant
	string_32_always_empty: Empty_string_32.is_empty
end
