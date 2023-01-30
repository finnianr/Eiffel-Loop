note
	description: "[
		Character escape table initializeable by a string like the following example for C language
		
			"%T:=t, %N:=n, \:=\"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-30 9:53:28 GMT (Monday 30th January 2023)"
	revision: "4"

class
	EL_ESCAPE_TABLE

inherit
	HASH_TABLE [CHARACTER_32, CHARACTER_32]
		rename
			make as make_table
		end

create
	make, make_simple, make_inverted

feature {NONE} -- Initialization

	make (escape: CHARACTER_32; character_map: STRING_GENERAL)
		-- make table where characters are transformed into another character prefixed by `escape_character'
		-- `character_map' is a comma separated list of assignments. See description above.
		require
			contains_assignment:
				across adjusted_list (character_map) as str all
					str.item.substring_index (":=", 1) = 2
				end
			size_is_4: across adjusted_list (character_map) as str all str.item.count = 4 end
		local
			index: INTEGER
		do
			escape_character := escape
			make_table (character_map.count)
			 across adjusted_list (character_map) as str loop
			 	index := str.item.substring_index (":=", 1)
			 	if index = 2 and then str.item.count = 4 then
			 		extend (str.item [4], str.item [1])
			 	end
			 end
		ensure
			full: count = character_map.occurrences (',') + 1
			has_escape: has (escape_character)
		end

	make_inverted (other: EL_ESCAPE_TABLE)
		do
			escape_character := other.escape_character
			make_table (other.count)
			across other as table loop
				extend (table.key, table.item)
			end
		end

	make_simple (escape: CHARACTER_32; character_list: READABLE_STRING_GENERAL)
		-- make table where characters are not transformed but merely prefixed by `escape_character'
		local
			i: INTEGER
		do
			escape_character := escape
			make_table (character_list.count + 1)
			extend (escape, escape)
			from i := 1 until i > character_list.count loop
				extend (character_list [i], character_list [i])
				i := i + 1
			end
		ensure
			same_keys_and_items: across current_keys as key all item (key.item) = key.item end
			has_escape: has (escape_character)
		end

feature -- Access

	adjusted_list (str: STRING_GENERAL): LIST [STRING_GENERAL]
		local
			map: STRING_GENERAL
		do
			Result := str.split (',')
			across Result as list loop
				map := list.item
				from until map.count = 0 or else map [1] /= ' ' loop
					map.remove (1)
				end
			end
		end

	escape_character: CHARACTER_32

feature -- Element change

	set_escape_character (a_escape_character: CHARACTER_32)
		do
			escape_character := a_escape_character
		end

feature -- Conversion

	inverted: EL_ESCAPE_TABLE
		do
			create Result.make_inverted (Current)
		end
end