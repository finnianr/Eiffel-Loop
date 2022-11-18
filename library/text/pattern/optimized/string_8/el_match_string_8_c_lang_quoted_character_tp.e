note
	description: "[
		Match quoted character with escaping for C language and optimized for
		strings conforming to [$source READABLE_STRING_8]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-18 18:04:13 GMT (Friday 18th November 2022)"
	revision: "3"

class
	EL_MATCH_STRING_8_C_LANG_QUOTED_CHARACTER_TP

inherit
	EL_MATCH_QUOTED_CHARACTER_TP
		undefine
			i_th_is_single_quote
		end

	EL_MATCH_OPTIMIZED_FOR_READABLE_STRING_8

	EL_C_LANGUAGE_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	decoded (text: READABLE_STRING_8; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index]].to_character_32
			end
		end

end