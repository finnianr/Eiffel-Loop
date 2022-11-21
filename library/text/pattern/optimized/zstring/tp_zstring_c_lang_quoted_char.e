note
	description: "[
		Match quoted character with escaping for C language and optimized for
		strings of type [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:59 GMT (Monday 21st November 2022)"
	revision: "2"

class
	TP_ZSTRING_C_LANG_QUOTED_CHAR

inherit
	TP_QUOTED_CHAR
		undefine
			i_th_is_single_quote
		end

	TP_OPTIMIZED_FOR_ZSTRING

	TP_C_LANGUAGE_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	decoded (text: ZSTRING; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		do
			if sequence_count = 2 then
				Result := Code_table [text.item_8 (end_index)].to_character_32
			end
		end

end


