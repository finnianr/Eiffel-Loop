note
	description: "[
		[$source EL_MATCH_ZSTRING_QUOTED_STRING_TP] implemented for C language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 11:22:33 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_ZSTRING_QUOTED_C_LANG_STRING_TP

inherit
	EL_MATCH_ZSTRING_QUOTED_STRING_TP
		redefine
			unescaped_code
		end

	EL_C_LANGUAGE_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: ZSTRING; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := Codec.as_z_code (Code_table [text.item_8 (end_index)].to_character_32)
			end
		end

end