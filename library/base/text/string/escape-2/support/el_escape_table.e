note
	description: "Character escape table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 12:23:55 GMT (Wednesday 4th January 2023)"
	revision: "1"

class
	EL_ESCAPE_TABLE

inherit
	HASH_TABLE [CHARACTER_32, CHARACTER_32]
		rename
			make as make_table
		end

create
	make, make_simple

feature {NONE} -- Initialization

	make (escape: CHARACTER_32; character_map: ARRAY [READABLE_STRING_GENERAL])
		-- make table where characters are transformed into another character prefixed by `escape_character'
		require
			contains_assignment: across character_map as str all str.item.substring_index (":=", 1) = 2 end
			size_is_4: across character_map as str all str.item.count = 4 end
		local
			index: INTEGER
		do
			escape_character := escape
			make_table (character_map.count)
			 across character_map as str loop
			 	index := str.item.substring_index (":=", 1)
			 	if index = 2 and then str.item.count = 4 then
			 		extend (str.item [4], str.item [1])
			 	end
			 end
		ensure
			full: count = character_map.count
			has_escape: has (escape_character)
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

	escape_character: CHARACTER_32

end