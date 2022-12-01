note
	description: "String 8 edition history"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_STRING_8_EDITION_HISTORY

inherit
	EL_STRING_EDITION_HISTORY [STRING_8]

create
	make

feature {NONE} -- Edition operations

	insert_character (c: CHARACTER_32; start_index: INTEGER)
		do
			string.insert_character (c.to_character_8, start_index)
			caret_position := start_index + 1
		end

	insert_string (s: STRING_8; start_index: INTEGER)
		do
			string.insert_string (s, start_index)
			caret_position := start_index + s.count
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			string.remove_substring (start_index, end_index)
			caret_position := start_index
		end

	replace_substring (s: STRING_8; start_index, end_index: INTEGER)
		do
			string.replace_substring (s, start_index, end_index)
			caret_position := start_index + 1
		end

end