note
	description: "String 32 edition history"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-22 5:26:22 GMT (Saturday 22nd June 2024)"
	revision: "11"

class
	EL_ZSTRING_EDITION_HISTORY

inherit
	EL_STRING_EDITION_HISTORY [ZSTRING]

	EL_STRING_GENERAL_ROUTINES

create
	make

feature -- Element change

	set_string_from_general (general: READABLE_STRING_GENERAL)
		do
			set_string (as_zstring (general))
		end

	extend_from_general (general: READABLE_STRING_GENERAL)
		do
			extend (as_zstring (general))
		end

feature {NONE} -- Edition operations

	insert_character (c: CHARACTER_32; start_index: INTEGER)
		do
			string.insert_character (c, start_index)
			caret_position := start_index + 1
		end

	insert_string (s: ZSTRING; start_index: INTEGER)
		do
			string.insert_string (s, start_index)
			caret_position := start_index + s.count
		end

	remove_substring (start_index, end_index: INTEGER)
		do
			string.remove_substring (start_index, end_index)
			caret_position := start_index
		end

	replace_substring (s: ZSTRING; start_index, end_index: INTEGER)
		do
			string.replace_substring (s, start_index, end_index)
			caret_position := start_index + 1
		end

end