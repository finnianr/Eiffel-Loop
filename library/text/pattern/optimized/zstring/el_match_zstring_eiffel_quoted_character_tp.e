note
	description: "[
		Match quoted character with escaping for Eiffel language and optimized for
		strings of type [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 16:46:01 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_MATCH_ZSTRING_EIFFEL_QUOTED_CHARACTER_TP

inherit
	EL_MATCH_QUOTED_CHARACTER_TP
		undefine
			i_th_is_single_quote
		end

	EL_MATCH_OPTIMIZED_FOR_ZSTRING

	EL_EIFFEL_TEXT_PATTERN_FACTORY
		rename
			escaped_character_sequence as new_escape_sequence
		end

create
	make

feature {NONE} -- Implementation

	decoded (text: ZSTRING; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		local
			code: NATURAL
		do
			if sequence_count = 2 then
				Result := Code_table [text.item_8 (end_index)].to_character_32

			elseif text.item_8 (start_index + 1) = '/' and then text.item_8 (end_index) = '/' then
				code := core.copied_substring (text, start_index + 2, end_index - 1).to_natural
				Result := code.to_character_32
			end
		end

end