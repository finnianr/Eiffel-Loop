note
	description: "Matches quoted string with escaping for C language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:57 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_QUOTED_C_LANG_STRING

inherit
	TP_QUOTED_STRING

	TP_C_LANGUAGE_FACTORY
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

