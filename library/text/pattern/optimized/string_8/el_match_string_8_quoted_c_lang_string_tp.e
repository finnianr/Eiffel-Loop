note
	description: "[
		[$source EL_MATCH_STRING_8_QUOTED_STRING_TP] implemented for C language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:15:10 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_STRING_8_QUOTED_C_LANG_STRING_TP

inherit
	EL_MATCH_STRING_8_QUOTED_STRING_TP
		redefine
			unescaped_code
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

	EL_C_LANGUAGE_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: READABLE_STRING_8; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index]].to_natural_32
			end
		end

end