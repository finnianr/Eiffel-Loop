note
	description: "[
		[$source TP_RSTRING_QUOTED_STRING] implemented for C language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:58 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_RSTRING_QUOTED_C_LANG_STRING

inherit
	TP_RSTRING_QUOTED_STRING
		redefine
			unescaped_code
		end

	TP_OPTIMIZED_FOR_READABLE_STRING_8

	TP_C_LANGUAGE_FACTORY
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


