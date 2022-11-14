note
	description: "[
		[$source EL_MATCH_ZSTRING_QUOTED_STRING_TP] implemented for Eiffel language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 11:22:50 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_ZSTRING_QUOTED_EIFFEL_STRING_TP

inherit
	EL_MATCH_ZSTRING_QUOTED_STRING_TP

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	unescaped_code (text: ZSTRING; start_index, end_index, sequence_count: INTEGER): NATURAL
		local
			buffer: EL_ZSTRING_BUFFER_ROUTINES
		do
			if sequence_count = 2 then
				Result := Codec.as_z_code (Code_table [text.item_8 (end_index)].to_character_32)

			elseif text.item_8 (start_index + 1) = '/' and then text.item_8 (end_index) = '/'
				and then attached buffer.empty as str
			then
				str.append_substring (text, start_index + 2, end_index - 1)
				Result := str.to_natural
			end
		end

end