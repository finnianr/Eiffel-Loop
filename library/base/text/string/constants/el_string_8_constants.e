note
	description: "Common constants for class STRING"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 14:37:00 GMT (Wednesday 17th October 2018)"
	revision: "5"

class
	EL_STRING_8_CONSTANTS

feature {NONE} -- STRING_8

	Empty_string_8: STRING = ""

	Ellipsis_string_8: STRING = ".."

	character_string_8 (c: CHARACTER): STRING
		do
			if Character_string_8_table.has_key (c) then
				Result := Character_string_8_table.found_item
			else
				create Result.make_filled (c, 1)
				Character_string_8_table.extend (Result, c)
			end
		end

feature {NONE} -- Constants

	Character_string_8_table: HASH_TABLE [STRING, CHARACTER]
		once
			create Result.make (7)
		end

	frozen String_8_pool: EL_STRING_POOL [STRING]
		once
			create Result.make (3)
		end

invariant
	string_8_always_empty: Empty_string_8.is_empty
	ellipsis_size_is_two: Ellipsis_string_8.count = 2
end
