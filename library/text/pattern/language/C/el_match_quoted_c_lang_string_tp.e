note
	description: "Matches quoted string with escaping for C language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 8:18:21 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_QUOTED_C_LANG_STRING_TP

inherit
	EL_MATCH_QUOTED_STRING_TP

	EL_C_LANGUAGE_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: READABLE_STRING_GENERAL; start_index, end_index, sequence_count: INTEGER): NATURAL
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index].to_character_8].to_natural_32
			end
		end

end