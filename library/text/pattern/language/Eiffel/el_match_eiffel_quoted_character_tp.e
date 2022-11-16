note
	description: "[
		Match quoted character with escaping for Eiffel language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 16:44:12 GMT (Tuesday 15th November 2022)"
	revision: "2"

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
		do
			if sequence_count = 2 then
				Result := Code_table [text [end_index].to_character_8].to_character_32

			elseif text [start_index + 1] = '/' and then text [end_index] = '/'
				and then attached core.copied_substring (text, start_index + 2, end_index - 1) as str
			then
				Result := str.to_natural.to_character_32
			end
		end

end