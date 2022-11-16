note
	description: "[
		[$source EL_MATCH_ZSTRING_QUOTED_STRING_TP] implemented for Eiffel language
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 18:23:38 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_ZSTRING_QUOTED_EIFFEL_STRING_TP

inherit
	EL_MATCH_ZSTRING_QUOTED_STRING_TP

	EL_MATCH_OPTIMIZED_FOR_ZSTRING

	EL_EIFFEL_TEXT_PATTERN_FACTORY
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

			elseif text.item_8 (start_index + 1) = '/' and then text.item_8 (end_index) = '/' then
				Result := core.copied_substring (text, start_index + 2, end_index - 1).to_natural
			end
		end

end