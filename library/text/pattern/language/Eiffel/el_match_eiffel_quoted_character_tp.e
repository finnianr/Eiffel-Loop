note
	description: "[
		Match quoted character with escaping for Eiffel language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-14 9:23:24 GMT (Monday 14th November 2022)"
	revision: "1"

class
	EL_MATCH_EIFFEL_QUOTED_CHARACTER_TP

inherit
	EL_MATCH_QUOTED_CHARACTER_TP

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	decoded (text: READABLE_STRING_GENERAL; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		local
			buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index].to_character_8].to_character_32

			elseif text [start_index + 1] = '/' and then text [end_index] = '/'
				and then attached buffer.empty as str
			then
				str.append_substring_general (text, start_index + 2, end_index - 1)
				Result := str.to_natural.to_character_32
			end
		end

end