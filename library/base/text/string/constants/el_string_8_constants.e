note
	description: "Constants for class STRING"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-18 9:37:19 GMT (Thursday 18th October 2018)"
	revision: "6"

class
	EL_STRING_8_CONSTANTS

feature {NONE} -- Implemenation

	character_string_8 (c: CHARACTER): STRING
		do
			Result := n_character_string_8 (c, 1)
		end

	n_character_string_8 (c: CHARACTER; n: NATURAL): STRING
		local
			key: NATURAL
		do
			key := n |<< 8 | c.natural_32_code
			if Character_string_8_table.has_key (key) then
				Result := Character_string_8_table.found_item
			else
				create Result.make_filled (c, n.to_integer_32)
				Character_string_8_table.extend (Result, key)
			end
		end

feature {NONE} -- Constants

	Character_string_8_table: HASH_TABLE [STRING, NATURAL]
		once
			create Result.make (7)
		end

	Empty_string_8: STRING = ""

	frozen String_8_pool: EL_STRING_POOL [STRING]
		once
			create Result.make (3)
		end

invariant
	string_8_always_empty: Empty_string_8.is_empty
end
