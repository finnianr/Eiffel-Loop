note
	description: "Constants for class STRING_32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 12:16:38 GMT (Saturday 25th January 2020)"
	revision: "9"

deferred class
	EL_STRING_32_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Implemenation

	character_string_32 (uc: CHARACTER_32): STRING_32
		do
			Result := n_character_string_32 (uc, 1)
		end

	n_character_string_32 (uc: CHARACTER_32; n: NATURAL): STRING_32
		do
			Result := Character_string_32_table.item (n.to_natural_64 |<< 32 | uc.natural_32_code)
		end

	new_filled_string_32 (key: NATURAL_64): STRING_32
		do
			create Result.make_filled (key.to_character_32, (key |>> 32).to_integer_32)
		end

feature {NONE} -- Constants

	Character_string_32_table: EL_CACHE_TABLE [STRING_32, NATURAL_64]
		once
			create Result.make_equal (7, agent new_filled_string_32)
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
